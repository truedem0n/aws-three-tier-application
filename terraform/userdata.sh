#!/bin/bash
apt update
apt install -y cockpit
echo "ubuntu:AqjSqTS@L8Kb9Cis" | chpasswd

apt install -y  python3 python3-pip python3-wheel awscli unzip
mkdir -p /server
rm -rf /server/*
aws s3 cp s3://dev-bucket-440546640008/two_tier/app.zip /server/app.zip
unzip /server/app.zip -d /server/
pip3 install flask mysql-connector-python boto3
sudo tee /etc/systemd/system/my_app_server.service > /dev/null <<EOF
   [Unit]
   Description=my_app_server service
   After=network.target

   [Service]
   ExecStart=/usr/bin/python3 /server/server.py
   WorkingDirectory=/server/
   Restart=always

   [Install]
   WantedBy=multi-user.target
EOF

# Enable and start the service
sudo systemctl enable .service
sudo systemctl start my_app_server.service