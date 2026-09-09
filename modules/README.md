# Terraform Modules

Reusable modules shared by the environment deployment roots:

- `management-group`: creates one Azure management group.
- `role-assignment`: creates one Azure role assignment.

Production deployment roots are under `envs/prod`. Test roots can be added under `envs/test` using the same relative module paths.
