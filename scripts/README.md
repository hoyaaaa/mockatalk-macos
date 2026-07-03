# Scripts

MockaTalk의 카카오톡 mock 복제본 설치와 업데이트 확인에 쓰는 스크립트입니다.

이 스크립트들은 Kakao Corp.에서 제공하거나 승인한 공식 도구가 아닙니다. 공식 카카오톡 앱을 복사/수정해 별도 앱 번들로 실행하게 만드는 비공식 실험용 도구이므로, 카카오톡 업데이트나 정책 변경에 따라 언제든 동작하지 않을 수 있고 계정 제한, 데이터 손실, 알림 누락, 앱 오작동 같은 문제가 생길 수 있습니다.

- `install-app.sh`: `/Applications/MockaTalk.app`을 설치하고 업데이트 체커를 등록합니다.
- `create-mockatalk-clone.sh`: 공식 `/Applications/KakaoTalk.app`을 복사해 `MockaTalk.app`을 만듭니다.
- `install-update-checker.sh`: Swift 업데이트 체커를 `~/Library/Application Support/MockaTalkMacos`에 설치하고, 5분마다 실행하는 사용자 LaunchAgent를 등록합니다.
- `enable-notifications.sh`: `MockaTalk`를 Apple Development 인증서로 재서명하고 카카오톡/macOS 알림 허용 profile 설치 UI를 엽니다.
- `disable-notifications.sh`: 알림 허용 profile을 제거하고 `MockaTalk` 알림 기본값을 다시 끕니다.
- `uninstall.sh`: `/Applications` 앱, LaunchAgent, 업데이트 helper, 사용자 데이터를 제거합니다.

비밀번호나 개인 토큰을 이 폴더에 넣지 마세요.
