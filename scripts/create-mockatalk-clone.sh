#!/usr/bin/env bash
set -euo pipefail

SRC_APP="${SRC_APP:-/Applications/KakaoTalk.app}"
DEST_APP="${DEST_APP:-/Applications/MockaTalk.app}"
BUNDLE_ID="${BUNDLE_ID:-com.hoyaaaa.MockaTalk}"
DISPLAY_NAME="${DISPLAY_NAME:-MockaTalk}"
EXECUTABLE_NAME="${EXECUTABLE_NAME:-MockaTalk}"
URL_SUFFIX="${URL_SUFFIX:-mockatalk}"
DISABLE_NOTIFICATIONS="${DISABLE_NOTIFICATIONS:-1}"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ICON_SOURCE="${ICON_SOURCE:-$PROJECT_DIR/assets/mockatalk-icon.png}"

set_plist_string() {
  local file="$1"
  local key="$2"
  local value="$3"

  /usr/libexec/PlistBuddy -c "Set :$key $value" "$file" 2>/dev/null || \
    /usr/libexec/PlistBuddy -c "Add :$key string $value" "$file" 2>/dev/null || \
    plutil -replace "$key" -string "$value" "$file"
}

set_plist_bool() {
  local file="$1"
  local key="$2"
  local value="$3"

  plutil -replace "$key" -bool "$value" "$file"
}

disable_notification_defaults() {
  local defaults_plist="$DEST_APP/Contents/Resources/Defaults.plist"

  if [[ -f "$defaults_plist" ]]; then
    set_plist_bool "$defaults_plist" "Show Notification" false
    set_plist_bool "$defaults_plist" "Notification Sound Enable" false
    set_plist_bool "$defaults_plist" "Notification Preview Enable" false
    set_plist_bool "$defaults_plist" "UseChatPreview" false
    set_plist_bool "$defaults_plist" "HideMenuBarIconBadge" true
  fi

  defaults write "$BUNDLE_ID" "Show Notification" -bool false
  defaults write "$BUNDLE_ID" "Notification Sound Enable" -bool false
  defaults write "$BUNDLE_ID" "Notification Preview Enable" -bool false
  defaults write "$BUNDLE_ID" "UseChatPreview" -bool false
  defaults write "$BUNDLE_ID" "HideMenuBarIconBadge" -bool true
}

apply_custom_icon() {
  local icon_source="$1"
  local icon_name="AppIcon"
  local iconset

  if [[ ! -f "$icon_source" ]]; then
    return 0
  fi

  iconset="$(mktemp -d)/${icon_name}.iconset"
  mkdir -p "$iconset"

  sips -z 16 16 "$icon_source" --out "$iconset/icon_16x16.png" >/dev/null
  sips -z 32 32 "$icon_source" --out "$iconset/icon_16x16@2x.png" >/dev/null
  sips -z 32 32 "$icon_source" --out "$iconset/icon_32x32.png" >/dev/null
  sips -z 64 64 "$icon_source" --out "$iconset/icon_32x32@2x.png" >/dev/null
  sips -z 128 128 "$icon_source" --out "$iconset/icon_128x128.png" >/dev/null
  sips -z 256 256 "$icon_source" --out "$iconset/icon_128x128@2x.png" >/dev/null
  sips -z 256 256 "$icon_source" --out "$iconset/icon_256x256.png" >/dev/null
  sips -z 512 512 "$icon_source" --out "$iconset/icon_256x256@2x.png" >/dev/null
  sips -z 512 512 "$icon_source" --out "$iconset/icon_512x512.png" >/dev/null
  sips -z 1024 1024 "$icon_source" --out "$iconset/icon_512x512@2x.png" >/dev/null

  iconutil -c icns "$iconset" -o "$DEST_APP/Contents/Resources/${icon_name}.icns"
  /usr/libexec/PlistBuddy -c "Set :CFBundleIconFile ${icon_name}.icns" "$INFO" 2>/dev/null || \
    /usr/libexec/PlistBuddy -c "Add :CFBundleIconFile string ${icon_name}.icns" "$INFO"
  /usr/libexec/PlistBuddy -c "Delete :CFBundleIconName" "$INFO" 2>/dev/null || true
}

if [[ ! -d "$SRC_APP" ]]; then
  echo "missing source app: $SRC_APP" >&2
  exit 1
fi

if [[ -e "$DEST_APP" ]]; then
  rm -rf "$DEST_APP"
fi

cp -R "$SRC_APP" "$DEST_APP"
xattr -cr "$DEST_APP" || true

INFO="$DEST_APP/Contents/Info.plist"
OLD_EXECUTABLE=$(/usr/libexec/PlistBuddy -c "Print :CFBundleExecutable" "$INFO")
if [[ "$OLD_EXECUTABLE" != "$EXECUTABLE_NAME" ]]; then
  mv "$DEST_APP/Contents/MacOS/$OLD_EXECUTABLE" "$DEST_APP/Contents/MacOS/$EXECUTABLE_NAME"
fi

/usr/libexec/PlistBuddy -c "Set :CFBundleIdentifier $BUNDLE_ID" "$INFO"
/usr/libexec/PlistBuddy -c "Set :CFBundleDisplayName $DISPLAY_NAME" "$INFO" 2>/dev/null || \
  /usr/libexec/PlistBuddy -c "Add :CFBundleDisplayName string $DISPLAY_NAME" "$INFO"
/usr/libexec/PlistBuddy -c "Set :CFBundleName $DISPLAY_NAME" "$INFO"
/usr/libexec/PlistBuddy -c "Set :CFBundleExecutable $EXECUTABLE_NAME" "$INFO"

# Avoid fighting the original app for URL scheme ownership.
if /usr/libexec/PlistBuddy -c "Print :CFBundleURLTypes" "$INFO" >/dev/null 2>&1; then
  count=$(/usr/libexec/PlistBuddy -c "Print :CFBundleURLTypes" "$INFO" | grep -c "Dict {" || true)
  for ((i=0; i<count; i++)); do
    /usr/libexec/PlistBuddy -c "Set :CFBundleURLTypes:$i:CFBundleURLName ${BUNDLE_ID}.url.$i" "$INFO" 2>/dev/null || true
    if /usr/libexec/PlistBuddy -c "Print :CFBundleURLTypes:$i:CFBundleURLSchemes:0" "$INFO" >/dev/null 2>&1; then
      old=$(/usr/libexec/PlistBuddy -c "Print :CFBundleURLTypes:$i:CFBundleURLSchemes:0" "$INFO")
      /usr/libexec/PlistBuddy -c "Set :CFBundleURLTypes:$i:CFBundleURLSchemes:0 ${old}-${URL_SUFFIX}" "$INFO"
    fi
  done
fi

find "$DEST_APP" -path '*/Contents/Resources/*.lproj/InfoPlist.strings' -print0 |
while IFS= read -r -d '' strings_file; do
  set_plist_string "$strings_file" CFBundleDisplayName "$DISPLAY_NAME"
  set_plist_string "$strings_file" CFBundleName "$DISPLAY_NAME"
done

apply_custom_icon "$ICON_SOURCE"

if [[ "$DISABLE_NOTIFICATIONS" == "1" ]]; then
  disable_notification_defaults
fi

# Re-sign ad-hoc. Do not preserve App Store restricted entitlements; they are
# bound to Kakao's team provisioning and may prevent a modified clone launching.
codesign --force --deep --sign - "$DEST_APP" >/dev/null

echo "created: $DEST_APP"
echo "bundle id: $BUNDLE_ID"
echo "display name: $DISPLAY_NAME"
echo "executable: $EXECUTABLE_NAME"
if [[ -f "$ICON_SOURCE" ]]; then
  echo "icon: $ICON_SOURCE"
fi
if [[ "$DISABLE_NOTIFICATIONS" == "1" ]]; then
  echo "notifications: disabled by default"
fi
