#!/bin/bash
set -e

PANEL="/var/www/pterodactyl"
WRAPPER="$PANEL/resources/views/templates/wrapper.blade.php"
ADMIN="$PANEL/resources/views/layouts/admin.blade.php"
CSS="$PANEL/public/ekik-safe-theme.css"

BANNER="https://files.catbox.moe/cjg3lg.jpg"
LOGIN_BG="https://files.catbox.moe/9yuwp3.jpg"

echo "=== EKIK SAFE HERO THEME INSTALLER ==="

# ===== PASTI DI ROOT PANEL =====
cd "$PANEL" || { echo "❌ Panel path salah"; exit 1; }

# ===== BACKUP =====
cp "$WRAPPER" "$WRAPPER.bak_ekik" 2>/dev/null || true
cp "$ADMIN" "$ADMIN.bak_ekik" 2>/dev/null || true

# ===== CSS =====
cat > "$CSS" <<EOF
/* GLOBAL */
body {
  background: #050505 !important;
}

/* SIDEBAR */
nav {
  background: rgba(10,10,10,.96) !important;
  border-right: 2px solid #00ffd5;
}

/* HERO BANNER */
#ekik-hero {
  width: 100%;
  display: flex;
  justify-content: center;
  margin: 30px 0 40px;
}

#ekik-hero img {
  max-width: 900px;
  width: 95%;
  border-radius: 22px;
  box-shadow: 0 0 40px rgba(0,255,213,.6);
}

/* SERVER CARD */
[class*="ServerRow"] {
  background: rgba(20,20,20,.9) !important;
  border: 1px solid #00ffd5 !important;
  border-radius: 16px;
}

/* BUTTON */
button {
  border-radius: 14px !important;
}
button:hover {
  box-shadow: 0 0 12px #00ffd5;
}

/* LOGIN PAGE */
body[data-theme="light"], body[data-theme="dark"] {
  background: url("$LOGIN_BG") center/cover no-repeat fixed !important;
}

.card {
  background: rgba(0,0,0,.6) !important;
  backdrop-filter: blur(10px);
  border: 1px solid #00ffd5;
  box-shadow: 0 0 25px rgba(0,255,213,.6);
}
EOF

# ===== INJECT BANNER =====
if ! grep -q ekik-hero "$WRAPPER"; then
  sed -i '/<div id="app">/a\<div id="ekik-hero"><img src="'"$BANNER"'"></div>' "$WRAPPER"
fi

# ===== LOAD CSS =====
if ! grep -q ekik-safe-theme.css "$WRAPPER"; then
  sed -i 's|</head>|<link rel="stylesheet" href="/ekik-safe-theme.css"></head>|' "$WRAPPER"
fi

# ===== CLEAR CACHE =====
php artisan view:clear || true
php artisan optimize:clear || true

echo "✅ INSTALL BERHASIL"
echo "⚠️ BUKA PANEL PAKAI CTRL + F5 / INCOGNITO"
