#!/bin/bash
echo "Terraform apply script"
DIR="."

if [ -d "$DIR" ]; then
  for file in "$DIR"/*.tf; do
    if [ -f "$file" ]; then
    echo "processing $file ..."
    echo "######### terraform initialization in progress...###########"
    terraform init
    echo "######### terraform format in progress...###########"
    terraform fmt 
    echo "######### terraform validation in progress...###########"
    terraform validate
    echo "######### terraform plan in progress...###########"
    terraform plan
    else
    echo "NO '*.tf' files found in the $pwd directory.."
    break
    fi
    done
    else
    echo "Directory $DIR does not exist."
fi
