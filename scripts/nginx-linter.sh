#!/bin/bash

set -e

# Répertoire de test utilisé comme racine simulée de Nginx
BASE_DIR="./nginx-conf"
CONF_SOURCE="./nginx-conf/nginx.conf"
MIME_SOURCE="./nginx-conf/mime.types"
HTML_FILE="$BASE_DIR/html/index.html"
LOG_DIR="$BASE_DIR/logs"

echo "🔧 Setting up Nginx test environment in $BASE_DIR..."

# Crée les répertoires requis
mkdir -p "$BASE_DIR/html"
mkdir -p "$LOG_DIR"

# Copie ou génère mime.types
if [ ! -f "$MIME_SOURCE" ]; then
  echo "⚠️ mime.types manquant, génération d'une version minimale"
  cat > "$MIME_SOURCE" <<EOF
types {
    text/html             html htm shtml;
    text/css              css;
    application/javascript js;
    application/json      json;
    text/plain            txt;
}
EOF
else
  echo "📄 mime.types détecté dans $MIME_SOURCE"
fi

# Vérifie que nginx.conf existe
if [ ! -f "$CONF_SOURCE" ]; then
  echo "❌ nginx.conf introuvable à $CONF_SOURCE"
  exit 1
fi

# Crée un fichier HTML minimal
cat > "$HTML_FILE" <<EOF
<!DOCTYPE html>
<html><body><h1>Nginx test OK</h1></body></html>
EOF

echo "✅ Dossier de test prêt dans $BASE_DIR"
