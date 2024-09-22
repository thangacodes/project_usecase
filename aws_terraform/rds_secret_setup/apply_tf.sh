#!/bin/bash

echo "Firstly, executing 'secret_creat.sh' to setup a secret via awscli before rds instance provision by terraform (IaC) ..."
echo "Invoking a bash_script within $0 .."
sh secret_creat.sh

# Check for .terraform directory and .terraform.lock.hcl file
if [ -d ".terraform" ] && [ -f ".terraform.lock.hcl" ]; then
    echo ".terraform directory and .terraform.lock.hcl file exist in the current dir '$(pwd)'. Hence,skipping terraform init."
else
    echo "Initializing Terraform..."
    terraform init
fi
# Formate Terraform configuration
echo "Formatting Terraform files..."
terraform fmt
# Validate Terraform configuration
echo "Validating Terraform configuration..."
if terraform validate; then
    echo "Validation successful."
else
    echo "Validation failed. Exiting."
    exit 1
fi

# Plan Terraform configuration
echo "Terraform Plan in progress..."
read -p "Enter the secret value that you feed in first script, the same name needs to be provided here as well:" password
echo "you have provided input as :" $password
export TF_VAR_name="${password}"
terraform plan -var="password=$password"

# Apply Terraform configuration
terraform apply -var="password=$password"

# Capture the ARN output
secret_arn=$(terraform output -raw secret_arn)

# Print the ARN
echo "The ARN of the secret is: $secret_arn"
exit 0
