# Security and Licensing

## Windows Licensing

This project runs a Windows 11 ARM64 guest from a non-Windows host for the MVP. Windows 10 ARM64 may be tested later as a lower-spec experiment because KakaoTalk lists Windows 10 or later, but it is not the primary target.

The user is responsible for valid Windows licensing and activation. Consumer/OEM licensing may not cover this use case. Organizational or commercial use may require additional virtualization rights.

## KakaoTalk Terms

This project wraps the official Windows KakaoTalk client. It does not modify KakaoTalk.

Use the official installer:

`https://lk.kakaocdn.net/talkpc/talk/qwin64/KakaoTalk_Setup.exe`

## Security Boundary

This is a VM boundary, not a native app sandbox.

Recommended MVP defaults:

- NAT networking enabled
- clipboard enabled only if needed
- no arbitrary host folder sharing after setup
- no printer redirection
- no microphone redirection unless needed
- persistent overlay stored in user Application Support

## Secrets and Sessions

KakaoTalk login/session state will live inside the persistent Windows overlay.

Treat `kakaotalk.qcow2` as sensitive data.

## Third-Party Code

macSandbox is dual-licensed AGPL/commercial. Copying code into this project may impose AGPL obligations unless a compatible license path is chosen.

Safer early approach:

- use macSandbox as a local reference
- write minimal new code
- call QEMU/FreeRDP externally

If copying source files directly, preserve license headers and understand resulting licensing obligations.
