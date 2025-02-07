This repo contains Terraform scripts to set up a project in the AWS cloud.

```bash
1) Clone the repository
   git clone https://github.com/thangacodes/project_usecase.git
2) Navigate to the folder where the project Terraform scripts are located:
   cd aws_terraform/unni_assesment
3) I’ve included an executable Go script to help perform Terraform operations like init, fmt, validate, plan, and apply:
   cd aws_terraform/unni_assesment/go_script
   ls -ltr
   chmod a+x tfgo
   ./tfgo
   Note: The script will prompt the user for the action to be performed on the Terraform side.
