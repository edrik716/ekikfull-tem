#!/bin/bash
set -e

PANEL_DIR="/var/www/pterodactyl"
CSS_DIR="$PANEL_DIR/public/ekik"
CSS_FILE="$CSS_DIR/ekik-neon.css"

DASH_IMG="$CSS_DIR/dashboard.jpg"
LOGIN_IMG="$CSS_DIR/login.jpg"

echo ">>> EKIK INSTALLER – SMART THEME"

# cek panel
if [ ! -d "$PANEL_DIR" ]; then
  echo "❌ Pterodactyl tidak ditemukan"
  exit 1
fi

mkdir -p "$CSS_DIR"

echo "→ Download assets"
curl -fsSL https://files.catbox.moe/cjg3lg.jpg -o "$DASH_IMG"
curl -fsSL https://files.catbox.moe/9yuwp3.jpg -o "$LOGIN_IMG"

echo "→ Tulis CSS"
cat > "$CSS_FILE" <<'EOF'
/* ===== EKIK SMART THEME ===== */

/* DASHBOARD */
body {
  background: linear-gradient(
      rgba(0,0,0,.65),
      rgba(0,0,0,.65)
    ),
    url("/ekik/dashboard.jpg") center/cover fixed no-repeat !important;
}

/* HEADER */
header, nav {
  background: rgba(10,10,10,.75) !important;
  backdrop-filter: blur(8px);
}

/* SERVER CARD */
[class*="ServerRow"], [class*="serverRow"] {
  border: 1px solid #00ffd5;
  box-shadow: 0 0 15px rgba(0,255,213,.3);
  border-radius: 14px;
  transition: .25s;
}
[class*="ServerRow"]:hover {
  box-shadow: 0 0 25px rgba(0,255,213,.8);
}

/* LOGIN PAGE */
.auth-container, body.auth {
  background:
    linear-gradient(rgba(0,0,0,.7),rgba(0,0,0,.7)),
    url("/ekik/login.jpg") center/cover no-repeat !important;
}

/* BUTTON */
button {
  border-radius: 12px !important;
  box-shadow: 0 0 10px rgba(0,255,213,.5);
}
EOF

# inject ke wrapper
WRAPPER="$PANEL_DIR/resources/views/templates/wrapper.blade.php"
if ! grep -q ekik-neon.css "$WRAPPER"; then
  sed -i "/<\/head>/i <link rel=\"stylesheet\" href=\"\/ekik\/ekik-neon.css\">" "$WRAPPER"
fi

# login blade (multi versi)
LOGIN_BLADE=$(find "$PANEL_DIR/resources/views/auth" -type f -name "*login*.blade.php" | head -n 1)
if [ -n "$LOGIN_BLADE" ]; then
  sed -i "/<\/head>/i <link rel=\"stylesheet\" href=\"\/ekik\/ekik-neon.css\">" "$LOGIN_BLADE"
fi

chown -R www-data:www-data "$CSS_DIR"

echo "✅ INSTALL DONE"
echo "⚠️ HARD REFRESH: CTRL + F5 / INCOGNITO"
