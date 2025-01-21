This repository contains Terraform script files, along with Python and JSON files, to deploy a simple Lambda function.

Here are the steps to clone and execute the script:

1. Clone the repository:
   
   git clone https://github.com/thangacodes/project_usecase.git

3. Navigate to the lambda_setting directory:

   cd lambda_setting

5. List the files in the directory:
   
   ls -l

7. Then, execute the following Terraform commands:

   terraform init

   terraform fmt

   terraform validate

   terraform plan

   terraform apply --auto-approve

   terraform destroy --auto-approve

Please note: I'm using an AWS profile to provide the access_key and secret_access_key for interacting with AWS APIs in the Mumbai region. 

I recommend setting up the profile first, then executing the Terraform commands one after another.

I also have an existing S3 bucket that doesn't have a bucket policy. 

Therefore, I am attaching the policy to the bucket and configuring the Lambda function to invoke the JSON file from the existing bucket.

# Disclaimer: This is at the user's discretion.
