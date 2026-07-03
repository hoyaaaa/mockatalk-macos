<p align="center">
  <img src="assets/mockatalk-icon.png" alt="MockaTalk logo" width="160">
</p>

<h1 align="center">MockaTalk</h1>

MockaTalk은 별도 브랜드나 공식 제품명이 아니라, macOS용 공식 카카오톡 앱을 개인 사용 목적으로 복사해 mock 복제본을 만드는 비공식 스크립트 모음입니다.

이 프로젝트는 Kakao Corp., 카카오톡, KakaoTalk와 아무 관련이 없습니다. 카카오에서 제공, 승인, 검수, 보증, 지원하는 앱이나 도구가 아닙니다.

## 강한 경고

- 이 프로젝트는 비공식 도구입니다.
- 이 프로젝트는 공식 카카오톡 앱을 수정/복사해 별도 앱 번들로 실행하게 만드는 실험적 스크립트입니다.
- 이 프로젝트 사용은 카카오톡 이용약관, 보안 정책, 운영 정책에 위반될 수 있습니다.
- 이 프로젝트 사용으로 로그인 제한, 계정 제한, 계정 정지, 메시지/파일/대화 데이터 손실, 알림 누락, 앱 충돌, 보안 경고, macOS 설정 꼬임, 기타 불이익이 발생할 수 있습니다.
- 카카오톡 앱 업데이트, macOS 업데이트, 카카오 서버 정책 변경, 인증/알림/로그인 방식 변경에 따라 언제든 동작하지 않을 수 있습니다.
- 현재 동작하더라도 이후 버전에서 계속 동작한다고 보장하지 않습니다.
- 실제 알림, Dock 뱃지, Notification Center 등록, 자동 업데이트 확인은 모두 환경에 따라 불안정할 수 있습니다.
- 이 프로젝트는 지원 의무가 있는 소프트웨어가 아니며, 문제 발생 시 공식 카카오 고객센터나 Kakao Corp.에 이 프로젝트 관련 지원을 요청하면 안 됩니다.
- 사용 여부와 그 결과에 대한 책임은 전적으로 사용자 본인에게 있습니다.

`/Applications/MockaTalk.app` 자체가 실제 실행 앱입니다. 업데이트 확인은 설치 시 등록되는 LaunchAgent가 백그라운드에서 담당합니다.

## 기능

- 공식 macOS 카카오톡을 기반으로 별도 앱인 `/Applications/MockaTalk.app`을 만듭니다.
- 원본 카카오톡과 다른 번들 ID(`com.hoyaaaa.MockaTalk`)를 사용해 앱 지원 파일, WebKit, 캐시, 설정 파일이 분리되도록 합니다.
- 앱 이름, 실행 파일 이름, 한국어 표시 이름을 `MockaTalk`로 맞춥니다.
- `assets/mockatalk-icon.png`가 있으면 앱 아이콘을 `MockaTalk`용 아이콘으로 바꿉니다.
- 카카오톡 URL 스킴에 `-mockatalk` 접미사를 붙여 원본 앱과 URL 스킴 소유권이 충돌하지 않도록 합니다.
- 수정된 앱 번들을 ad-hoc 서명해 macOS에서 실행 가능하도록 만듭니다.
- 알림 충돌 가능성을 줄이기 위해 `MockaTalk`의 알림, 알림 사운드, 미리보기, 메뉴 막대 뱃지 기본값을 꺼둡니다.
- `/Applications`에 바로 설치하므로 Dock 고정, Spotlight, Finder 실행이 자연스럽습니다.
- 5분마다 공식 카카오톡과 `MockaTalk`의 버전을 비교하고, 버전이 다르면 업데이트 확인 창을 띄웁니다.
- 업데이트 helper는 `~/Library/Application Support/MockaTalkMacos`에 설치되어, 설치 후 repo 폴더를 옮겨도 자동 업데이트 확인이 계속 동작합니다.
- `scripts/uninstall.sh`로 앱, LaunchAgent, 업데이트 helper, `MockaTalk` 사용자 데이터를 정리할 수 있습니다.

## 차이점

단순히 앱을 복사하고 `Info.plist` 문자열 몇 개만 바꾸는 방식보다 더 많은 부분을 자동으로 처리합니다.

- 한국어 환경에서 Dock/Finder에 다시 `카카오톡`으로 보이지 않도록 로컬라이즈된 `InfoPlist.strings`까지 수정합니다.
- 실행 파일 이름까지 바꿔 프로세스와 번들 구성이 `MockaTalk` 기준으로 맞춰집니다.
- URL 스킴을 원본과 분리해 `kakaotalk`, `kakaoshare` 같은 링크 처리 충돌 가능성을 줄입니다.
- 설치 결과가 `/Applications/MockaTalk.app` 하나로 정리되어 Dock에 고정해도 runtime 경로나 임시 앱이 잡히지 않습니다.
- 공식 카카오톡이 업데이트돼도 5분 주기 버전 비교로 감지하고, 확인 후 `MockaTalk`를 다시 만들 수 있습니다.
- 업데이트 확인용 helper가 repo 바깥에 설치되어 repo 폴더 위치 변경에 덜 민감합니다.
- 완전 제거 스크립트를 제공해 남는 LaunchAgent나 helper 파일을 직접 찾아 지울 필요를 줄입니다.

## 주의

이 프로젝트는 카카오에서 제공하거나 보증하는 공식 도구가 아닙니다. 공식 앱, 공식 클라이언트, 공식 보조 앱, 공식 서브 앱, 공식 멀티 계정 기능이 아닙니다.

이 도구 사용으로 인해 카카오톡 이용약관 위반, 로그인 제한, 계정 정지, 데이터 손실, 앱 오작동, 기타 불이익이 발생할 수 있습니다. 카카오톡 업데이트에 따라 더 이상 지원되지 않거나 실행되지 않을 수 있습니다. 사용 여부와 그 결과에 대한 책임은 전적으로 사용자 본인에게 있습니다.

## 준비

- macOS용 공식 카카오톡이 `/Applications/KakaoTalk.app`에 설치되어 있어야 합니다.
- Xcode Command Line Tools의 기본 도구(`swiftc`, `/usr/libexec/PlistBuddy`, `plutil`, `codesign`)를 사용합니다.

## 설치

```bash
git clone https://github.com/hoyaaaa/mockatalk-macos.git
cd mockatalk-macos
scripts/install-app.sh
```

## 앱 아이콘

앱 아이콘 원본은 `assets/mockatalk-icon.png`입니다. 설치 스크립트는 이 PNG를 macOS용 `AppIcon.icns`로 변환해 `/Applications/MockaTalk.app` 번들에 적용합니다.

현재 아이콘은 Gemini로 생성한 MockaTalk 전용 이미지입니다. Kakao Corp.의 공식 카카오톡 아이콘이나 상표 자산이 아닙니다.

`MockaTalk`의 알림 기본값을 끄지 않고 설치하려면:

```bash
DISABLE_NOTIFICATIONS=0 scripts/install-app.sh
```

실제 macOS 알림까지 켜려면 Apple Development 코드서명 인증서가 필요합니다. 설치 후 다음을 실행하면 `MockaTalk` 내부 알림 설정을 켜고, 앱을 개발자 인증서로 재서명한 뒤, macOS 알림 허용 profile 설치 화면을 엽니다.

```bash
scripts/enable-notifications.sh
```

macOS가 profile 자동 설치를 CLI에서 막기 때문에, profile이 처음 없을 때의 설치 승인만 시스템 설정에서 직접 눌러야 합니다. 이미 profile이 설치되어 있으면 이후 실행은 앱 재서명과 카카오톡 내부 알림 설정만 자동으로 갱신합니다. 배너 대신 닫을 때까지 남는 알림 스타일을 쓰려면:

```bash
REINSTALL_PROFILE=1 ALERT_TYPE=2 scripts/enable-notifications.sh
```

알림 설정을 다시 끄려면:

```bash
scripts/disable-notifications.sh
```

설치되는 항목:

- 실행 앱: `/Applications/MockaTalk.app`
- 번들 ID: `com.hoyaaaa.MockaTalk`
- 표시 이름: `MockaTalk`
- 업데이트 체커: `~/Library/LaunchAgents/com.hoyaaaa.MockaTalk.update-checker.plist`
- 업데이트 helper: `~/Library/Application Support/MockaTalkMacos`
- 선택 알림 profile: `com.hoyaaaa.MockaTalk.notifications`

## 실행

```bash
open "/Applications/MockaTalk.app"
```

## 업데이트 확인

설치 스크립트가 LaunchAgent를 등록하므로, macOS가 5분마다 공식 카카오톡과 `/Applications/MockaTalk.app`의 버전을 비교합니다.

버전이 다르면 macOS 확인 창으로 업데이트 여부를 묻고, 사용자가 동의하면 최신 공식 앱을 기준으로 `/Applications/MockaTalk.app`을 다시 만듭니다.

## 수동 업데이트

공식 카카오톡이 업데이트된 뒤 직접 갱신하고 싶으면 다시 실행하면 됩니다.

```bash
scripts/install-app.sh
```

이 명령은 `/Applications/MockaTalk.app`을 새로 만들지만, 일반적으로 `~/Library/Application Support/com.hoyaaaa.MockaTalk` 같은 사용자 데이터 폴더는 지우지 않습니다.

## 한계

- 같은 macOS 사용자 안에서 실행되는 앱 복사본입니다.
- 공식 카카오톡을 대체하거나 보완하는 공식 기능이 아닙니다.
- 하드웨어 정보, Mac 모델, OS 버전, IP 주소, 카카오 서버의 계정/세션 정보까지 숨기지는 않습니다.
- 공식 앱과 완전히 다른 기기처럼 보장하는 방식은 아닙니다.
- 원본 앱과 다른 번들 ID로 ad-hoc 서명되므로 macOS 알림, Dock 뱃지, Notification Center 등록은 안정적으로 동작한다고 보장하지 않습니다. 기본 설치는 충돌 가능성을 줄이기 위해 `MockaTalk`의 알림 관련 기본값을 꺼둡니다. `enable-notifications.sh`는 이 제한을 완화하기 위한 실험적 설정입니다.
- 공식 앱 업데이트 후에는 `MockaTalk.app`을 다시 만들어야 합니다.
- 카카오톡 정책 변경이나 앱 업데이트에 따라 언제든 동작하지 않을 수 있습니다.
- 카카오톡 내부 구조, 권한, 서명, 알림 구현, URL 스킴, 데이터 저장 위치가 바뀌면 이 스크립트는 예고 없이 깨질 수 있습니다.
- 이 프로젝트는 문제 발생 시 계정, 대화, 첨부 파일, 로그인 상태, 알림 동작을 복구해 준다고 보장하지 않습니다.

## 제거

완전히 제거하려면:

```bash
scripts/uninstall.sh
```

이 스크립트는 `/Applications/MockaTalk.app`, LaunchAgent, 업데이트 helper, `com.hoyaaaa.MockaTalk` 사용자 데이터를 제거합니다. 실행 시 확인 문구를 요구하며, 소스 repo 폴더 자체는 지우지 않습니다.

확인 없이 제거하려면:

```bash
scripts/uninstall.sh --yes
```

## 라이선스

이 프로젝트의 코드는 MIT License로 배포됩니다. 자세한 내용은 [LICENSE](LICENSE)를 확인하세요.

카카오톡, KakaoTalk 및 관련 상표와 앱은 Kakao Corp.의 소유입니다. 이 프로젝트는 Kakao Corp.와 관련이 없는 비공식 도구이며, Kakao Corp.의 승인, 보증, 후원, 제휴, 검수, 지원을 받지 않았습니다.
