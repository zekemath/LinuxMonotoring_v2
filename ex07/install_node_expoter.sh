#!/bin/bash

mkdir node_exporter
cd node_exporter
wget https://github.com/prometheus/node_exporter/releases/download/v1.8.2/node_exporter-1.8.2.linux-arm64.tar.gz
tar xvfz node_exporter-1.8.2.linux-arm64.tar.gz
cd node_exporter-1.8.2.linux-arm64

mv node_exporter /usr/bin/
rm -rf node_exporter*

useradd -rs /bin/false node_exporter
chown node_exporter:node_exporter /usr/bin/node_exporter


cat <<EOF> /etc/systemd/system/node_exporter.service
[Unit]
Description=Prometheus Node Exporter
After=network.target
 
[Service]
User=node_exporter
Group=node_exporter
Type=simple
Restart=on-failure
ExecStart=/usr/bin/node_exporter
 
[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl start node_exporter
systemctl enable node_exporter
systemctl status node_exporter
node_exporter --version