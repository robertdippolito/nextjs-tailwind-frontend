# Frontend from Scratch Series - Infrastructure
This repository covers the frontend from scratch series from the RobOps Youtube channel. In this repository you will find the assets required to host a static webpage on AWS using Next.js and TailwindCSS.

## Table of Contents
- [About](#-about)
- [Infrastructure as Code](#-IaC-Overview)

## 🚀 About
This repository is part of a multi-part series designed to show how you can create a frontend website from scratch.

Videos related to this repository can be found here:

<a href="https://www.youtube.com/@RobOps101">![image](https://img.shields.io/badge/YouTube-FF0000?style=for-the-badge&logo=youtube&logoColor=white) </a>

## 👩‍💻 IaC Overview

The `_infra/terraform` project provisions everything needed to serve the built Next.js site through AWS:

- Versioned S3 bucket for static assets.
- ACM certificate (issued in `us-east-1`) for CloudFront HTTPS.
- CloudFront distribution protected by an Origin Access Control (OAC).
- Route 53 DNS validation records plus A/AAAA aliases that route traffic to CloudFront.

Assumptions:

1. You already own the domain (e.g., `my-domain.com`) and have an existing hosted zone in Route 53.
2. Terraform state is stored in an existing S3 bucket with a DynamoDB lock table (configured via `backend-config.tfbackend` or `terraform init -backend-config` flags).
3. Sensitive values (domain name, hosted zone ID, backend bucket details) are provided through `terraform.tfvars` or CI/CD secrets and are **not** committed to Git.

## Module Breakdown

| Module       | Path                      | Purpose | Required Inputs |
|--------------|---------------------------|---------|-----------------|
| `s3`         | `modules/s3`              | Creates the private static-asset bucket with optional versioning and ownership controls. | `bucket_name` |
| `acm`        | `modules/acm`             | Requests an ACM certificate in `us-east-1` and outputs DNS validation records. | `domain_name`, optional `subject_alternative_names` |
| `cloudfront` | `modules/cloudfront`      | Builds the CloudFront distribution, attaches the ACM certificate, and restricts S3 access via OAC. | S3 outputs, ACM certificate ARN, optional aliases/TLS settings |
| `route53`    | `modules/route53`         | Creates ACM validation CNAMEs and A/AAAA aliases to CloudFront, then finalizes certificate validation. | `hosted_zone_id`, domain/alias list, validation record map, CloudFront domain + zone ID |

Each module emits outputs consumed by the next (bucket domain → CloudFront origin; validation map → Route 53; Route 53 validation → final certificate).

## Root Module (`_infra/terraform/main.tf`)

The root configuration:

1. Declares the S3 backend (values supplied during `terraform init`).
2. Defines AWS providers for your primary region and the mandatory `us-east-1` alias (required for ACM/CloudFront).
3. Instantiates modules in dependency order:
   - `s3`: creates `my-domain` (placeholder name—override for real deployments).
   - `acm`: requests the certificate and returns validation records.
   - `cloudfront`: provisions the distribution with aliases and the ACM certificate.
   - `dns`: writes the ACM validation CNAMEs and the domain aliases in Route 53, completing the certificate validation.

`locals` aggregate the CloudFront alias list and convert the ACM validation outputs into a map keyed by domain so Route 53 can deterministically create records.

## Required Inputs

Provide these via `terraform.tfvars` (ignored by Git) or environment variables (`TF_VAR_*`):

```hcl
backend_bucket            = "terraform-state-bucket-k8s-api"
backend_bucket_key        = "my-domain/terraform.tfstate"
aws_region                = "us-east-1" # or your primary region
dynamodb_table            = "terraform-locks"
domain_name               = "my-domain.com"
subject_alternative_names = ["www.my-domain.com"]
hosted_zone_id            = "Z123EXAMPLE"
```

> **Note:** `terraform.tfvars` and `.tfbackend` files are ignored via `.gitignore`. If you need to illustrate their structure, commit sanitized examples only.

## Usage

1. Populate `backend-config.tfbackend` with your state bucket details or pass them directly to `terraform init`.
2. Create `terraform.tfvars` with the required inputs above.
3. From `_infra/terraform`, execute:
   ```bash
   terraform fmt
   terraform init -backend-config=backend-config.tfbackend
   terraform plan
   terraform apply
   ```
4. ACM may take a few minutes to issue the certificate; the dependency graph ensures CloudFront creation waits until validation succeeds. If AWS was still processing, re-run `terraform apply` and it will converge cleanly.

## Secrets & Automation

For CI/CD (e.g., GitHub Actions):

- Base64-encode your local `terraform.tfvars`, store it as a single secret, and decode it before running Terraform; or
- Set individual secrets using the `TF_VAR_` prefix (e.g., `TF_VAR_domain_name`, `TF_VAR_hosted_zone_id`).

Either approach keeps real domain names, hosted zone IDs, and backend credentials out of the repository while allowing automated plans/applies.
