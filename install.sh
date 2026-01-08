#!/bin/bash
set -e

PANEL="/var/www/pterodactyl"
CSS="$PANEL/public/ekik-final.css"
WRAPPER="$PANEL/resources/views/templates/wrapper.blade.php"
LOGIN="$PANEL/resources/views/layouts/admin.blade.php"

IMG_DASH="https://files.catbox.moe/9yuwp3.jpg"
IMG_LOGIN="https://files.catbox.moe/cjg3lg.jpg"

echo ">>> EKIK FINAL THEME INSTALLER (REAL PANEL FIX)"

# ================= CSS =================
cat > "$CSS" <<'EOF'
/* GLOBAL */
body {
  background: #050505 !important;
}

/* SIDEBAR */
nav {
  background: rgba(10,10,10,.97) !important;
  border-right: 2px solid #00ffd5;
}

/* LOGO CENTER */
#ekik-logo {
  width: 100%;
  display: flex;
  justify-content: center;
  margin: 25px 0 10px;
}

#ekik-logo img {
  max-width: 260px;
  filter: drop-shadow(0 0 30px #00ffd5);
}

/* SERVER CARD */
[class*="ServerRow"] {
  background: rgba(20,20,20,.9) !important;
  border: 1px solid #00ffd5 !important;
}

/* BUTTON */
button {
  border-radius: 14px !important;
}
EOF

# ================= DASHBOARD LOGO =================
if ! grep -q ekik-logo "$WRAPPER"; then
  sed -i '/<div id="app">/a\<div id="ekik-logo"><img src="'"$IMG_DASH"'"></div>' "$WRAPPER"
fi

# ================= LOAD CSS =================
if ! grep -q ekik-final.css "$WRAPPER"; then
  sed -i 's|</head>|<link rel="stylesheet" href="/ekik-final.css"></head>|' "$WRAPPER"
fi

# ================= LOGIN BACKGROUND =================
if ! grep -q ekik-login "$LOGIN"; then
  sed -i "s|<body|<body style=\"background:url('$IMG_LOGIN') center/cover no-repeat fixed;\"|" "$LOGIN"
fi

php artisan view:clear || true
php artisan optimize:clear || true

echo "✅ INSTALL DONE"
echo "⚠️ HARD REFRESH: CTRL + F5 / INCOGNITO"
