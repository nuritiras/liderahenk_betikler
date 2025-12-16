#!/bin/bash
# PARDUS LiderAhenk - OverlayFS (Deep Freeze) Kurulum Scripti
# Bu script katılımsız (non-interactive) çalışır.

# --- AYARLAR ---
# Yönetim paneli için kullanılacak ortak şifreyi buraya yazın:
YONETICI_PAROLASI="1234okul"
# ----------------

# 1. Paket Kurulumu
export DEBIAN_FRONTEND=noninteractive
apt-get update -qq
apt-get install overlayroot -y -qq

# 2. Yönetim Scriptini Oluştur (/opt altına)
cat << EOF > /opt/koruma-yonet.sh
#!/bin/bash
CONFIG_FILE="/etc/overlayroot.conf"
DOGRU_SIFRE="$YONETICI_PAROLASI"

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

clear
echo -e "\${BLUE}###############################################\${NC}"
echo -e "\${BLUE}#     PARDUS KORUMA YÖNETİMİ (LiderAhenk)     #\${NC}"
echo -e "\${BLUE}###############################################\${NC}"
echo ""

if [ "\$EUID" -ne 0 ]; then
  echo -e "\${RED}HATA: Yönetici yetkisi gerekiyor.\${NC}"
  sleep 3
  exit
fi

# Güvenlik Kontrolü
echo -e "\${RED}Güvenlik: İşlem yapmak için yönetici parolası gereklidir.\${NC}"
read -s -p "Parola: " GIRILEN_SIFRE
echo ""

if [ "\$GIRILEN_SIFRE" != "\$DOGRU_SIFRE" ]; then
    echo ""
    echo -e "\${RED}>>> HATALI PAROLA! Erişim Reddedildi.\${NC}"
    sleep 2
    exit 1
fi

CURRENT_CONF=\$(grep "^overlayroot=" \$CONFIG_FILE | cut -d'"' -f2)

echo -e "\${BLUE}-----------------------------------------------\${NC}"
echo -e "Mevcut Durum: \${GREEN}\$CURRENT_CONF\${NC}"
echo -e "\${BLUE}-----------------------------------------------\${NC}"
echo "1) Korumayı AÇ (Deep Freeze Modu - Restart Atar)"
echo "2) Korumayı KAPAT (Kalıcı Mod - Restart Atar)"
echo "3) Çıkış"
read -p "Seçiminiz: " secim

case \$secim in
    1)
        sed -i 's/^overlayroot=.*/overlayroot="tmpfs"/' \$CONFIG_FILE
        echo -e "\${GREEN}Koruma AÇILDI. Sistem yeniden başlatılıyor...\${NC}"
        sleep 2
        reboot
        ;;
    2)
        sed -i 's/^overlayroot=.*/overlayroot="disabled"/' \$CONFIG_FILE
        echo -e "\${RED}Koruma KAPATILDI. Sistem yeniden başlatılıyor...\${NC}"
        sleep 2
        reboot
        ;;
    3) exit ;;
    *) echo "Geçersiz seçim"; exit ;;
esac
EOF

# Scripti çalıştırılabilir yap
chmod +x /opt/koruma-yonet.sh

# 3. Masaüstü Kısayolunu Oluşturma
# LiderAhenk root olarak çalıştığı için, tüm /home kullanıcılarını bulup masaüstlerine kopyalamalıyız.

# Kısayol İçeriği
cat << EOF > /tmp/PardusKoruma.desktop
[Desktop Entry]
Version=1.0
Type=Application
Name=Pardus Koruma Kalkanı
Comment=Sistemi Dondur veya Aç
Exec=sudo /opt/koruma-yonet.sh
Icon=security-high
Terminal=true
Categories=System;Settings;
Name[tr]=Pardus Koruma Kalkanı
EOF
chmod +x /tmp/PardusKoruma.desktop

# Tüm kullanıcılara dağıt (Mevcut kullanıcılar)
for user_home in /home/*; do
    user_name=$(basename "$user_home")
    
    # Masaüstü klasörü var mı kontrol et (Türkçe veya İngilizce)
    if [ -d "$user_home/Masaüstü" ]; then
        TARGET_DIR="$user_home/Masaüstü"
    elif [ -d "$user_home/Desktop" ]; then
        TARGET_DIR="$user_home/Desktop"
    else
        continue
    fi

    # Kopyala ve sahipliği ayarla
    cp /tmp/PardusKoruma.desktop "$TARGET_DIR/"
    chown "$user_name":"$user_name" "$TARGET_DIR/PardusKoruma.desktop"
    
    # Güvenilir olarak işaretle (Varsa gio kullan)
    if [ -x "$(command -v gio)" ]; then
        sudo -u "$user_name" gio set "$TARGET_DIR/PardusKoruma.desktop" metadata::trusted true 2>/dev/null || true
    fi
done

# Gelecekte açılacak yeni kullanıcılar için de skel'e atalım
if [ -d "/etc/skel/Masaüstü" ]; then
    cp /tmp/PardusKoruma.desktop /etc/skel/Masaüstü/
elif [ -d "/etc/skel/Desktop" ]; then
    cp /tmp/PardusKoruma.desktop /etc/skel/Desktop/
fi

rm /tmp/PardusKoruma.desktop

echo "Kurulum LiderAhenk tarafından başarıyla tamamlandı."