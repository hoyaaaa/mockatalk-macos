#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LABEL="com.hoyaaaa.MockaTalk.update-checker"
PLIST="$HOME/Library/LaunchAgents/$LABEL.plist"
LEGACY_LABEL="com.hoyaaaa.KakaoTalkSub.update-checker"
LEGACY_PLIST="$HOME/Library/LaunchAgents/$LEGACY_LABEL.plist"
LEGACY_SUPPORT_DIR="$HOME/Library/Application Support/KakaoTalkSubMacos"
SUPPORT_DIR="$HOME/Library/Application Support/MockaTalkMacos"
INTERVAL_SECONDS="${INTERVAL_SECONDS:-300}"
UPDATER_BIN="$SUPPORT_DIR/MockaTalkUpdater"
UPDATER_SRC="$PROJECT_DIR/Sources/MockaTalkUpdater/main.swift"

mkdir -p "$HOME/Library/LaunchAgents" "$SUPPORT_DIR/scripts" "$SUPPORT_DIR/assets"

swiftc "$UPDATER_SRC" -o "$UPDATER_BIN"
cp "$PROJECT_DIR/scripts/create-mockatalk-clone.sh" "$SUPPORT_DIR/scripts/create-mockatalk-clone.sh"
chmod +x "$SUPPORT_DIR/scripts/create-mockatalk-clone.sh"
if [[ -d "$PROJECT_DIR/assets" ]]; then
  cp -R "$PROJECT_DIR/assets/." "$SUPPORT_DIR/assets/"
fi

cat >"$PLIST" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "https://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>$LABEL</string>
  <key>ProgramArguments</key>
  <array>
    <string>$UPDATER_BIN</string>
    <string>$SUPPORT_DIR</string>
  </array>
  <key>StartInterval</key>
  <integer>$INTERVAL_SECONDS</integer>
  <key>RunAtLoad</key>
  <true/>
  <key>StandardOutPath</key>
  <string>/tmp/mockatalk-update-checker.out.log</string>
  <key>StandardErrorPath</key>
  <string>/tmp/mockatalk-update-checker.err.log</string>
</dict>
</plist>
PLIST

chmod 644 "$PLIST"

launchctl bootout "gui/$(id -u)" "$LEGACY_PLIST" >/dev/null 2>&1 || true
launchctl bootout "gui/$(id -u)" "$PLIST" >/dev/null 2>&1 || true
rm -f "$LEGACY_PLIST"
rm -rf "$LEGACY_SUPPORT_DIR"
launchctl bootstrap "gui/$(id -u)" "$PLIST"
launchctl enable "gui/$(id -u)/$LABEL"

echo "installed: $PLIST"
echo "helper dir: $SUPPORT_DIR"
echo "interval: ${INTERVAL_SECONDS}s"
