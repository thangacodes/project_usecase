provider "aws" {
  region                   = var.region
  shared_config_files      = ["~/.aws/config"]
  shared_credentials_files = ["~/.aws/credentials"]
}

## Please note:
# Authenticating to AWS with Terraform
# There are many ways to authenticate using the Terraform AWS provider. 
# Configuration for the AWS Provider can be derived from several sources, which are applied in the following order:

# Parameters in the provider configuration
# Environment variables
# Shared credentials and configuration files
# Container credentials
# Instance profile credentials and region
# External credentials process
