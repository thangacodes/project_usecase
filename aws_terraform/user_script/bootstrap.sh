#!/bin/bash
set -xe

SERVER_NAME="apache"
cd terraform
sed -i "s/server_name/${SERVER_NAME}/g" backend_s3.tf
export TF_VAR_name=${SERVER_NAME}

read -p "Enter the action please:" USER_INPUT
echo "You entered action as :" $USER_INPUT

terraform init
terraform fmt
terraform validate
terraform plan

if [[ $USER_INPUT = "apply" ]]; then
   echo "perform terraform apply command"
   terraform apply -auto-approve
sleep 60
   cd ../ansible/
   ansible-playbook -i /opt/ansible/inventory/aws_ec2.yaml apache.yaml

elif [[ $USER_INPUT = "destroy" ]]; then
   echo "perform terraform destroy command"
   terraform destroy -auto-approve

else
  echo "Invalid action entered: $USER_INPUT"
  exit 1
fi
