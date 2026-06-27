# Decisions

## 2026-06-27: Build a dedicated app wrapper, not a macSandbox configuration

macSandbox is fundamentally a disposable VM runner. KakaoTalk needs persistent install and login state.

Decision:

Create a new focused project, `KakaoTalkWinApp`, and reuse only the concepts/code needed for VM lifecycle and RDP.

## 2026-06-27: Accept VM-backed reality

Windows KakaoTalk cannot practically run as a native macOS process.

Decision:

The product is a macOS app shell around a dedicated Windows VM. UX should be app-like, but documentation must stay honest that it is VM-backed.

## 2026-06-27: Persistent overlay is mandatory

Disposable overlays make KakaoTalk unusable because login and installation state disappear.

Decision:

Use one persistent qcow2 overlay per KakaoTalk app/profile.

## 2026-06-27: RemoteApp is stretch, not MVP

Current macSandbox code uses full desktop RDP and has no RAIL/RemoteApp support.

Decision:

Ship MVP with full RDP surface hidden/polished as much as possible. Research RemoteApp later.

## 2026-06-27: Target the oldest KakaoTalk-supported Windows

Current KakaoTalk for Windows system requirements list Windows 10 or later.

Decision:

Prefer a Windows 10 ARM64 guest baseline. Use Windows 11 ARM64 only as a documented compatibility fallback if Windows 10 ARM64 media, drivers, RDP, or KakaoTalk behavior blocks the MVP.
