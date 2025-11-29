#!/bin/bash

# Renkli çıktı için
GREEN="\e[32m"
RESET="\e[0m"

echo -e "${GREEN}Sistem güncellemeleri başlatılıyor...${RESET}"
sleep 1

# Paket listesi güncelleme
sudo apt update

# Tüm güncellemeleri yükleme
sudo apt full-upgrade -y

# Gereksiz paketleri temizleme
sudo apt autoremove -y
sudo apt autoclean

echo -e "${GREEN}Güncellemeler tamamlandı. Sistem kapatılıyor...${RESET}"
sleep 2

# Bilgisayarı kapatma
sudo shutdown -h now
