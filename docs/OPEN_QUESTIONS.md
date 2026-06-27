# Open Questions

## Product

- Is full RDP surface acceptable if Windows chrome is minimized/hidden?
- Is VM boot time acceptable?
- Should the app auto-shutdown when KakaoTalk exits?
- Should the app support multiple KakaoTalk profiles later, or exactly one?

## Technical

- Is the macSandbox baseline complete and ready?
- Can we obtain usable Windows 10 ARM64 installation media for baseline generation?
- Does the macSandbox Windows 11 baseline builder work against Windows 10 ARM64, or does it need adaptation?
- Does `KakaoTalk_Setup_qwin64.exe` install and run correctly on Windows 10 ARM64?
- Does KakaoTalk preserve login state in the persistent overlay across reboots?
- Can KakaoTalk run without Explorer?
- Does KakaoTalk need notifications, tray, or startup services that break if Explorer is killed?
- Is embedded FreeRDP necessary for MVP, or is external `sdl-freerdp` enough for first validation?

## RemoteApp

- Can normal Windows 10/11 client support RemoteApp/RAIL for this target?
- Does FreeRDP 3 expose all required settings for RemoteApp in embedded mode?
- Does KakaoTalk behave correctly when launched as a RemoteApp?

## Licensing

- Are we comfortable copying AGPL code from macSandbox?
- Should this stay as a private local tool?
