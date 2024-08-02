#!/bin/bash
echo "Installing Apache with static web host.."

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

# Create or update the index.html file with the static content
echo '<!DOCTYPE html>
<html>
<head>
    <style>
        .hostname {
            color: red;
            font-weight: bold;
        }
        .message {
            color: blue;
        }
    </style>
</head>
<body>
    <p class="message">This is a static website running on EC2 machine: <span class="hostname">'"$(hostname)"'</span> !!</p>
</body>
</html>' | sudo tee /var/www/html/index.html

# Exit the script
exit 0
