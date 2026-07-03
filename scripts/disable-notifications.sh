#!/usr/bin/env bash
set -euo pipefail

APP_PATH="${APP_PATH:-/Applications/카카오톡Sub.app}"
BUNDLE_ID="${BUNDLE_ID:-com.hoyaaaa.KakaoTalkSub}"
PROFILE_ID="${PROFILE_ID:-com.hoyaaaa.KakaoTalkSub.notifications}"
RESIGN_ADHOC="${RESIGN_ADHOC:-1}"

set_plist_bool() {
  local file="$1"
  local key="$2"
  local value="$3"

  plutil -replace "$key" -bool "$value" "$file"
}

profiles remove -type configuration -identifier "$PROFILE_ID" -forced >/dev/null 2>&1 || true

defaults write "$BUNDLE_ID" "Show Notification" -bool false
defaults write "$BUNDLE_ID" "Notification Sound Enable" -bool false
defaults write "$BUNDLE_ID" "Notification Preview Enable" -bool false
defaults write "$BUNDLE_ID" "UseChatPreview" -bool false
defaults write "$BUNDLE_ID" "HideMenuBarIconBadge" -bool true

defaults_plist="$APP_PATH/Contents/Resources/Defaults.plist"
if [[ -f "$defaults_plist" ]]; then
  set_plist_bool "$defaults_plist" "Show Notification" false
  set_plist_bool "$defaults_plist" "Notification Sound Enable" false
  set_plist_bool "$defaults_plist" "Notification Preview Enable" false
  set_plist_bool "$defaults_plist" "UseChatPreview" false
  set_plist_bool "$defaults_plist" "HideMenuBarIconBadge" true
fi

if [[ "$RESIGN_ADHOC" == "1" && -d "$APP_PATH" ]]; then
  codesign --force --deep --sign - "$APP_PATH" >/dev/null
fi

echo "removed notification profile if present: $PROFILE_ID"
echo "disabled KakaoTalkSub notification defaults"
if [[ "$RESIGN_ADHOC" == "1" ]]; then
  echo "re-signed app ad-hoc: $APP_PATH"
fi
