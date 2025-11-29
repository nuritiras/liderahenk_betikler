#!/bin/bash

SERVICE_FILE="/etc/systemd/system/tahta-kapat.service"
TIMER_FILE="/etc/systemd/system/tahta-kapat.timer"
WANTS_LINK="/etc/systemd/system/multi-user.target.wants/tahta-kapat.timer"

echo "Pardus otomatik kapanma ayarları geri alınıyor..."

sudo systemctl stop tahta-kapat.timer 2>/dev/null
sudo systemctl disable tahta-kapat.timer 2>/dev/null

sudo rm -f "$TIMER_FILE"
sudo rm -f "$SERVICE_FILE"
sudo rm -f "$WANTS_LINK"

sudo systemctl daemon-reload
sudo systemctl reset-failed tahta-kapat.service 2>/dev/null
sudo systemctl reset-failed tahta-kapat.timer 2>/dev/null

echo "Pardus otomatik kapanma zamanlayıcısı tamamen kaldırıldı."
