#!/bin/bash
# Update system packages
apt-get update -y
apt-get upgrade -y

# Install Node.js
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt-get install -y nodejs
apt-get install -y libcap2-bin

# Get the Availability Zone and Instance ID from AWS Metadata API
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
AZ=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
INSTANCE_ID=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/instance-id)

# Create Application Directory
mkdir -p /home/ubuntu/app
cd /home/ubuntu/app

# Initialize npm and install Express
npm init -y
npm install express

# Create the Node.js Express server file
cat <<EOF > server.js
const express = require('express');
const app = express();
const port = 80;

// Main route showing the Instance ID and Availability Zone
app.get('/', (req, res) => {
    res.send('<html><body><h1>Instance: ${INSTANCE_ID} <br> Availability Zone: ${AZ}</h1></body></html>');
});

// Health check endpoint required by the Load Balancer
app.get('/health.html', (req, res) => {
    res.status(200).send('OK');
});

// Also support /health just in case
app.get('/health', (req, res) => {
    res.status(200).send('OK');
});

app.listen(port, () => {
    console.log(\`App listening on port \${port}\`);
});
EOF

# Give node permissions to bind to port 80 (since it is a privileged port)
setcap cap_net_bind_service=+ep $(which node)

# Create a systemd service to run the Node.js app in the background automatically
cat <<EOF > /etc/systemd/system/nodeapp.service
[Unit]
Description=Node.js Express App
After=network.target

[Service]
ExecStart=/usr/bin/node /home/ubuntu/app/server.js
Restart=always
User=ubuntu
Environment=PATH=/usr/bin:/usr/local/bin
Environment=NODE_ENV=production
WorkingDirectory=/home/ubuntu/app

[Install]
WantedBy=multi-user.target
EOF

# Start and enable the Node.js service so it runs on boot
systemctl daemon-reload
systemctl enable nodeapp
systemctl start nodeapp
