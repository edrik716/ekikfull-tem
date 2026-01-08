#!/usr/bin/env bash
set -e

echo ">>> EKIK SMART THEME v2 (SAFE MODE)"

PANEL_DIR="/var/www/pterodactyl"
PUBLIC_DIR="$PANEL_DIR/public"
ASSET_DIR="$PUBLIC_DIR/ekik-theme"

BG_DASH="https://files.catbox.moe/9yuwp3.jpg"
BG_LOGIN="https://files.catbox.moe/cjg3lg.jpg"

mkdir -p "$ASSET_DIR"

echo "-> Download assets"
curl -fsSL "$BG_DASH" -o "$ASSET_DIR/bg-dashboard.jpg"
curl -fsSL "$BG_LOGIN" -o "$ASSET_DIR/bg-login.jpg"

echo "-> Write CSS"
cat > "$ASSET_DIR/ekik.css" <<'CSS'
/* ===== EKIK SMART THEME v2 ===== */
:root{
  --ekik-neon:#00ffd5;
  --ekik-bg:#0b0f14;
}

/* GLOBAL */
body{
  background:
    linear-gradient(180deg, rgba(0,0,0,.55), rgba(0,0,0,.75)),
    url("/ekik-theme/bg-dashboard.jpg") center/cover fixed no-repeat !important;
}

/* HEADER */
header, .MuiAppBar-root{
  background: rgba(10,14,20,.85)!important;
  box-shadow: 0 0 14px rgba(0,255,213,.35);
}

/* LOGO TEXT */
a[href="/"] span, header span{
  color: var(--ekik-neon)!important;
  text-shadow: 0 0 10px rgba(0,255,213,.7);
  letter-spacing: 1px;
}

/* SERVER CARD */
.MuiPaper-root{
  background: rgba(15,20,28,.9)!important;
  border: 1px solid rgba(0,255,213,.6)!important;
  box-shadow: 0 0 16px rgba(0,255,213,.25);
  border-radius: 18px!important;
}

/* BUTTON */
button{
  border: 1px solid rgba(0,255,213,.7)!important;
  color: #eafffb!important;
}
button:hover{
  box-shadow: 0 0 12px rgba(0,255,213,.8);
}

/* LOGIN PAGE (SAFE OVERLAY) */
#app{
  background:
    linear-gradient(180deg, rgba(0,0,0,.6), rgba(0,0,0,.85)),
    url("/ekik-theme/bg-login.jpg") center/cover no-repeat !important;
}

/* FOOTER */
footer{
  opacity:.8;
}
CSS

echo "-> Inject loader"
LOADER='
<link rel="stylesheet" href="/ekik-theme/ekik.css">
'
INDEX_HTML="$PUBLIC_DIR/index.html"

if ! grep -q "ekik-theme/ekik.css" "$INDEX_HTML"; then
  sed -i "s#</head>#$LOADER\n</head>#g" "$INDEX_HTML"
fi

echo "✔ INSTALL DONE"
echo "⚠ HARD REFRESH: CTRL+F5 / INCOGNITO"
