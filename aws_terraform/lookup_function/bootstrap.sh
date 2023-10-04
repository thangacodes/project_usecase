#!/bin/bash
# set -x       #If you want to enable degbug please go ahead.
######### GIT, JENKINS, TERRAFORM INSTALLATION ###########
sudo yum update -y
sleep 30
echo "GIT installation begin..."
sudo yum install -y git 
sleep 2
echo "Terraform installation begin..."
sudo yum install -y yum-utils shadow-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install terraform
echo "Jenkins installation begin shortly..."
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum upgrade -y
sudo amazon-linux-extras install java-openjdk11 -y
sudo yum install -y jenkins
sudo systemctl start jenkins
sudo systemctl enable jenkins
