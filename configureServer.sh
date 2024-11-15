#!/bin/bash


apt-get update
apt-get install -y socat

# generated by AI
cat > /usr/bin/db.txt << EOF
USA;Washington;USD
UK;London;GBP
France;Paris;EUR
Germany;Berlin;EUR
Spain;Madrid;EUR
Italy;Rome;EUR
Japan;Tokyo;JPY
China;Beijing;CNY
India;New Delhi;INR
Canada;Ottawa;CAD
Australia;Canberra;AUD
Brazil;Brasilia;BRL
Russia;Moscow;RUB
Mexico;Mexico City;MXN
South Korea;Seoul;KRW
Indonesia;Jakarta;IDR
Turkey;Ankara;TRY
Saudi Arabia;Riyadh;SAR
South Africa;Pretoria;ZAR
Argentina;Buenos Aires;ARS
EOF

# this part was written with the help of AI

cp apiServer.sh /usr/bin/
chmod +x /usr/bin/apiServer.sh

cp apiService.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable apiService
systemctl start apiService

touch /var/log/apiServer.log
chmod 644 /var/log/apiServer.log

echo "Installation completed successfully!"
