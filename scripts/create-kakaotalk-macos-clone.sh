#!/usr/bin/env bash
set -euo pipefail

SRC_APP="${SRC_APP:-/Applications/KakaoTalk.app}"
DEST_APP="${DEST_APP:-$PWD/카카오톡Sub.app}"
BUNDLE_ID="${BUNDLE_ID:-com.hoyaaaa.KakaoTalkSub}"
DISPLAY_NAME="${DISPLAY_NAME:-카카오톡Sub}"
EXECUTABLE_NAME="${EXECUTABLE_NAME:-KakaoTalkSub}"
URL_SUFFIX="${URL_SUFFIX:-sub}"

set_plist_string() {
  local file="$1"
  local key="$2"
  local value="$3"

  /usr/libexec/PlistBuddy -c "Set :$key $value" "$file" 2>/dev/null || \
    /usr/libexec/PlistBuddy -c "Add :$key string $value" "$file" 2>/dev/null || \
    plutil -replace "$key" -string "$value" "$file"
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

# Re-sign ad-hoc. Do not preserve App Store restricted entitlements; they are
# bound to Kakao's team provisioning and may prevent a modified clone launching.
codesign --force --deep --sign - "$DEST_APP" >/dev/null

echo "created: $DEST_APP"
echo "bundle id: $BUNDLE_ID"
echo "display name: $DISPLAY_NAME"
echo "executable: $EXECUTABLE_NAME"
echo
echo "Try:"
echo "open -n \"$DEST_APP\""
