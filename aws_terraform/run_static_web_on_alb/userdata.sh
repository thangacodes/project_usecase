#!/bin/bash
echo "Installing Apache with static web host.."

# To system get up/running smooth
sleep 120

# Update the system
sudo yum update -y

# Install Apache
sudo yum install -y httpd

# Start Apache service
sudo systemctl start httpd.service

# Check the status of Apache service
sudo systemctl status httpd.service

# Enable Apache service to start on boot
sudo systemctl enable httpd.service

# Get the hostname
hostname=$(hostname)

# Create or update the index.html file with the static content
echo '<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>whoami</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f4;
            color: #333;
        }
        header {
            background-color: #4CAF50;
            color: white;
            padding: 1em;
            text-align: center;
        }
        main {
            padding: 1em;
        }
        footer {
            background-color: #333;
            color: white;
            text-align: center;
            padding: 1em;
            position: fixed;
            bottom: 0;
            width: 100%;
        }
    </style>
</head>
<body>
    <header>
        <h1>Thangadurai Curriculam Vitae!!</h1>
    </header>
    <main>
        <h2>About Me</h2>
        <p> <font size="4"> Hello there!
                Thanks for visiting my profile -:) </font> </p>

<p> <font size="4">
It is my pleasure to introduce myself as Thangadurai, an Information Technology engineer from Anna University in Tamil Nadu, India.
An experienced DevOps Engineer with a strong background in building and maintaining complete CI-CD for applications running on AWS/Azure Docker, Kubernetes, Jenkins, Nexus, and Terraform </font> </p>
<h2> My TechForte </h2>

<p> <font size="3"> #Cloud Computing Platform - Amazon Web Services, Microsoft Azure </font> </p>
<p> <font size="3"> #CICD/DevOps/IaC - Jenkins Groovy, Ansible, Docker, Kubernetes, Terraform </font> </p>
<p> <font size="3"> #SCM/CM - GitHub, GitLab, Bitbucket, Ansible </font> </p>
<p> <font size="3"> #Image BuildTool - Packer </font> </p>
<p> <font size="3"> #Middleware - Apache Tomcat, IBM WebSphere </font> </p>
<p> <font size="3"> #Database - MySQL, Oracle </font> </p>
<p> <font size="3"> #Observability - DataDog, Prometheus/Grafana, Splunk </font> </p>
<p> <font size="3"> #Operating System - Windows, Linux </font> </p>
<p> <font size="3"> #Virtualization - Microsoft Hyper-V, VMware </font> </p>
<p> <font size="3"> #Automation Scripting - Bash, PowerShell </font> </p>
<p> <font size="3"> #AWS SDK for Python - Boto3, Python </font> </p>
<p> <font size="3"> #Agile Methodology - Agile Scrum </font> </p>
<main>
<h3> Visit Me:) </h3>
<p> <font size="4"> To Know about my experience, please visit my LinkedIn page <a href="https://www.linkedin.com/in/thangadurai-murugan-87958556/" target="_blank" rel="noopener noreferrer">MyProfile </a> </font> </p>
<p> <font size="4"> To Know about my coding/scripting skill, please visit <a href="https://github.com/thangacodes" target="_blank" rel="noopener noreferrer">Thangacodes GitHub! </a> </font> </p>
<p>
  <font size="4">
    Serving the content from Hostname: 
    <span style="font-weight: bold; color: blue;">Hostname</span>: 
    <span style="color: red;">$hostname</span>
  </font>
</p>
</main>
</body>
</html>' | sudo tee /var/www/html/index.html

# Exit the script
exit 0
