#!/usr/bin/env bash
set -euo pipefail

APP_PATH="${APP_PATH:-/Applications/카카오톡Sub.app}"
BUNDLE_ID="${BUNDLE_ID:-com.hoyaaaa.KakaoTalkSub}"
DISPLAY_NAME="${DISPLAY_NAME:-카카오톡Sub}"
PROFILE_PATH="${PROFILE_PATH:-/tmp/KakaoTalkSubNotifications.mobileconfig}"
ALERT_TYPE="${ALERT_TYPE:-1}" # 1: banner, 2: alert
PROFILE_ID="${PROFILE_ID:-com.hoyaaaa.KakaoTalkSub.notifications}"
SIGN_ID="${SIGN_ID:-}"
REINSTALL_PROFILE="${REINSTALL_PROFILE:-0}"

set_plist_bool() {
  local file="$1"
  local key="$2"
  local value="$3"

  plutil -replace "$key" -bool "$value" "$file"
}

find_signing_identity() {
  security find-identity -v -p codesigning 2>/dev/null |
    awk -F '"' '/Apple Development:/ { print $2; exit }'
}

if [[ ! -d "$APP_PATH" ]]; then
  echo "missing app: $APP_PATH" >&2
  exit 1
fi

if [[ "$ALERT_TYPE" != "1" && "$ALERT_TYPE" != "2" ]]; then
  echo "ALERT_TYPE must be 1 (banner) or 2 (alert)" >&2
  exit 1
fi

if [[ -z "$SIGN_ID" ]]; then
  SIGN_ID="$(find_signing_identity)"
fi

if [[ -z "$SIGN_ID" ]]; then
  echo "missing Apple Development code signing identity; set SIGN_ID explicitly" >&2
  exit 1
fi

defaults write "$BUNDLE_ID" "Show Notification" -bool true
defaults write "$BUNDLE_ID" "Notification Sound Enable" -bool true
defaults write "$BUNDLE_ID" "Notification Preview Enable" -bool true
defaults write "$BUNDLE_ID" "UseChatPreview" -bool true
defaults write "$BUNDLE_ID" "HideMenuBarIconBadge" -bool false

defaults_plist="$APP_PATH/Contents/Resources/Defaults.plist"
if [[ -f "$defaults_plist" ]]; then
  set_plist_bool "$defaults_plist" "Show Notification" true
  set_plist_bool "$defaults_plist" "Notification Sound Enable" true
  set_plist_bool "$defaults_plist" "Notification Preview Enable" true
  set_plist_bool "$defaults_plist" "UseChatPreview" true
  set_plist_bool "$defaults_plist" "HideMenuBarIconBadge" false
fi

codesign --force --deep --sign "$SIGN_ID" "$APP_PATH" >/dev/null

payload_uuid="$(uuidgen)"
profile_uuid="$(uuidgen)"
profile_title="카카오톡Sub 알림 배너 허용"
profile_desc="카카오톡Sub의 macOS 알림을 배너 스타일로 허용합니다."
if [[ "$ALERT_TYPE" == "2" ]]; then
  profile_title="카카오톡Sub 알림 허용"
  profile_desc="카카오톡Sub의 macOS 알림을 알림 스타일로 허용합니다."
fi

cat >"$PROFILE_PATH" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "https://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>PayloadContent</key>
  <array>
    <dict>
      <key>PayloadType</key>
      <string>com.apple.notificationsettings</string>
      <key>PayloadVersion</key>
      <integer>1</integer>
      <key>PayloadIdentifier</key>
      <string>${PROFILE_ID}.payload</string>
      <key>PayloadUUID</key>
      <string>$payload_uuid</string>
      <key>PayloadDisplayName</key>
      <string>카카오톡Sub 알림 허용</string>
      <key>NotificationSettings</key>
      <array>
        <dict>
          <key>BundleIdentifier</key>
          <string>$BUNDLE_ID</string>
          <key>NotificationsEnabled</key>
          <true/>
          <key>ShowInNotificationCenter</key>
          <true/>
          <key>ShowInLockScreen</key>
          <true/>
          <key>AlertType</key>
          <integer>$ALERT_TYPE</integer>
          <key>BadgesEnabled</key>
          <true/>
          <key>SoundsEnabled</key>
          <true/>
          <key>PreviewType</key>
          <integer>0</integer>
        </dict>
      </array>
    </dict>
  </array>
  <key>PayloadType</key>
  <string>Configuration</string>
  <key>PayloadVersion</key>
  <integer>1</integer>
  <key>PayloadIdentifier</key>
  <string>$PROFILE_ID</string>
  <key>PayloadUUID</key>
  <string>$profile_uuid</string>
  <key>PayloadDisplayName</key>
  <string>$profile_title</string>
  <key>PayloadDescription</key>
  <string>$profile_desc</string>
  <key>PayloadOrganization</key>
  <string>KakaoTalkSubMacos</string>
</dict>
</plist>
EOF

plutil -lint "$PROFILE_PATH" >/dev/null

if profiles list 2>/dev/null | grep -q "profileIdentifier: $PROFILE_ID"; then
  if [[ "$REINSTALL_PROFILE" == "1" ]]; then
    profiles remove -type configuration -identifier "$PROFILE_ID" -forced >/dev/null 2>&1 || true
    open "$PROFILE_PATH"
    profile_action="reinstall requested; finish by installing the opened profile in System Settings"
  else
    profile_action="already installed; skipped profile install"
  fi
else
  open "$PROFILE_PATH"
  profile_action="finish by installing the opened profile in System Settings"
fi

echo "enabled KakaoTalkSub notification defaults"
echo "signed app with: $SIGN_ID"
echo "profile created: $PROFILE_PATH"
echo "profile style: $([[ "$ALERT_TYPE" == "1" ]] && echo banner || echo alert)"
echo "$profile_action"
