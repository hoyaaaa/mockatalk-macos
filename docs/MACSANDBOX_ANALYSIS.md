# macSandbox Analysis

Source inspected: `/Users/hoya/macSandbox`

Upstream: `https://github.com/yourtablecloth/macSandbox.git`

PR page: `https://github.com/yourtablecloth/macSandbox/pulls`

Local note: the installed `/Applications/macSandbox for Windows.app` is not expected to exist. This project should use the source checkout and upstream repository as reference material.

## What macSandbox Actually Is

macSandbox is a QEMU-backed Windows 11 ARM64 VM runner with an embedded RDP display.

For this project, macSandbox should be treated as implementation reference code and as a strong signal for the primary OS target. Use Windows 11 ARM64 for the MVP because macSandbox is built around that baseline. Keep Windows 10 ARM64 as a later low-spec experiment only.

It is not a Windows app compatibility layer and it does not run Windows apps directly on macOS.

Important files:

- `/Users/hoya/macSandbox/src/MacSandbox/Core/SandboxRunner.swift`
- `/Users/hoya/macSandbox/src/MacSandbox/Core/QEMURuntime.swift`
- `/Users/hoya/macSandbox/src/MacSandbox/Core/SandboxConfig.swift`
- `/Users/hoya/macSandbox/src/MacSandbox/Core/WSBConfig.swift`
- `/Users/hoya/macSandbox/src/CFreeRDP/rdp_engine.c`

## Behavior Relevant To KakaoTalk

`SandboxRunner.start()` creates a fresh COW overlay each run:

- creates `overlays/<uuid>.qcow2`
- copies fresh EFI vars
- creates optional config disk
- boots QEMU
- removes overlay/vars/config disk on exit when `config.disposable` is true

`SandboxConfig.disposable` exists in code and defaults to true, but `.wsb` parsing does not expose it.

`WSBConfig` parses:

- `VGpu`
- `Networking`
- `AudioInput`
- `VideoInput`
- `ClipboardRedirection`
- `PrinterRedirection`
- `MemoryInMB`
- `CpuCores`
- `LogonCommand`
- `MappedFolders`

It does not parse persistent overlay paths or disposable mode.

## RDP Mode

The embedded FreeRDP engine configures a full desktop session:

- server host/port
- username/password
- TLS
- desktop width/height
- graphics pipeline
- clipboard
- display control
- printer
- mapped drives
- audio/mic

No RemoteApp/RAIL support was found.

This means macSandbox cannot currently show only the KakaoTalk window as a native-looking macOS window. It shows a full RDP desktop surface.

## Reusable Parts

Good candidates to reuse:

- QEMU argument construction from `QEMURuntime`
- overlay creation from `DiskService`
- path layout ideas from `SandboxPaths`
- RDP port reservation from `RDPSession`
- embedded RDP bridge from `CFreeRDP` and `RDPHostView`

Parts to avoid:

- `.wsb` parser
- disposable overlay cleanup
- generic sandbox options UI
- license checklist UI
- baseline builder UI unless needed
