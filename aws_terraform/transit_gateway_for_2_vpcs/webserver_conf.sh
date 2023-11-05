#!/bin/bash -xe 
exec > >(tee /tmp/tmp.log)
echo "This is going to be configure Apache web server on Amazon Linux2"
sleep 35
sudo yum update -y
sudo yum install -y httpd
sudo systemctl start httpd.service
sudo cat << 'END_HTML' >/var/www/html/index.html
<!Doctype Html>  
<Html>     
<Head>      
<Title>     
TransitGateway Online Page
</Title>  
</Head>  
<Body bgcolor="green">
<b> @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@</b>
<br>
<br>
<b>A. AWS TransitGateway!!!</b><br>  
<b>B. TransitGateway Terraform Tutorial</b><br>  
<br>
<b> On this page, we are giving running notes on what we are going to achieve using Terrafrom (IaC).</b>
<br>
<br>
<b>What is an AWS transit gateway?</b> <br>
AWS Transit Gateway connects your Amazon Virtual Private Clouds (VPCs) and on-premises networks through a central hub. <br>  
1. This connection simplifies your network and puts an end to complex peering relationships. <br>  
2. Transit Gateway acts as a highly scalable cloud router—each new connection is made only once. <br>   
3. In this demo, we are having two VPC's, and their CIDR_RANGE is <b>"15.15.0.0/16" and "16.16.0.0/16".</b> <br>
4. We have each public subnet under each VPC's It's CIDR_RANGE is <b>"15.15.1.0/24" and "16.16.1.0/24".</b><br>
5. We will have to create two Internet gateways and two RouteTables, and each's route needs to be configured.</br>
6. We will have to create 1 transit gateway and 2 TGW attachments for each VPC's.<br>
7. We will have to create 2 security groups and 2 EC2 instances with Apache Webserver installed and configured.<br>
8. Post-instance creation, you may get an output block where we defined the Web Server Endpoints.<br>
9. Open your local browsers, like <b>Chrome/Edge/Brave and try to access Webserver Endpoints with Port_Number:80</b><br>
10.For example, on your browser, try accessing Web endpoints like <b>http://Public_IP:80/</b><br>
11.Please ensure, You need, first and foremost, enable the HTTP port on the security group's inbound rule.
</Body>  
</Html>
sudo systemctl stop httpd.service
sudo systemctl start httpd.service
sudo systemctl status httpd.service
