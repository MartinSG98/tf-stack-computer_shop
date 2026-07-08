# ADR-0001: Local Terraform state (remote backend deferred)

- Status: Accepted
- Date: 2026-07-09

## Context

This stack composes the infra module and is where `plan`/`apply` run. State has
to live somewhere. It is a solo, single-operator deployment for now.

## Decision

Keep Terraform state local (`terraform.tfstate`, gitignored). Do not set up an
S3 backend + DynamoDB lock table yet.

## Consequences

- Zero cost and zero setup; fine for a single operator.
- No state locking and no shared/CI-managed applies; only safe because one person
  applies from one machine.
- Migrating to an S3 backend + lock table is the documented next step once this
  becomes shared or CI-managed (see infra ADR-0001, cost posture).

## Alternatives considered

- S3 backend + DynamoDB lock table now: the right production setup, but adds
  cost and setup for no benefit to a solo demo. Deferred.
- Terraform Cloud: an external dependency, unnecessary here.
