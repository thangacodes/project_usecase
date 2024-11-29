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
echo "Downloading Kafka 3.8.1..."
cd /tmp/
wget https://downloads.apache.org/kafka/3.8.1/kafka_2.12-3.8.1.tgz

# Step 2: Extract Kafka
echo "Extracting Kafka..."
tar xzf kafka_2.12-3.8.1.tgz

# Step 3: Add Kafka to PATH (optional)
echo "Adding Kafka to PATH..."
export PATH=$PATH:/tmp/kafka_2.12-3.8.1/bin

# Step 4: Create the client.properties file
echo "Creating and configuring client.properties..."
mkdir -p /tmp/kafka_2.12-3.8.1/config
cat <<EOF > /tmp/kafka_2.12-3.8.1/config/client.properties
security.protocol=SASL_SSL
sasl.mechanism=AWS_MSK_IAM
sasl.jaas.config=software.amazon.msk.auth.iam.IAMLoginModule required;
sasl.client.callback.handler.class=software.amazon.msk.auth.iam.IAMClientCallbackHandler;
EOF

# Download MSK IAM Authentication JAR:
wget https://github.com/aws/aws-msk-iam-auth/releases/download/v2.2.0/aws-msk-iam-auth-2.2.0-all.jar

# Set CLASSPATH for the JAR File
export CLASSPATH=/tmp/aws-msk-iam-auth-2.2.0-all.jar

# Persistent Kafka PATH and CLASSPATH:
echo 'export PATH=$PATH:/tmp/kafka_2.12-3.8.1/bin' >> ~/.bashrc
echo 'export CLASSPATH=/tmp/aws-msk-iam-auth-2.2.0-all.jar' >> ~/.bashrc

# Install AWS CLI (for MSK IAM authentication)
sudo yum install -y aws-cli
