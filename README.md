# KakaoTalkWinApp

Goal: keep a second KakaoTalk instance on the same Mac without a full VM, Wine,
or paid software.

The final local path is a native macOS app clone. The script copies the official
`/Applications/KakaoTalk.app`, gives the copy a distinct bundle identity and
executable name, rewrites Kakao URL schemes, then ad-hoc signs the result.

## Use

Prerequisite: install the official macOS KakaoTalk app at
`/Applications/KakaoTalk.app`.

Create or refresh the clone:

```bash
cd /Users/hoya/KakaoTalkWinApp
scripts/create-kakaotalk-macos-clone.sh
```

Open it:

```bash
open -n "카카오톡Sub.app"
```

Default clone identity:

- app path: `./카카오톡Sub.app`
- bundle id: `com.hoyaaaa.KakaoTalkSub`
- display name: `카카오톡Sub`
- executable: `KakaoTalkSub`

Running the script replaces the cloned app bundle at
`./카카오톡Sub.app`. It does not remove the clone's existing
per-bundle data under `~/Library/Application Support`,
`~/Library/WebKit`, `~/Library/Caches`, or related user-library folders.

## Current Result

The original KakaoTalk and the clone can run at the same time. Observed local
storage is separated:

- original: `~/Library/Containers/com.kakao.KakaoTalkMac`
- clone: `~/Library/Application Support/com.hoyaaaa.KakaoTalkSub`
- clone WebKit/cache/preferences: `~/Library/WebKit`,
  `~/Library/Caches`, `~/Library/Preferences`,
  `~/Library/HTTPStorages` under `com.hoyaaaa.KakaoTalkSub`

No obvious Kakao Keychain item was present during inspection. Practical success
criterion is that the original app and the clone keep separate logins after
restarting both apps.

## Limits

- This does not hide hardware identifiers, Mac model, OS version, IP address, or
  Kakao server-side account/session facts.
- This is not as isolated as a different OS user or VM.
- Updating the official KakaoTalk app requires recreating the clone.
- The clone is ad-hoc signed after modifying `Info.plist`.

## Abandoned Paths

These were tested and removed from the active project:

- Windows 11 ARM64 VM via macSandbox: Windows booted and KakaoTalk installed,
  but latest Windows KakaoTalk crashed before showing UI.
- Windows 10 ARM64 media: no clean official path for this use case.
- Wine/Whisky: already tried and failed.
- CrossOver: paid, outside the target.
- macOS separate user plus Screen Sharing: blocked by local control limitations.

## Docs

- [macOS App Clone Experiment](docs/MACOS_APP_CLONE_EXPERIMENT.md)
- [Decisions](docs/DECISIONS.md)
