#!/bin/bash

echo "Terraform apply script"
DIR="."

if [ -d "$DIR" ]; then
  if [ -f "$DIR/.terraform.lock.hcl" ]; then
    echo ".terraform.lock.hcl file found. Skipping 'terraform init'."
  else
    echo "No .terraform.lock.hcl file found. Running 'terraform init'."

    # Run terraform init if .terraform.lock.hcl does not exist
    if ! terraform -chdir="$DIR" init; then
      echo "Error: Failed to initialize Terraform."
      exit 1
    fi
  fi

  # Iterate over .tf files and perform terraform commands
  files=$(find "$DIR" -maxdepth 1 -type f -name '*.tf')

  if [ -n "$files" ]; then
    for file in $files; do
      echo "Processing $file ..."
      echo "######### Terraform format in progress... ###########"
      terraform -chdir=$(dirname "$file") fmt
      echo "######### Terraform validation in progress... ###########"
      terraform -chdir=$(dirname "$file") validate
      echo "######### Terraform plan in progress... ###########"
      terraform -chdir=$(dirname "$file") plan
    done
  else
    echo "No '*.tf' files found in the $DIR directory."
  fi
else
  echo "Directory $DIR does not exist."
fi
