#!/bin/bash
set -euxo pipefail
exec > /var/log/user-data.log 2>&1

yum install -y unzip curl

curl -O https://releases.hashicorp.com/vault/1.15.2/vault_1.15.2_linux_amd64.zip
unzip vault_1.15.2_linux_amd64.zip
mv vault /usr/local/bin/

cat <<EOF > /etc/systemd/system/vault.service
[Unit]
Description=Vault
After=network.target

[Service]
ExecStart=/usr/local/bin/vault server -dev -dev-listen-address=0.0.0.0:8200
Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable vault
systemctl restart vault

sleep 10