#!/bin/bash

set -e

# Target test environment directory
BASE_DIR="./nginx-test-env"
CONF_SOURCE="./nginx-conf/nginx.conf"
MIME_SOURCE="./nginx-conf/mime.types"
CONF_FILE="$BASE_DIR/nginx.conf"
MIME_FILE="$BASE_DIR/mime.types"
HTML_FILE="$BASE_DIR/html/index.html"
LOG_DIR="$BASE_DIR/logs"

echo "🔧 Setting up Nginx test environment in $BASE_DIR..."

# Create required directories
mkdir -p "$BASE_DIR/html" "$LOG_DIR"

# Copy or generate mime.types
if [ -f "$MIME_SOURCE" ]; then
  echo "📄 Copying custom mime.types from $MIME_SOURCE"
  cp "$MIME_SOURCE" "$MIME_FILE"
else
  echo "⚠️ No mime.types found at $MIME_SOURCE, generating minimal version..."
  cat > "$MIME_FILE" <<EOF
types {
    text/html             html htm shtml;
    text/css              css;
    application/javascript js;
    application/json      json;
    text/plain            txt;
}
EOF
fi

# Copy nginx.conf
if [ ! -f "$CONF_SOURCE" ]; then
  echo "❌ nginx.conf not found at $CONF_SOURCE"
  exit 1
fi
echo "📄 Copying nginx.conf from $CONF_SOURCE"
cp "$CONF_SOURCE" "$CONF_FILE"

# Create minimal index.html
cat > "$HTML_FILE" <<EOF
<!DOCTYPE html>
<html><body><h1>Nginx test OK</h1></body></html>
EOF

echo "✅ Test environment ready at: $BASE_DIR"
