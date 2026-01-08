#!/bin/bash
set -e

PANEL="/var/www/pterodactyl"
WRAPPER="$PANEL/resources/views/templates/wrapper.blade.php"
CSS="$PANEL/public/ekik-layout.css"

IMG1="https://files.catbox.moe/9yuwp3.jpg"
IMG2="https://files.catbox.moe/cjg3lg.jpg"

echo ">>> EKIK FULL LAYOUT THEME"

# ===== CSS =====
cat > "$CSS" <<EOF
body {
  background: linear-gradient(rgba(0,0,0,.9), rgba(0,0,0,.9));
}

/* ROOT WRAPPER */
#ekik-layout {
  display: grid;
  grid-template-columns: 260px 1fr 300px;
  min-height: 100vh;
}

/* LEFT SIDEBAR */
#ekik-left {
  background: rgba(10,10,10,.9);
  border-right: 2px solid #00ffd5;
  padding: 20px;
  color: #00ffd5;
}

#ekik-left h3 {
  margin-bottom: 10px;
  text-shadow: 0 0 10px #00ffd5;
}

/* CENTER PANEL */
#ekik-center {
  background: transparent;
}

/* RIGHT SIDEBAR */
#ekik-right {
  background:
    linear-gradient(rgba(0,0,0,.85), rgba(0,0,0,.9)),
    url("$IMG1"),
    url("$IMG2");
  background-size: cover;
  background-position: center;
  border-left: 2px solid #00ffd5;
  display: flex;
  align-items: center;
  justify-content: center;
}

#ekik-right img {
  max-width: 80%;
  filter: drop-shadow(0 0 30px #00ffd5);
}

/* MOBILE */
@media(max-width: 900px) {
  #ekik-layout {
    grid-template-columns: 1fr;
  }
  #ekik-left, #ekik-right {
    display: none;
  }
}
EOF

# ===== WRAPPER PATCH =====
if ! grep -q "ekik-layout" "$WRAPPER"; then
  sed -i 's|<div id="app"|<div id="ekik-layout"><div id="ekik-left"><h3>SERVER MENU</h3><p>Dashboard</p><p>Files</p><p>Console</p></div><div id="ekik-center"><div id="app"|g' "$WRAPPER"
  sed -i 's|</body>|</div><div id="ekik-right"><img src="'"$IMG1"'"></div></div><link rel="stylesheet" href="/ekik-layout.css"></body>|g' "$WRAPPER"
fi

cd "$PANEL"
php artisan view:clear || true
php artisan optimize:clear || true

echo "✅ FULL LAYOUT INSTALLED"
echo "⚠️ HARD REFRESH / INCOGNITO"

