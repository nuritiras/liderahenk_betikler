#!/bin/bash
# ==========================================================
# Pardus 23 GNOME Masaüstü Arkaplanını Kilitleme Betiği
# ==========================================================

# LiderAhenk zaten root olarak çalıştıracağı için yetki kontrolü
# (if [ "$(id -u)" -ne 0 ];) satırları silinebilir, ancak kalması da sorun yaratmaz.

echo "LiderAhenk Görevi: Pardus GNOME arkaplan kilitleme işlemi başlatılıyor..."

# 2. Gerekli Dizinlerin Oluşturulması
mkdir -p /etc/dconf/db/local.d/locks/
echo "Gerekli dizin yapısı kontrol edildi/oluşturuldu."

# 3. dconf Profil Dosyasının Ayarlanması
PROFILE_FILE="/etc/dconf/profile/user"
touch "$PROFILE_FILE"
grep -qxF "user-db:user" "$PROFILE_FILE" || echo "user-db:user" >> "$PROFILE_FILE"
grep -qxF "system-db:local" "$PROFILE_FILE" || echo "system-db:local" >> "$PROFILE_FILE"
echo "dconf profili ayarlandı: $PROFILE_FILE"

# 4. Arkaplan Ayar Dosyasının Oluşturulması
cat > /etc/dconf/db/local.d/00-arkaplan-ayari << EOF
[org/gnome/desktop/background]
picture-uri='file:///usr/share/backgrounds/pardus23-0_Lavanta-BirAdimOnde.webp'
picture-uri-dark='file:///usr/share/backgrounds/pardus23-0_Lavanta-BirAdimOnde.webp'
picture-options='zoom'
EOF
echo "Varsayılan arkaplan ayar dosyası oluşturuldu."

# 5. Kilit Dosyasının Oluşturulması
cat > /etc/dconf/db/local.d/locks/arkaplan-kilidi << EOF
/org/gnome/desktop/background/picture-uri
/org/gnome/desktop/background/picture-uri-dark
/org/gnome/desktop/background/picture-options
EOF
echo "Arkaplan kilit dosyası oluşturuldu."

# 6. dconf Veritabanının Güncellenmesi
echo "dconf veritabanı güncelleniyor..."
dconf update

echo "LiderAhenk Görevi: İŞLEM BAŞARILI!"
