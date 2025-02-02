# Backend_S3:

Starting from Terraform v1.10.0, the need for DynamoDB to enable state locking was removed when using Terraform's default backend,
which is the Terraform Cloud or Terraform Enterprise.

```bash
terraform --version
Terraform v1.10.5
