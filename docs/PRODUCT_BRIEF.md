# Product Brief

## Objective

Make a macOS app that lets the user run one additional KakaoTalk instance using Windows KakaoTalk, with the simplest possible UX:

- click Dock app
- see KakaoTalk
- quit app
- next launch keeps login state

Use Windows 11 ARM64 as the primary MVP guest because it has better official media availability and macSandbox support. Windows 10 ARM64 remains an experimental low-spec target because KakaoTalk lists Windows 10 or later, but Windows 10 ARM64 media/support risk is higher.

## User Experience Target

The user should not need to think about Windows Sandbox, QEMU, overlays, `.wsb`, virtio drivers, or RDP.

Acceptable reality:

- first setup takes a while
- startup takes VM boot time
- resource usage is VM-level
- the app is technically Windows running through RDP

Unacceptable:

- reinstalling KakaoTalk every launch
- losing KakaoTalk login state
- showing a general Windows sandbox UI as the main product
- exposing a broad VM manager interface

## UX Modes

### MVP: Full RDP Surface

Show one RDP view. Auto-launch KakaoTalk. Hide as much Windows chrome as practical.

This is easiest and most reliable.

### Later: App-Like Surface

Attempt to make the RDP surface feel more like a single app:

- fixed window size or dynamic resize
- Windows taskbar auto-hidden
- optional script to kill Explorer after KakaoTalk starts
- custom app icon/title

### Stretch: RemoteApp/RAIL

Use RDP RemoteApp/RAIL to display only the KakaoTalk window.

This is not supported by current macSandbox code and may not work reliably on normal Windows 10/11 client editions.
