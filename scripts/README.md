# Scripts

카카오톡Sub 래퍼 앱 생성과 업데이트 확인에 쓰는 스크립트입니다.

- `create-kakaotalk-macos-clone.sh`: 내부 복제 앱과 `카카오톡Sub.app` 래퍼를 함께 만듭니다.
- `create-kakaotalk-core-clone.sh`: 공식 `/Applications/KakaoTalk.app`을 복사해 내부 앱 `runtime/카카오톡Sub.app`을 만듭니다.
- `build-wrapper-app.sh`: Swift 래퍼 앱 `카카오톡Sub.app`을 빌드합니다.
- `install-update-checker.sh`: Swift 업데이트 체커를 빌드하고, 1시간마다 실행하는 사용자 LaunchAgent를 설치합니다.

비밀번호나 개인 토큰을 이 폴더에 넣지 마세요.
