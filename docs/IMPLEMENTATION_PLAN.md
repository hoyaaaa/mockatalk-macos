# Implementation Plan

## Phase 0: Baseline Readiness

Use the local macSandbox source checkout, or a copied baseline builder derived from it, to create a Windows 11 ARM64 baseline.

Do not depend on an installed `/Applications/macSandbox for Windows.app`; it was removed and is not part of this project's expected inputs.

Reference source:

- local checkout: `/Users/hoya/macSandbox`
- upstream: `https://github.com/yourtablecloth/macSandbox.git`
- PR page: `https://github.com/yourtablecloth/macSandbox/pulls`

Done when:

- baseline metadata status is ready
- baseline qcow2 exists
- RDP can connect to a booted overlay
- KakaoTalk installer launches on Windows 11 ARM64

Expected source path after a successful macSandbox baseline build:

`/Users/hoya/Library/Application Support/MacSandbox/baseline/baseline.qcow2`

Windows 10 ARM64 is not the MVP target. Keep it as a later low-spec experiment only after Windows 11 ARM64 proves the end-to-end flow.

## Phase 1: Minimal External-RDP Prototype

Build a small script or Swift command runner that:

1. Creates persistent overlay if missing:
   `KakaoTalkWinApp/runtime/kakaotalk.qcow2`
2. Starts QEMU using macSandbox-style arguments.
3. Forwards `127.0.0.1:<port>` to guest `3389`.
4. Opens `sdl-freerdp` to connect.
5. Uses a config disk or Windows startup entry to run KakaoTalk.

This validates the core idea before building UI.

## Phase 2: Install and Persistence

First run:

- share `/Users/hoya/Downloads/KakaoTalk-Windows`
- run `KakaoTalk_Setup_qwin64.exe`
- create Windows startup shortcut or Run registry entry for KakaoTalk

Later runs:

- skip installer
- auto-run installed KakaoTalk
- keep overlay after quit

## Phase 3: macOS App Shell

Create `KakaoTalk Windows.app`.

Minimum UI:

- booting state
- RDP view
- error state
- quit/stop behavior

Do not expose general VM settings in the main UI.

## Phase 4: Embedded RDP

Replace external `sdl-freerdp` with embedded FreeRDP view.

Options:

- copy `CFreeRDP` module from macSandbox
- keep only display, input, clipboard, and optional audio output
- remove printer/mic/folder UI unless needed

## Phase 5: App-Like Polish

Inside Windows:

- auto-hide taskbar
- launch KakaoTalk after logon
- optional full-screen or fixed-size KakaoTalk window
- optional script to minimize/kill Explorer after startup

macOS side:

- app icon
- window title
- Dock behavior
- clean shutdown

## Phase 6: RemoteApp Research

Research only after MVP works.

Questions:

- Can Windows 11 ARM64 client expose KakaoTalk through RemoteApp/RAIL without Windows Server?
- Can FreeRDP embedded engine set the needed RemoteApp settings?
- Does KakaoTalk behave correctly as a RemoteApp?

If not, keep full RDP surface and polish around it.
