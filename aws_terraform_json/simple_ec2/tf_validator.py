import sys
import os
import subprocess
import time

def print_banner():
    banner_text = """
  _______                   __                        _____           _       _    __      __   _ _     _       _             
 |__   __|                 / _|                      / ____|         (_)     | |   \ \    / /  | (_)   | |     | |            
    | | ___ _ __ _ __ __ _| |_ ___  _ __ _ __ ___   | (___   ___ _ __ _ _ __ | |_   \ \  / __ _| |_  __| | __ _| |_ ___  _ __ 
    | |/ _ | '__| '__/ _` |  _/ _ \| '__| '_ ` _ \   \___ \ / __| '__| | '_ \| __|   \ \/ / _` | | |/ _` |/ _` | __/ _ \| '__|
    | |  __| |  | | | (_| | || (_) | |  | | | | | |  ____) | (__| |  | | |_) | |_     \  | (_| | | | (_| | (_| | || (_) | |   
    |_|\___|_|  |_|  \__,_|_| \___/|_|  |_| |_| |_| |_____/ \___|_|  |_| .__/ \__|     \/ \__,_|_|_|\__,_|\__,_|\__\___/|_|   
                                                                       | |                                                    
                                                                       |_|                                                        
"""
    print(banner_text)
    
dir = input("PLEASE ENTER THE PATH WHERE YOUR TERRAFORM SCRIPT FILES EXIST: ")
print(f"USER ENTERED TF SCRIPT PATH IS: {dir}")
time.sleep(2)

def validate_terraform(dir):
    valid_extensions = ['.tf', '.json']
    files_exist = any(file.endswith(tuple(valid_extensions)) for file in os.listdir(dir))
    if not files_exist:
        print("No Terraform configuration files (*.tf or *.json) found in the directory")
        return
    # Check for .terraform directory and .terraform.lock.hcl file
    terraform_dir_exists = os.path.isdir('.terraform')
    lock_file_exists = os.path.isfile('.terraform.lock.hcl')
    tfstate_file_exists = os.path.isfile('terraform.tfstate')
    tfstate_backup_file_exists = os.path.isfile('terraform.tfstate.backup')
    # Conditionally run terraform init
    if terraform_dir_exists and lock_file_exists and tfstate_file_exists and tfstate_backup_file_exists:
        print(".terraform directory, .terraform.lock.hcl, terraform.tfstate, and terraform.tfstate.backup files exist. Skipping terraform init.")
    else:
        print("Either .terraform directory or .terraform.lock.hcl or terraform.tfstate or terraform.tfstate.backup files are missing. Running terraform init.")
        try:
            subprocess.run(['terraform', 'init'])
        except subprocess.CalledProcessError as e:
            print(f"Error during terraform init: {e}")
            sys.exit(1)
    try:
        # Run terraform fmt command
        tffmt = subprocess.run(['terraform', 'fmt'], capture_output=True, text=True, check=True)
        print(f"The terraform fmt has executed successfully..!")
        # Run terraform validate command
        tfvalidate = subprocess.run(['terraform', 'validate'], capture_output=True, text=True, check=True)
        print(f"The terraform validation in progress and the result is: {tfvalidate.stdout} and you are good to execute terraform plan..")  
        tfplan = subprocess.run(['terraform', 'plan'])
        returncode = tfplan.returncode
        print(f"The terraform plan in progress. and tf plan return code value is: {returncode} ")
        if returncode == 0 :
            print(f"The returncode value is: 0. Hence, tfplan is looks good and you are good to execute TF APPLY/DESTROY...")
        elif returncode !=0:
            print(f"The returncode value is not equal to hence some error in the tfplan. Please cross verify..!")
        else:
            print(f"Please check terraform plan command is kept right or wrong and any tf script syntax issue or not..! ")
        time.sleep(2)
        USER_INPUT=input("Would you like to proceed with the terraform apply/destroy command, please say apply or destroy : ")
        print(f" User entered value is: {USER_INPUT}")
        if USER_INPUT == 'apply':
            print(f"You are good to execute terraform apply")
            try:
                tfapply = subprocess.run(['terraform', 'apply', '--auto-approve'])
                print(tfapply.stdout)
            except subprocess.CalledProcessError as e:
                print(f"Error executing terraform apply: {e}")
                print(e.stderr)
        elif USER_INPUT == 'destroy':
            print(f" User entered value is: {USER_INPUT}")
            print("you are good to execute terraform destroy")
            try:
                tfdestroy = subprocess.run(['terraform', 'destroy', '--auto-approve'])
                print(tfdestroy.stdout)
            except subprocess.CalledProcessError as e:
                print(f"Error executing terraform destroy: {e}")
                print(e.stderr)
        else:
            print(f"The value entered by the user does not meet the condition we specified, therefore this operation is ignored.")
    except subprocess.CalledProcessError as e:
        print("Terraform configuration is invalid.")
    except Exception as e:
        print(f"An error occurred: {e}")

if __name__ == "__main__":
    print_banner()
    time.sleep(2)        
    validate_terraform(dir)
