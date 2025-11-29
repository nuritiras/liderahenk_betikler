#!/bin/bash

# ==========================================================
# Pardus 23 GNOME Masaüstü Arkaplan Kilidini Kaldırma Betiği
# ==========================================================

# 1. Root Yetkisi Kontrolü
if [ "$(id -u)" -ne 0 ]; then
   echo "HATA: Bu betik, root (sudo) yetkileriyle çalıştırılmalıdır."
   echo "Lütfen 'sudo ./arkaplan_kilit_kaldir.sh' şeklinde çalıştırın."
   exit 1
fi

echo "Pardus GNOME arkaplan kilidini kaldırma işlemi başlatılıyor..."

# 2. Arkaplan Ayar Dosyasının Silinmesi
# (-f parametresi, dosya yoksa hata vermez)
echo "Arkaplan ayar dosyası siliniyor..."
rm -f /etc/dconf/db/local.d/00-arkaplan-ayari

# 3. Kilit Dosyasının Silinmesi
echo "Arkaplan kilit dosyası siliniyor..."
rm -f /etc/dconf/db/local.d/locks/arkaplan-kilidi

# 4. dconf Veritabanının Güncellenmesi
echo "dconf veritabanı güncelleniyor..."
dconf update

echo ""
echo "=========================================================="
echo "İŞLEM BAŞARILI!"
echo "Masaüstü arkaplan kilidi başarıyla kaldırıldı."
echo "Değişikliklerin geçerli olması için oturumu kapatıp açın."
echo "=========================================================="
