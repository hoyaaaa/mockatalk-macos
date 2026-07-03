# Scripts

카카오톡Sub 설치와 업데이트 확인에 쓰는 스크립트입니다.

- `install-app.sh`: `/Applications/카카오톡Sub.app`을 설치하고 업데이트 체커를 등록합니다.
- `create-kakaotalk-macos-clone.sh`: 공식 `/Applications/KakaoTalk.app`을 복사해 `카카오톡Sub.app`을 만듭니다.
- `install-update-checker.sh`: Swift 업데이트 체커를 `~/Library/Application Support/KakaoTalkSubMacos`에 설치하고, 5분마다 실행하는 사용자 LaunchAgent를 등록합니다.
- `enable-notifications.sh`: `카카오톡Sub`를 Apple Development 인증서로 재서명하고 카카오톡/macOS 알림 허용 profile 설치 UI를 엽니다.
- `disable-notifications.sh`: 알림 허용 profile을 제거하고 `카카오톡Sub` 알림 기본값을 다시 끕니다.
- `uninstall.sh`: `/Applications` 앱, LaunchAgent, 업데이트 helper, 사용자 데이터를 제거합니다.

비밀번호나 개인 토큰을 이 폴더에 넣지 마세요.
