# tf-stack-computer_shop

Deployment **stack** for the Computer Shop backend. Configures the AWS provider
and state, then calls the [`tf-module-computer_shop`](https://github.com/MartinSG98/tf-module-computer_shop)
module. This is where you run `plan` / `apply`.

## Prerequisites

- Terraform >= 1.5
- AWS credentials for the deploy account (the **initial** apply bootstraps the
  GitHub OIDC role; afterwards CI deploys code keylessly).

## Module source

During development the module is referenced by **local path**
(`../tf-module-computer_shop`), so both repos must be checked out as siblings.
To pin a released version, switch `main.tf` to the git source:

```hcl
source = "git::https://github.com/MartinSG98/tf-module-computer_shop.git?ref=v0.0.1"
```

## Usage

```bash
cp terraform.tfvars.example terraform.tfvars   # adjust values
terraform init
terraform plan
terraform apply
```

State is **local** (`terraform.tfstate`, gitignored).

## Outputs

`api_url`, `cdn_base_url`, table names, `images_bucket_name`,
`frontend_bucket_name`, `frontend_url`, `frontend_distribution_id`,
`lambda_function_name`, `github_deploy_role_arn`,
`github_frontend_deploy_role_arn`.

## Related

Part of the Computer Shop project:

- [computer-shop-backend](https://github.com/MartinSG98/computer-shop-backend) — FastAPI backend API
- [computer_shop_ui](https://github.com/MartinSG98/computer_shop_ui) — React/Vite/Mantine frontend
- [tf-module-computer_shop](https://github.com/MartinSG98/tf-module-computer_shop) — Terraform infrastructure module