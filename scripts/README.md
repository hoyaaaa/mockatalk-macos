# Scripts

This directory contains the active helper scripts.

- `create-kakaotalk-macos-clone.sh`: copy `/Applications/KakaoTalk.app` with a
  distinct bundle id, display name, executable name, URL scheme suffix, and
  ad-hoc signature.
- `check-kakaotalk-sub-update.sh`: compare official KakaoTalk and
  `카카오톡Sub.app` versions, then show an update dialog only when they differ.
- `install-update-checker.sh`: install a user LaunchAgent that runs the update
  checker every 6 hours by default.

Do not put secrets here.
