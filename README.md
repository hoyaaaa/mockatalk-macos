# KakaoTalkWinApp

Goal: build a macOS app that feels like a second KakaoTalk instance, backed by Windows KakaoTalk running inside a hidden, dedicated Windows ARM64 VM using the oldest currently supported Windows version.

This is not a native Windows-app compatibility layer. The practical design is:

- macOS app shell: `KakaoTalk Windows.app`
- QEMU Windows 10 ARM64 VM in the background
- persistent qcow2 overlay dedicated to KakaoTalk
- embedded RDP view for display/input/clipboard
- Windows auto-logon and KakaoTalk auto-launch

## Current Context

Known local inputs:

- macSandbox source: `/Users/hoya/macSandbox`
- macSandbox upstream: `https://github.com/yourtablecloth/macSandbox.git`
- macSandbox PRs page: `https://github.com/yourtablecloth/macSandbox/pulls`
- Windows KakaoTalk installer: `/Users/hoya/Downloads/KakaoTalk-Windows/KakaoTalk_Setup_qwin64.exe`

Current KakaoTalk OS target:

- Microsoft Store lists KakaoTalk for Windows as requiring Windows 10 or later.
- Therefore the preferred guest OS target is Windows 10 ARM64, not Windows 11 ARM64.
- If Windows 10 ARM64 media, drivers, RDP, or KakaoTalk behavior blocks the MVP, document the blocker and fall back to Windows 11 ARM64 only as a compatibility fallback.

Current local reality:

- `/Applications/macSandbox for Windows.app` is not expected to exist; it was removed because it is not used directly.
- Use the local macSandbox source checkout and upstream repository as the reference implementation.
- Build or run from source when baseline generation or runtime behavior needs to be exercised.

Expected macSandbox runtime paths after building/running from source:

- virtio cache: `/Users/hoya/Library/Application Support/MacSandbox/drivers/virtio-win.iso`
- baseline: `/Users/hoya/Library/Application Support/MacSandbox/baseline`

At the time this project was created, the macSandbox baseline was not confirmed present. The next implementation pass should verify it or rebuild it from the source checkout.

## Non-Goals

- Do not build a general Windows sandbox.
- Do not preserve `.wsb` compatibility.
- Do not expose printer, microphone, webcam, arbitrary folder mapping, or disposable sandbox controls in the MVP.
- Do not pretend this is native Windows app execution. It is a VM-backed app wrapper.

## MVP

1. Reuse or create a Windows 10 ARM64 baseline.
2. Create one persistent overlay for KakaoTalk.
3. Boot the overlay with QEMU and RDP port forwarding.
4. Auto-logon to Windows.
5. Auto-run KakaoTalk.
6. Show the RDP session inside one macOS window titled `KakaoTalk Windows`.
7. Keep the overlay after quit so KakaoTalk install/login state persists.

## Recommended First Implementation

Start with a minimal Swift macOS app rather than modifying macSandbox directly.

Copy only the useful parts from macSandbox:

- `QEMURuntime`
- `DiskService`
- `SandboxPaths` ideas
- embedded `CFreeRDP` bridge if we want in-app RDP

For the very first prototype, using external `sdl-freerdp` is acceptable. Once VM lifecycle is stable, replace it with embedded RDP.

## Docs

- [Product Brief](docs/PRODUCT_BRIEF.md)
- [Architecture](docs/ARCHITECTURE.md)
- [macSandbox Analysis](docs/MACSANDBOX_ANALYSIS.md)
- [Implementation Plan](docs/IMPLEMENTATION_PLAN.md)
- [Runtime Paths](docs/RUNTIME_PATHS.md)
- [Open Questions](docs/OPEN_QUESTIONS.md)
- [Security and Licensing](docs/SECURITY_LICENSE.md)
- [Operations](docs/OPERATIONS.md)
