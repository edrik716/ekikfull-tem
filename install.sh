#!/bin/bash
set -e

echo ">>> EKIK CYAN PRO THEME INSTALLER"

PT_PATH="/var/www/pterodactyl"
VIEW_PATH="$PT_PATH/resources/views"
PUBLIC_PATH="$PT_PATH/public"

IMG_DASH="$PUBLIC_PATH/ekik-dashboard.jpg"
IMG_LOGIN="$PUBLIC_PATH/ekik-login.jpg"
CSS_FILE="$PUBLIC_PATH/ekik-cyan.css"

# ===== VALIDATION =====
if [ ! -d "$PT_PATH" ]; then
  echo "❌ Pterodactyl not found"
  exit 1
fi

# ===== DOWNLOAD IMAGES =====
echo ">>> Downloading images"
curl -fsSL https://files.catbox.moe/9yuwp3.jpg -o "$IMG_DASH"
curl -fsSL https://files.catbox.moe/cjg3lg.jpg -o "$IMG_LOGIN"

# ===== WRITE CSS =====
echo ">>> Writing CSS"
cat > "$CSS_FILE" <<'EOF'
/* ===== EKIK CYAN PRO ===== */
body {
  background: radial-gradient(circle at top, #0f2027, #000);
}

nav {
  box-shadow: 0 0 18px rgba(0,255,200,.35);
}

.sidebar {
  background: linear-gradient(180deg,#06191a,#000);
  box-shadow: 0 0 20px rgba(0,255,200,.25);
}

.sidebar a {
  border-radius: 10px;
  transition: .3s;
}

.sidebar a:hover {
  background: rgba(0,255,200,.15);
  box-shadow: 0 0 12px rgba(0,255,200,.5);
}

.dashboard-wrapper::before {
  content:"";
  display:block;
  height:240px;
  background:
    linear-gradient(rgba(0,0,0,.65),rgba(0,0,0,.9)),
    url('/ekik-dashboard.jpg') center/contain no-repeat;
  margin-bottom:30px;
}

.server-card {
  border:2px solid #00ffd5;
  box-shadow:0 0 15px rgba(0,255,200,.45);
  border-radius:20px;
}

.server-card:hover {
  transform:scale(1.02);
}

.login-container {
  background:
    linear-gradient(rgba(0,0,0,.7),rgba(0,0,0,.9)),
    url('/ekik-login.jpg') center/cover no-repeat !important;
}

button {
  border:1px solid #00ffd5;
  box-shadow:0 0 10px rgba(0,255,200,.6);
}
EOF

# ===== INJECT DASHBOARD =====
WRAPPER="$VIEW_PATH/templates/wrapper.blade.php"
if ! grep -q ekik-cyan.css "$WRAPPER"; then
  sed -i "/<\/head>/i <link rel=\"stylesheet\" href=\"\/ekik-cyan.css\">" "$WRAPPER"
fi

# ===== INJECT LOGIN =====
LOGIN=$(find "$VIEW_PATH" -name "login.blade.php" | head -n1)
if [ -n "$LOGIN" ]; then
  if ! grep -q ekik-login "$LOGIN"; then
    sed -i "1s|^|<div class=\"login-container\">|" "$LOGIN"
    echo "</div>" >> "$LOGIN"
  fi
fi

echo "✅ INSTALL DONE"
echo "⚠️ HARD REFRESH: CTRL + F5 / INCOGNITO"
