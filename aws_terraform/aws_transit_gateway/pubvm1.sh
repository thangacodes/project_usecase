#!/bin/bash
echo "Script executed at:" $(date '+%Y-%m-%d %M-%H-%S')
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd
echo "This is public facing vm1 residing on 192.x.x.x series subnet" > /var/www/html/index.html
sudo systemctl restart httpd
