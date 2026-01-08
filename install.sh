#!/bin/bash
set -e

PANEL="/var/www/pterodactyl"
CSS="$PANEL/public/ekik-final.css"
LOGIN="$PANEL/resources/views/auth/login.blade.php"

IMG_DASH="https://files.catbox.moe/9yuwp3.jpg"
IMG_LOGIN="https://files.catbox.moe/cjg3lg.jpg"

echo ">>> EKIK FINAL THEME INSTALLER"

# ===== CSS DASHBOARD =====
cat > "$CSS" <<EOF
/* GLOBAL */
body {
  background: #050505 !important;
}

/* LOGO CENTER */
#ekik-logo {
  width: 100%;
  display: flex;
  justify-content: center;
  margin: 30px 0;
}

#ekik-logo img {
  max-width: 260px;
  filter: drop-shadow(0 0 25px #00ffd5);
}

/* SERVER CARD */
[class*="ServerRow"] {
  background: rgba(20,20,20,.9) !important;
  border: 1px solid #00ffd5 !important;
}

/* SIDEBAR */
nav {
  background: rgba(10,10,10,.95) !important;
  border-right: 2px solid #00ffd5;
}
EOF

# ===== INJECT LOGO =====
if ! grep -q ekik-logo "$PANEL/resources/views/templates/wrapper.blade.php"; then
  sed -i '/<div id="app">/a\<div id="ekik-logo"><img src="'"$IMG_DASH"'"></div>' \
  "$PANEL/resources/views/templates/wrapper.blade.php"
fi

# ===== LOAD CSS =====
if ! grep -q ekik-final.css "$PANEL/resources/views/templates/wrapper.blade.php"; then
  sed -i 's|</head>|<link rel="stylesheet" href="/ekik-final.css"></head>|' \
  "$PANEL/resources/views/templates/wrapper.blade.php"
fi

# ===== LOGIN PAGE =====
sed -i "s|body {|body { background: url('$IMG_LOGIN') center/cover no-repeat fixed; |" "$LOGIN"

php artisan view:clear || true
php artisan optimize:clear || true

echo "✅ INSTALLED"
echo "⚠️ CTRL + F5 / INCOGNITO"
