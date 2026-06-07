# tf-stack-computer_shop

Deployment **stack** for the Computer Shop backend. Configures the AWS provider
and state, then calls the [`tf-module-computer_shop`](https://github.com/MartinSG98/tf-module-computer_shop)
module. This is where you run `plan` / `apply`.

## Prerequisites

- Terraform >= 1.5
- AWS credentials for the deploy account (the **initial** apply bootstraps the
  GitHub OIDC role; afterwards CI deploys code keylessly).
- **Bedrock model access** for the evaluator's suggestion model (default
  `amazon.nova-lite-v1:0`) enabled in the deploy region (Bedrock console → Model
  access). Without it the build score still works and suggestions just come back
  empty.

## Module source

During development the module is referenced by **local path**
(`../tf-module-computer_shop`), so both repos must be checked out as siblings.
To pin a released version, switch `main.tf` to the git source:

```hcl
source = "git::https://github.com/MartinSG98/tf-module-computer_shop.git?ref=v0.3.5"
```

## Usage

```bash
cp terraform.tfvars.example terraform.tfvars   # adjust values
terraform init
terraform plan
terraform apply
```

State is **local** (`terraform.tfstate`, gitignored).

The stack configures two AWS providers: the main one (`var.aws_region`) and an
`us_east_1` alias passed to the module for the CloudFront site certificate.

## Custom domains (optional)

To serve the API and/or site from a custom domain:

1. **Register the domain first** — Route 53 → Registered domains. This
   auto-creates the public hosted zone; Terraform only looks it up (it can't
   register domains). `.com` ≈ $15/yr + ~$6/yr hosted zone.
2. Set the vars in `terraform.tfvars` (either/both):
   ```hcl
   api_domain_name  = "api.msg-computers.com"
   site_domain_name = "msg-computers.com"
   hosted_zone_name = "msg-computers.com"
   ```
3. `terraform apply`. Cert validation is automatic via DNS; the CloudFront
   update takes a few minutes. The site origin is added to API CORS
   automatically.
4. Point the frontend at the API domain: set the `VITE_API_BASE_URL` repo
   variable to `https://api.<domain>` and redeploy.

Leave the vars empty to keep the default `*.execute-api` / `*.cloudfront.net`
URLs (no domain resources created).

## Outputs

`api_url`, `api_custom_domain_url`, `cdn_base_url`, table names,
`images_bucket_name`, `frontend_bucket_name`, `frontend_url`,
`site_custom_domain_url`, `frontend_distribution_id`, `lambda_function_name`,
`github_deploy_role_arn`, `github_frontend_deploy_role_arn`,
`eval_url`, `eval_lambda_function_name`, `models_bucket_name`, `eval_model_key`,
`github_eval_deploy_role_arn`.

(`api_custom_domain_url` / `site_custom_domain_url` are `null` until the
domains are configured.)

## Related

Part of the Computer Shop project:

- [computer-shop-backend](https://github.com/MartinSG98/computer-shop-backend) — FastAPI backend API
- [computer_shop_ui](https://github.com/MartinSG98/computer_shop_ui) — React/Vite/Mantine frontend
- [computer-shop-build-eval](https://github.com/MartinSG98/computer-shop-build-eval) — PC build scorer + suggestions (eval Lambda)
- [tf-module-computer_shop](https://github.com/MartinSG98/tf-module-computer_shop) — Terraform infrastructure module