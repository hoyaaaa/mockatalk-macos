#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
APP_PATH="${APP_PATH:-/Applications/MockaTalk.app}"
LEGACY_APP_PATH="${LEGACY_APP_PATH:-/Applications/카카오톡Sub.app}"
LEGACY_PROFILE_ID="${LEGACY_PROFILE_ID:-com.hoyaaaa.KakaoTalkSub.notifications}"

rm -rf "$LEGACY_APP_PATH" "$PROJECT_DIR/카카오톡Sub.app"
profiles remove -type configuration -identifier "$LEGACY_PROFILE_ID" -forced >/dev/null 2>&1 || true
DEST_APP="$APP_PATH" "$PROJECT_DIR/scripts/create-mockatalk-clone.sh"
"$PROJECT_DIR/scripts/install-update-checker.sh"

echo "installed app: $APP_PATH"
echo "open: open "$APP_PATH""
