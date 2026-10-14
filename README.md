# tf-stack-computer_shop

Root Terraform stack that deploys Computer Shop, a PC parts web shop with a storefront, a PC configurator, an admin sales dashboard, a support chat agent and a build evaluator model, to AWS. It configures the AWS providers and the state, then calls [tf-module-computer_shop](https://github.com/MartinSG98/tf-module-computer_shop) at a pinned release. This is the directory where you run `terraform plan` and `terraform apply`.

All the resources live in the module: the DynamoDB tables, the HTTP API and its Lambda, the evaluator Lambda, the support agent runtime, the Cognito pool, the image and frontend hosting, and the GitHub deploy roles. The application repos deploy their own code through those roles, and this stack's outputs are what their CI variables are set from. They are [computer-shop-backend](https://github.com/MartinSG98/computer-shop-backend), [computer_shop_ui](https://github.com/MartinSG98/computer_shop_ui), [computer-shop-build-eval](https://github.com/MartinSG98/computer-shop-build-eval) and [computer-shop-support-agent](https://github.com/MartinSG98/computer-shop-support-agent).

Architecture decisions are recorded in [docs/adr](docs/adr/README.md), one numbered file per decision. The cross-cutting ones (cost posture, admin auth, module versioning) live in the [module's docs/adr](https://github.com/MartinSG98/tf-module-computer_shop/tree/main/docs/adr).

## How a deploy goes

1. **Apply the stack.** The first apply creates everything, including the GitHub OIDC provider and the four deploy roles. The Lambdas start with a placeholder that answers 503, and the agent runtime with a placeholder that fails until the real code lands.
2. **Configure each repo's CI.** Set the repository variables from `terraform output` (see Outputs).
3. **Seed the catalogue.** computer-shop-backend has the scripts that fill the DynamoDB tables and the steps for syncing product images to the images bucket.
4. **Let CI deploy.** Every app repo deploys on a push to `main` or by hand, assuming its role through OIDC with no stored AWS keys. The backend and the evaluator update their Lambda, the agent uploads its zip and refreshes the runtime, and the UI syncs its build to S3 and invalidates CloudFront.

## Running it

Requires Terraform 1.5 or newer and AWS credentials for the target account.

```bash
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform plan
terraform apply
```

`terraform.tfvars` is git-ignored. The state is local in `terraform.tfstate`, also git-ignored, because this is a single-operator deployment ([ADR 0001](docs/adr/0001-local-terraform-state.md)). Moving it to an S3 backend with a lock table is the next step once applies are shared or run from CI. The provider lock file `.terraform.lock.hcl` is committed.

Both Bedrock models the module uses have to be available on demand in the deploy region: the evaluator's suggestion model (`amazon.nova-lite-v1:0` by default) and the support agent's chat model (`openai.gpt-oss-120b-1:0` by default). Without the suggestion model the build score still works and the suggestions come back empty.

## Module source

```hcl
source = "git::https://github.com/MartinSG98/tf-module-computer_shop.git?ref=v0.4.1"
```

During development, switch `main.tf` to `../tf-module-computer_shop` with both repos checked out side by side.

The module has since released v1.0.0, which composes the shared tf-modules and renames every resource to their naming convention. That is a breaking release. Every resource is replaced, the `aws.us_east_1` provider alias goes away, and it adds the `environment`, `account_shortname` and `create_github_oidc_provider` inputs. Moving this stack to it means removing the `providers` block from the module call and treating the apply as a redeploy, as described in the module's [Upgrading from v0.x](https://github.com/MartinSG98/tf-module-computer_shop#upgrading-from-v0x).

## Providers

`providers.tf` sets up two AWS providers. The default one deploys into `aws_region`, and the `us_east_1` alias is passed to the module for the CloudFront site certificate, which has to live in us-east-1. Both tag every resource with `Project` (the `project` variable) and `ManagedBy = "Terraform"`. The AWS provider is pinned to `~> 6.21`, the first line with the AgentCore runtime resource the support agent needs.

## Configuration

Copy `terraform.tfvars.example` to `terraform.tfvars` and adjust.

| Variable | Default | Purpose |
|---|---|---|
| `aws_region` | `eu-west-2` | Region to deploy into |
| `project` | `computer-shop` | Prefix for resource names and the `Project` tag |
| `cors_allow_origins` | `""` | Extra comma-separated CORS origins for the API, such as `http://localhost:5173` for local frontend work. The frontend's CloudFront URL and the site domain are always allowed |
| `github_deploy_repos` | `["MartinSG98/computer-shop-backend"]` | Repos whose `main` branch may assume the backend deploy role |
| `github_frontend_repos` | `["MartinSG98/computer_shop_ui"]` | Repos whose `main` branch may assume the frontend deploy role |
| `github_eval_repos` | `["MartinSG98/computer-shop-build-eval"]` | Repos whose `main` branch may assume the build evaluator deploy role |
| `api_domain_name` | `""` | Custom domain for the API. Empty keeps only the default invoke URL |
| `site_domain_name` | `""` | Custom domain for the site. Empty keeps only the CloudFront URL |
| `hosted_zone_name` | `""` | Route 53 public hosted zone the custom domains live in. Required when either domain is set |
| `api_throttle_rate_limit` | `20` | Steady requests per second across all API routes |
| `api_throttle_burst_limit` | `40` | Largest burst of concurrent requests |

The other module inputs stay at the module's defaults: the support agent's repo (`github_agent_repos`), both Bedrock model ids, the evaluator's CORS origin and the two demo passwords. To change one, add a variable here and pass it through in `main.tf`.

## Custom domains

To serve the API, the site or both from your own domain:

1. **Register the domain in Route 53.** That creates the public hosted zone. The module only looks the zone up, since Terraform cannot register domains.
2. **Set the names in `terraform.tfvars`.**
   ```hcl
   api_domain_name  = "api.example.com"
   site_domain_name = "example.com"
   hosted_zone_name = "example.com"
   ```
3. **Apply.** The certificates validate through DNS records the module writes. The site answers on the apex and on `www`, and both origins are added to the API's CORS list automatically.
4. **Point the frontend at the API domain.** Set the `VITE_API_BASE_URL` repository variable in computer_shop_ui to the `api_custom_domain_url` output and rerun its deploy.

Leave the three variables empty to keep the default `execute-api` and `cloudfront.net` URLs. No domain resources are created then.

## Outputs

| Output | What it is | Where it goes |
|---|---|---|
| `api_url` | Default invoke URL of the HTTP API | computer_shop_ui `VITE_API_BASE_URL` when the API has no custom domain |
| `api_custom_domain_url` | URL of the API's custom domain, `null` until one is set | computer_shop_ui `VITE_API_BASE_URL` |
| `eval_url` | The evaluator endpoint, `POST /evaluate` | |
| `lambda_function_name` | The API Lambda | |
| `cdn_base_url` | CloudFront URL of the product images | Set on the API Lambda as `CDN_BASE_URL` by the module |
| `products_table_name`, `categories_table_name`, `orders_table_name` | The three tables | The seed scripts in computer-shop-backend |
| `images_bucket_name` | Bucket for the product images | The image sync in computer-shop-backend |
| `github_deploy_role_arn` | Backend deploy role | computer-shop-backend `AWS_DEPLOY_ROLE_ARN` |
| `frontend_url` | CloudFront URL of the site | |
| `site_custom_domain_url` | URL of the site's custom domain, `null` until one is set | |
| `frontend_bucket_name` | Bucket the frontend build is synced to | computer_shop_ui `FRONTEND_BUCKET` |
| `frontend_distribution_id` | The frontend distribution | computer_shop_ui `CLOUDFRONT_DISTRIBUTION_ID` |
| `github_frontend_deploy_role_arn` | Frontend deploy role | computer_shop_ui `AWS_DEPLOY_ROLE_ARN` |
| `cognito_user_pool_id`, `cognito_app_client_id`, `cognito_region` | The frontend's auth config | computer_shop_ui `VITE_COGNITO_USER_POOL_ID` and `VITE_COGNITO_CLIENT_ID` |
| `eval_lambda_function_name` | The evaluator Lambda | computer-shop-build-eval `EVAL_LAMBDA_FUNCTION` |
| `models_bucket_name` | Bucket for the evaluator's model | computer-shop-build-eval `MODELS_BUCKET` |
| `eval_model_key` | S3 key of `model.onnx` | computer-shop-build-eval `MODEL_KEY` |
| `github_eval_deploy_role_arn` | Build evaluator deploy role | computer-shop-build-eval `AWS_DEPLOY_ROLE_ARN` |
| `agent_runtime_arn`, `agent_runtime_id` | The support agent runtime | |
| `agent_artifacts_bucket_name`, `agent_code_key` | Where the agent's code zip goes | |
| `github_agent_deploy_role_arn` | Support agent deploy role | computer-shop-support-agent `AWS_DEPLOY_ROLE_ARN` |

## Cost posture

The deployment is tuned for a bill of about $0: provisioned DynamoDB inside the free tier, Cognito Lite without threat protection, throttling instead of WAF, and local state. The trade-offs, and what a real budget would change, are in the module README under [Cost posture](https://github.com/MartinSG98/tf-module-computer_shop#cost-posture).

## Structure

```
main.tf                    the module call, pinned to a release tag
providers.tf               the default AWS provider and the us_east_1 alias, both with default tags
versions.tf                Terraform and provider versions, local state
variables.tf               stack inputs, passed through to the module
outputs.tf                 the module's outputs, re-exported for the app repos' CI
terraform.tfvars.example   starting point for terraform.tfvars (git-ignored)
.terraform.lock.hcl        provider lock, committed
docs/adr/                  architecture decision records
```
