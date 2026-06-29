#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC_APP="${SRC_APP:-/Applications/KakaoTalk.app}"
DEST_APP="${DEST_APP:-$PROJECT_DIR/카카오톡Sub.app}"
BUNDLE_ID="${BUNDLE_ID:-com.hoyaaaa.KakaoTalkSub}"
EXECUTABLE_NAME="${EXECUTABLE_NAME:-KakaoTalkSub}"
CREATE_SCRIPT="$PROJECT_DIR/scripts/create-kakaotalk-macos-clone.sh"

plist_value() {
  local app="$1"
  local key="$2"

  /usr/libexec/PlistBuddy -c "Print :$key" "$app/Contents/Info.plist"
}

app_version() {
  local app="$1"

  printf "%s (%s)" \
    "$(plist_value "$app" CFBundleShortVersionString)" \
    "$(plist_value "$app" CFBundleVersion)"
}

dialog() {
  osascript - "$@" <<'APPLESCRIPT'
on run argv
  set dialogTitle to item 1 of argv
  set dialogMessage to my replaceText(item 2 of argv, "\\n", linefeed)
  set buttonList to item 3 of argv
  set defaultButton to item 4 of argv
  set cancelButton to item 5 of argv

  set AppleScript's text item delimiters to "|"
  set buttons to text items of buttonList
  set AppleScript's text item delimiters to ""

  try
    set resultButton to button returned of (display dialog dialogMessage buttons buttons default button defaultButton cancel button cancelButton with title dialogTitle)
    return resultButton
  on error number -128
    return cancelButton
  end try
end run

on replaceText(sourceText, searchText, replacementText)
  set oldDelimiters to AppleScript's text item delimiters
  set AppleScript's text item delimiters to searchText
  set textItems to text items of sourceText
  set AppleScript's text item delimiters to replacementText
  set joinedText to textItems as text
  set AppleScript's text item delimiters to oldDelimiters
  return joinedText
end replaceText
APPLESCRIPT
}

if [[ ! -d "$SRC_APP" || ! -d "$DEST_APP" ]]; then
  exit 0
fi

src_version="$(app_version "$SRC_APP")"
dest_version="$(app_version "$DEST_APP")"

if [[ "$src_version" == "$dest_version" ]]; then
  exit 0
fi

choice="$(dialog \
  "카카오톡Sub 업데이트" \
  "공식 카카오톡 버전과 카카오톡Sub 버전이 다릅니다.\n\n공식: $src_version\nSub: $dest_version\n\n지금 카카오톡Sub를 새 공식 버전 기준으로 다시 만들까요?" \
  "나중에|업데이트" \
  "업데이트" \
  "나중에")"

if [[ "$choice" != "업데이트" ]]; then
  exit 0
fi

if pgrep -f "$DEST_APP/Contents/MacOS/$EXECUTABLE_NAME" >/dev/null 2>&1; then
  quit_choice="$(dialog \
    "카카오톡Sub 종료 필요" \
    "업데이트하려면 실행 중인 카카오톡Sub를 먼저 종료해야 합니다.\n\n종료하고 업데이트할까요?" \
    "나중에|종료 후 업데이트" \
    "종료 후 업데이트" \
    "나중에")"

  if [[ "$quit_choice" != "종료 후 업데이트" ]]; then
    exit 0
  fi

  osascript -e "tell application id \"$BUNDLE_ID\" to quit" >/dev/null 2>&1 || true

  for _ in {1..20}; do
    if ! pgrep -f "$DEST_APP/Contents/MacOS/$EXECUTABLE_NAME" >/dev/null 2>&1; then
      break
    fi
    sleep 1
  done

  if pgrep -f "$DEST_APP/Contents/MacOS/$EXECUTABLE_NAME" >/dev/null 2>&1; then
    dialog \
      "카카오톡Sub 업데이트 중단" \
      "카카오톡Sub가 아직 종료되지 않아 업데이트하지 않았습니다." \
      "확인" \
      "확인" \
      "확인" >/dev/null
    exit 1
  fi
fi

SRC_APP="$SRC_APP" DEST_APP="$DEST_APP" "$CREATE_SCRIPT" >/tmp/kakaotalk-sub-update.log 2>&1

open_choice="$(dialog \
  "카카오톡Sub 업데이트 완료" \
  "카카오톡Sub를 공식 카카오톡 $src_version 기준으로 업데이트했습니다." \
  "확인|열기" \
  "열기" \
  "확인")"

if [[ "$open_choice" == "열기" ]]; then
  open -n "$DEST_APP"
fi
