# Project Usecases:

This repo to containing all scenario based tasks that we tested in our LAB environments. We typically consume,

Project-I: Terraform Code, Bash scripts, Docker, ECR, security group, target groups in AWS.

Project-II: Static website deployment via Terraform code using S3 buckets.

Project-III: Setting Transit Gateway for two different networks in aws instead vpc peering.

Project-IV: A simple bootstrap.sh file to provision infra and apache deployment on an EC2 machine.

project stuff with terraform Automation:-

*aws_secret_manager_with_rds

*depends_on_argument

*ecr_case

*for_each_concepts

*lookup_function

*static_web_hosting_on_s3

*tf_ec2_jenkins

*tf_module

*vpc_ec2_jenkins

*user_script


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

To view all current AWS-related environment variables, you can use:
```bash
printenv | grep AWS

If Terraform has cached some old credentials or configuration, try clearing it by running:
```bash
terraform init --reconfigure

## AWS CLI commands
```bash
$ aws s3 ls --profile vault_admin
$ aws sts get-caller-identity  --profile vault_admin –query account –output text 
$ aws sts get-caller-identity --profile vault_admin // This is useful to verify which IAM user or role is being used when making AWS API calls

JSON query language:
## 'jq' is a powerful command-line tool for processing and querying JSON data
```bash
$ aws sts get-caller-identity --profile vault_admin | jq -r '.Account'
$ aws sts get-caller-identity --profile vault_admin | jq -r '.Arn'
$ aws sts get-caller-identity --profile vault_admin | jq -r '.UserId'
