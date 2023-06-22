pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID = credentials('jenkins-aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('jenkins-aws-secret-access-key-id')
    }

    stages {
        stage('Checkout') {
            steps {
            git branch: 'main', url: 'https://github.com/thangacodes/project_usecase.git'

          }
        }
	
	stage ("Changing to the directory, where the config file exist"){
	    steps {
	        echo "change directory"
		sh '''
		   ls -lrth
		   cd ecr_case/
		   ls -lrth
		   pwd
		 '''
		}
	     }

        stage ("terraform init") {
            steps {
                echo "Going to initialise the terraform module and download the plugin"
                sh '''
		   pwd
		   cd ecr_case/terraform_resources
		   sleep 3
		   echo "Going to initialize the terraform init command"
		   terraform init
		'''
            }
        }
		
		stage ("terraform fmt") {
            steps {
                echo "It checks and arranging the terraform code proper format"
                sh '''
		   pwd
		   cd ecr_case/terraform_resources
		   sleep 3
		   echo "Going to format the terraform scripts"
		   terraform fmt
		'''
            }
        }

        stage("terraform validate") {
            steps {
                echo"Going to validate the code written in HCL"
                sh '''
		   pwd
		   cd ecr_case/terraform_resources
		   mkdir private_key
		   ls -lrt
		   echo "create a directory and switchover to it"
		   cd private_key
                   touch admin.pem
		   ls -lrt
		   echo "EXTRACTING SSH_KEY FROM SSM-PARAMETER_STORE......"
                   #aws ssm get-parameter --name devexample.org --with-decryption --region ap-south-1 --output text --query Parameter.Value > admin.pem
		   sleep 5
		   ls -lrt
		   #chmod 0400 admin.pem
		   #sleep 3
		   echo "Going to validate the terraform scripts"
		   terraform validate
		'''
            }
        }

        stage("terraform plan") {
            steps {
                echo "Going to show us, what is going to be spin up"
                sh '''
		   pwd
		   cd ecr_case/terraform_resources
		   sleep 3
		   echo "Going to perform dry-run"
		   terraform plan -var-file=dev.tfvars
		'''
            }
        }
	stage("terraform apply"){
            steps {
                sh '''
                   cd ecr_case/terraform_resources/
                   sleep 3
                   echo "Going to show us the terraform output"
                   terraform apply -var-file=dev.tfvars
                '''
            }
        }
    }
}
