import base64
import hashlib
import hmac
import json
import logging
import os
import time

import azure.functions as func
#import logging
import requests

app = func.FunctionApp()

LM_COMPANY = os.environ.get("LM_COMPANY", "")
LM_DOMAIN = os.environ.get("LM_DOMAIN", "logicmonitor.com")
LM_ACCESS_ID = os.environ.get("LM_ACCESS_ID", "")
LM_ACCESS_KEY = os.environ.get("LM_ACCESS_KEY", "")
LM_DRY_RUN = os.environ.get("LM_DRY_RUN", "true").lower() == "true"

# LM resource property used to match a log to a resource discovered by LM Cloud.
# A wrong value here surfaces as LM error 4001/4003 rather than an HTTP failure.
LM_RESOURCE_PROPERTY = os.environ.get("LM_RESOURCE_PROPERTY", "system.azure.resourceid")

RESOURCE_PATH = "/log/ingest"
MAX_MESSAGE_BYTES = 32 * 1024

session = requests.Session()


def truncate(message: str) -> str:
    encoded = message.encode("utf-8")
    if len(encoded) <= MAX_MESSAGE_BYTES:
        return message
    return encoded[:MAX_MESSAGE_BYTES - 16].decode("utf-8", errors="ignore") + "...[truncated]"


def build_entry(record: dict, message: str) -> dict:
    entry = {
        "message": truncate(message),
        "timestamp": record.get("time") or record.get("timeStamp"),
        "severity": record.get("level"),
        "activity_type": record.get("operationName"),
        "category": record.get("category"),
        "azure_resource_id": record.get("resourceId"),
    }
    if record.get("resourceId"):
        entry["_lm.resourceId"] = {LM_RESOURCE_PROPERTY: record["resourceId"]}
    return {key: value for key, value in entry.items() if value is not None}


def parse_records(body: str) -> list[dict]:
    """Flatten an event body into one LM log entry per Azure diagnostic record.

    Azure diagnostic settings wrap many records in a single {"records": [...]} event,
    so one Event Hub message usually carries multiple logs.
    """
    try:
        payload = json.loads(body)
    except json.JSONDecodeError:
        return [build_entry({}, body)]

    records = payload.get("records") if isinstance(payload, dict) else None
    if records is None:
        records = [payload]

    entries = []
    for record in records:
        if not isinstance(record, dict):
            entries.append(build_entry({}, str(record)))
            continue
        message = json.dumps(record.get("properties", record), separators=(",", ":"))
        entries.append(build_entry(record, message))
    return entries


def lmv1_header(body: str) -> str:
    """Build a LogicMonitor LMv1 Authorization header.

    LM hashes the hex digest and then base64-encodes that string, not the raw digest.
    """
    epoch = str(int(time.time() * 1000))
    signing_input = f"POST{epoch}{body}{RESOURCE_PATH}"
    digest = hmac.new(LM_ACCESS_KEY.encode(), signing_input.encode(), hashlib.sha256).hexdigest()
    signature = base64.b64encode(digest.encode()).decode()
    return f"LMv1 {LM_ACCESS_ID}:{signature}:{epoch}"


def post_to_lm(entries: list[dict]) -> None:
    # Serialise once: the signature must cover the exact bytes that get sent.
    body = json.dumps(entries, separators=(",", ":"))
    response = session.post(
        f"https://{LM_COMPANY}.{LM_DOMAIN}/rest{RESOURCE_PATH}",
        data=body.encode("utf-8"),
        headers={"Authorization": lmv1_header(body), "Content-Type": "application/json"},
        timeout=30,
    )

    if response.status_code == 202:
        logging.info("LM accepted %d entries", len(entries))
    elif response.status_code == 207:
        logging.warning("LM rejected part of the batch: %s", response.text[:2000])
    elif response.status_code == 429 or response.status_code >= 500:
        # Transient. Raising prevents the checkpoint from advancing so the batch is retried.
        raise RuntimeError(f"LM ingest failed {response.status_code}: {response.text[:500]}")
    else:
        # Bad payload or bad credentials. Retrying would stall the partition indefinitely.
        logging.error("LM rejected batch %d: %s", response.status_code, response.text[:2000])


@app.event_hub_message_trigger(arg_name="azeventhub", event_hub_name="azureeventbridge",
                               connection="EventHubConnection") 
def eventhub_trigger(azeventhub: func.EventHubEvent):
#transform and properly format diagnostic metrics/log
#logging.info('Python EventHub trigger processed an event: %s', azeventhub.get_body().decode("utf-8"))
    body = azeventhub.get_body().decode("utf-8", errors="replace")
    entries = parse_records(body)
    if not entries:
        return

    logging.info("Event contained %d record(s)", len(entries))
    if LM_DRY_RUN:
        for entry in entries:
            logging.info("LM_ENTRY %s", json.dumps(entry, separators=(",", ":")))
        return

    post_to_lm(entries)


# This example uses SDK types to directly access the underlying EventData object provided by the Event Hubs trigger.
# To use, uncomment the section below and add azurefunctions-extensions-bindings-eventhub to your requirements.txt file
# Ref: aka.ms/functions-sdk-eventhub-python
#
# import azurefunctions.extensions.bindings.eventhub as eh
# @app.event_hub_message_trigger(
#     arg_name="event", event_hub_name="azureeventbridge", connection="adeventhubtest_EhFABridgeAccessKey_EVENTHUB"
# )
# def eventhub_trigger(event: eh.EventData):
#     logging.info(
#         "Python EventHub trigger processed an event %s",
#         event.body_as_str()
#     )
