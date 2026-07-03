#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LABEL="com.hoyaaaa.MockaTalk.update-checker"
PLIST="$HOME/Library/LaunchAgents/$LABEL.plist"
APP_SUPPORT_ID="com.hoyaaaa.MockaTalk"
SUPPORT_DIR="$HOME/Library/Application Support/MockaTalkMacos"
LEGACY_LABEL="com.hoyaaaa.KakaoTalkSub.update-checker"
LEGACY_PLIST="$HOME/Library/LaunchAgents/$LEGACY_LABEL.plist"
LEGACY_APP_SUPPORT_ID="com.hoyaaaa.KakaoTalkSub"
LEGACY_SUPPORT_DIR="$HOME/Library/Application Support/KakaoTalkSubMacos"

if [[ "${1:-}" != "--yes" ]]; then
  echo "This will remove /Applications/MockaTalk.app, LaunchAgent, updater helper files, and com.hoyaaaa.MockaTalk user data."
  read -r -p "Type REMOVE to continue: " answer
  if [[ "$answer" != "REMOVE" ]]; then
    echo "cancelled"
    exit 0
  fi
fi

osascript -e "tell application id \"$APP_SUPPORT_ID\" to quit" >/dev/null 2>&1 || true
osascript -e "tell application id \"$LEGACY_APP_SUPPORT_ID\" to quit" >/dev/null 2>&1 || true
launchctl bootout "gui/$(id -u)" "$PLIST" >/dev/null 2>&1 || true
launchctl bootout "gui/$(id -u)" "$LEGACY_PLIST" >/dev/null 2>&1 || true

rm -f "$PLIST" "$LEGACY_PLIST"
rm -rf   "/Applications/MockaTalk.app"   "/Applications/카카오톡Sub.app"   "$PROJECT_DIR/MockaTalk.app"   "$PROJECT_DIR/카카오톡Sub.app"   "$PROJECT_DIR/runtime"   "$PROJECT_DIR/.build"   "$SUPPORT_DIR"   "$LEGACY_SUPPORT_DIR"   "$HOME/Library/Application Support/$APP_SUPPORT_ID"   "$HOME/Library/Application Support/$LEGACY_APP_SUPPORT_ID"   "$HOME/Library/WebKit/$APP_SUPPORT_ID"   "$HOME/Library/WebKit/$LEGACY_APP_SUPPORT_ID"   "$HOME/Library/Caches/$APP_SUPPORT_ID"   "$HOME/Library/Caches/$LEGACY_APP_SUPPORT_ID"   "$HOME/Library/HTTPStorages/$APP_SUPPORT_ID"   "$HOME/Library/HTTPStorages/$LEGACY_APP_SUPPORT_ID"   "$HOME/Library/Preferences/$APP_SUPPORT_ID.plist"   "$HOME/Library/Preferences/$LEGACY_APP_SUPPORT_ID.plist"   "$HOME/Library/Saved Application State/$APP_SUPPORT_ID.savedState"   "$HOME/Library/Saved Application State/$LEGACY_APP_SUPPORT_ID.savedState"

find "$HOME/Library/Logs" -maxdepth 2 -name "*$APP_SUPPORT_ID*" -exec rm -rf {} + 2>/dev/null || true
find "$HOME/Library/Logs" -maxdepth 2 -name "*$LEGACY_APP_SUPPORT_ID*" -exec rm -rf {} + 2>/dev/null || true

echo "removed MockaTalk app, updater helper, and local user data"
echo "source repo kept: $PROJECT_DIR"
