#!/bin/bash
sleep 30
sudo yum update -y 
echo "Installing mysql client on aws ec2 machine.."
sudo yum install -y https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm
# Run the following line if you get a GPG error and then run the previous line again
sudo rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022
sudo yum install -y mysql-community-client
exit
