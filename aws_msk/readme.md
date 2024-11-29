This is for setting up a Managed Streaming Kafka cluster in AWS.

The folder and file structure are as follows:

.
├── bootstrap.sh
├── main.tf
├── outputs.tf
├── providers.tf
├── terraform.tfvars
└── variables.tf
1 directory, 5 files


How to Test the Terraform Code in a Local Development Environment?

Clone the repository:
git clone https://github.com/thangacodes/project_usecase.git

Navigate to the folder where the AWS MSK scripts are located:
cd aws_msk

Update your AWS access_key and secret_access_key in terraform.tfvars file

Execute the following Terraform commands:

terraform init
terraform fmt
terraform validate
terraform plan
terraform apply --auto-approve
