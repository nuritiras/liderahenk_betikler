#!/bin/bash
# PARDUS / Linux Otomatik Kapanış Zamanlayıcısı
# LiderAhenk ile dağıtıma uygundur.

# --- AYARLAR ---
# Kapanış Saati (24 saat formatında)
SAAT="19"
DAKIKA="00"
# Hangi günler? (* = Her gün, 1-5 = Hafta içi, 1,3,5 = Pzt,Çar,Cum)
GUNLER="*" 
# ----------------

# 1. Root Yetkisi Kontrolü
if [ "$EUID" -ne 0 ]; then
  echo "HATA: Bu script yönetici yetkisi ile çalıştırılmalıdır."
  exit 1
fi

echo "Otomatik kapanış görevi ayarlanıyor..."

# 2. Cron Dosyasını Oluşturma
# /etc/cron.d/ klasörüne dosya bırakmak en temiz yöntemdir.
# Mevcut varsa üzerine yazar, böylece güncellemeyi de bu scriptle yapabilirsiniz.

CRON_DOSYASI="/etc/cron.d/liderahenk-otokapan"

cat << EOF > "$CRON_DOSYASI"
# LiderAhenk tarafindan olusturulan otomatik kapanis kurali
# Format: dk sa gun ay hafta_gunu kullanici komut
$DAKIKA $SAAT * * $GUNLER root /sbin/shutdown -h now
EOF

# 3. İzinleri Ayarlama
chmod 644 "$CRON_DOSYASI"

# 4. Cron Servisini Yenileme (Genelde gerekmez ama garanti olsun)
systemctl restart cron

echo "BAŞARILI: Sistem her gün saat $SAAT:$DAKIKA itibarıyla otomatik kapanacak."