#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
APP_PATH="${APP_PATH:-/Applications/카카오톡Sub.app}"

DEST_APP="$APP_PATH" "$PROJECT_DIR/scripts/create-kakaotalk-macos-clone.sh"
"$PROJECT_DIR/scripts/install-update-checker.sh"

echo "installed app: $APP_PATH"
echo "open: open "$APP_PATH""
