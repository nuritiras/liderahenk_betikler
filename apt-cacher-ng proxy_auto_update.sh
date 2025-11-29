#!/bin/bash
SUNUCU_IP="192.168.16.253"

echo "Acquire::http::Proxy \"http://$SUNUCU_IP:3142\";" | sudo tee /etc/apt/apt.conf.d/01proxy > /dev/null
sudo apt clean
sudo apt update -y
echo "✅ apt-cacher-ng proxy ayarı tamamlandı. Güncellemeler artık $SUNUCU_IP üzerinden alınacak."

