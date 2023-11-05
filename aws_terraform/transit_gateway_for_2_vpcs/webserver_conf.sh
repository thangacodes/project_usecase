#!/bin/bash -xe 
exec > >(tee /tmp/tmp.log)
echo "This is going to be configure Apache web server on Amazon Linux2"
sleep 35
sudo yum update -y
sudo yum install -y httpd
sudo systemctl start httpd.service
echo "<h1>Server Details</h1><p><strong>Hostname:</strong> $(hostname)</p><p><strong>IP Address:</strong>$(hostname -i | cut -d " " -f 2)</p> > /var/www/html/index.html
sudo systemctl stop httpd.service
sudo systemctl start httpd.service
sudo systemctl status httpd.service
