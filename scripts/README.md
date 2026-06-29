# Scripts

카카오톡Sub 설치와 업데이트 확인에 쓰는 스크립트입니다.

- `install-app.sh`: `/Applications/카카오톡Sub.app`을 설치하고 업데이트 체커를 등록합니다.
- `create-kakaotalk-macos-clone.sh`: 공식 `/Applications/KakaoTalk.app`을 복사해 `카카오톡Sub.app`을 만듭니다.
- `install-update-checker.sh`: Swift 업데이트 체커를 빌드하고, 5분마다 실행하는 사용자 LaunchAgent를 설치합니다.
- `uninstall.sh`: `/Applications` 앱, LaunchAgent, 로컬 빌드 파일, 사용자 데이터를 제거합니다.

비밀번호나 개인 토큰을 이 폴더에 넣지 마세요.
