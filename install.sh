#!/usr/bin/env bash
set -e

echo ">>> EKIK SMART THEME v3 (BUNDLE INJECT)"

PANEL="/var/www/pterodactyl"
ASSET="$PANEL/public/ekik-theme"

BG1="https://files.catbox.moe/9yuwp3.jpg"
BG2="https://files.catbox.moe/cjg3lg.jpg"

mkdir -p "$ASSET"

echo "-> Download images"
curl -fsSL "$BG1" -o "$ASSET/dashboard.jpg"
curl -fsSL "$BG2" -o "$ASSET/login.jpg"

echo "-> Create CSS payload"
CSS_PAYLOAD=$(cat <<'EOF'
<style id="ekik-theme">
body{
  background:
    linear-gradient(rgba(0,0,0,.6),rgba(0,0,0,.85)),
    url("/ekik-theme/dashboard.jpg") center/cover fixed no-repeat !important;
}
button, .MuiButton-root{
  border:1px solid #00ffd5!important;
  box-shadow:0 0 12px rgba(0,255,213,.6);
}
.MuiPaper-root{
  border:1px solid rgba(0,255,213,.6)!important;
  border-radius:18px!important;
  box-shadow:0 0 20px rgba(0,255,213,.25);
}
header, .MuiAppBar-root{
  background:rgba(10,14,20,.85)!important;
}
a, span{
  text-shadow:0 0 8px rgba(0,255,213,.6);
}
#app{
  background:
    linear-gradient(rgba(0,0,0,.65),rgba(0,0,0,.9)),
    url("/ekik-theme/login.jpg") center/cover no-repeat !important;
}
</style>
EOF
)

echo "-> Inject into JS bundles"
for f in "$PANEL"/public/assets/*.js; do
  if ! grep -q "ekik-theme" "$f"; then
    sed -i "s|</head>|$CSS_PAYLOAD</head>|g" "$f"
  fi
done

echo "✔ INSTALL DONE"
echo "⚠ WAJIB: CTRL + F5 / MODE INCOGNITO"
