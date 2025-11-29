#!/bin/bash

SERVICE_FILE="/etc/systemd/system/tahta-kapat.service"
TIMER_FILE="/etc/systemd/system/tahta-kapat.timer"

# Eski dosyaları temizle
sudo systemctl stop tahta-kapat.timer 2>/dev/null
sudo systemctl disable tahta-kapat.timer 2>/dev/null
sudo rm -f "$SERVICE_FILE" "$TIMER_FILE"
sudo rm -f /etc/systemd/system/multi-user.target.wants/tahta-kapat.timer

# Servis dosyası
sudo bash -c "cat > $SERVICE_FILE" << 'EOF'
[Unit]
Description=Pardus'u Kapat (Günlük)

[Service]
Type=oneshot
ExecStart=/usr/sbin/poweroff
EOF

# Timer dosyası (her gün 17:00)
sudo bash -c "cat > $TIMER_FILE" << 'EOF'
[Unit]
Description=Pardus'u her gün saat 17:00'de kapat

[Timer]
OnCalendar=*-*-* 17:00:00
Persistent=true

[Install]
WantedBy=timers.target
EOF

# Zamanlayıcıyı etkinleştir
sudo systemctl daemon-reload
sudo systemctl start tahta-kapat.timer
sudo systemctl enable tahta-kapat.timer

echo "Pardus bundan sonra her gün saat 17:00'de otomatik olarak kapanacak."
