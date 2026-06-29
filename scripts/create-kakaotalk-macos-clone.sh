#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC_APP="${SRC_APP:-/Applications/KakaoTalk.app}"
CORE_APP="${CORE_APP:-$PROJECT_DIR/runtime/카카오톡Sub.app}"
WRAPPER_APP="${WRAPPER_APP:-$PROJECT_DIR/카카오톡Sub.app}"

mkdir -p "$(dirname "$CORE_APP")"
SRC_APP="$SRC_APP" DEST_APP="$CORE_APP" "$PROJECT_DIR/scripts/create-kakaotalk-core-clone.sh"
SRC_APP="$SRC_APP" WRAPPER_APP="$WRAPPER_APP" "$PROJECT_DIR/scripts/build-wrapper-app.sh"

echo
echo "Try:"
echo "open \"$WRAPPER_APP\""
