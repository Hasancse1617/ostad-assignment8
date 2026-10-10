#!/bin/bash
# Install Apache
yum update -y
yum install -y httpd

# Get the Availability Zone
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
AZ=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/placement/availability-zone)

# Start and enable Apache
systemctl start httpd
systemctl enable httpd

# Create index.html
echo "<h1>Instance serving from: ${AZ}</h1>" > /var/www/html/index.html

# Create health check endpoint
echo "OK" > /var/www/html/health.html
