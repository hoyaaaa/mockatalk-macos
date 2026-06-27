# Source Findings

## macSandbox Files Read

- `/Users/hoya/macSandbox/README.md`
- `/Users/hoya/macSandbox/WSB-SUPPORT.md`
- `/Users/hoya/macSandbox/src/MacSandbox/Core/GuestDrivers.swift`
- `/Users/hoya/macSandbox/src/MacSandbox/Core/BaselineBuilder.swift`
- `/Users/hoya/macSandbox/src/MacSandbox/Core/SandboxRunner.swift`
- `/Users/hoya/macSandbox/src/MacSandbox/Core/QEMURuntime.swift`
- `/Users/hoya/macSandbox/src/MacSandbox/Core/RDPSession.swift`
- `/Users/hoya/macSandbox/src/MacSandbox/Core/SandboxConfig.swift`
- `/Users/hoya/macSandbox/src/MacSandbox/Core/WSBConfig.swift`
- `/Users/hoya/macSandbox/src/MacSandbox/Core/SandboxPaths.swift`
- `/Users/hoya/macSandbox/src/MacSandbox/Core/DiskService.swift`
- `/Users/hoya/macSandbox/src/MacSandbox/Views/RDPHostView.swift`
- `/Users/hoya/macSandbox/src/CFreeRDP/rdp_engine.c`

## Key Findings

- macSandbox is QEMU + RDP.
- It creates disposable overlays by default.
- It has a `disposable` field in `SandboxConfig`, but `.wsb` does not expose it.
- It cleans stale overlays on each run.
- It deletes the overlay after run when disposable.
- Embedded RDP is full desktop, not RemoteApp.
- `LogonCommand` is useful for auto-launch, but not enough for persistence.

