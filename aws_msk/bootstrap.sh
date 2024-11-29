#!/bin/bash

# Redirect all output (stdout and stderr) to /tmp/bootstrap.log
exec > /tmp/bootstrap.log 2>&1

# Update the system
sudo yum update -y

# Install tree utility
sudo yum install -y tree

# Install Java 1.8 (Amazon Linux 2 or 3 might use openjdk-1.8)
sudo yum install -y java-1.8.0-openjdk-devel

# Check if Java installed correctly
java -version

# Download and install Kafka
cd /tmp/
wget https://downloads.apache.org/kafka/3.8.1/kafka_2.12-3.8.1.tgz

# Extract Kafka
tar xzf kafka_2.12-3.8.1.tgz

# Optionally, add Kafka to PATH or setup configurations as required
export PATH=$PATH:/tmp/kafka_2.12-3.8.1/bin

# Download MSK IAM Authentication JAR:
wget https://github.com/aws/aws-msk-iam-auth/releases/download/v2.2.0/aws-msk-iam-auth-2.2.0-all.jar

# Set CLASSPATH for the JAR File
export CLASSPATH=/tmp/aws-msk-iam-auth-2.2.0-all.jar

# Persistent Kafka PATH and CLASSPATH:
echo 'export PATH=$PATH:/tmp/kafka_2.12-3.8.1/bin' >> ~/.bashrc
echo 'export CLASSPATH=/tmp/aws-msk-iam-auth-2.2.0-all.jar' >> ~/.bashrc

# Install AWS CLI (for MSK IAM authentication)
sudo yum install -y aws-cli
