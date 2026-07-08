# Architecture Decision Records

Short records of significant, non-obvious decisions in this repo (lightweight
MADR: Context / Decision / Consequences / Alternatives). The system-wide infra
decisions (cost posture, admin auth, module versioning) live in the infra
module's ADRs; see `tf-module-computer_shop/docs/adr`. This stack consumes the
module by a pinned tag (module ADR-0003).

| ADR | Title |
| --- | --- |
| [0001](0001-local-terraform-state.md) | Local Terraform state (remote backend deferred) |
