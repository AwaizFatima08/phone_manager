# Phone Manager (HomiLabs) — project notes

Flutter Android app with six tools on one home dashboard: Storage, Battery, Apps, Memory, Cache cleaner and
App permissions. App id `com.homilabs.phonemanager` (locked after the first Play upload). Launcher name
"Phone Manager". minSdk 26. Started 15 Nov 2026 from App Manager's code (the Apps tool is App Manager's list,
detail, uninstall and per-app permissions, unchanged).

## Locations
- Code: `/mnt/storage/projects/Tools/phone_manager` · GitHub `AwaizFatima08/phone_manager` (PUBLIC repo: no secrets)
- Local backup: `/mnt/storage/project_backups/tools/phone_manager_backup`
- Backups: `bash scripts/backup.sh` (local copy + GitHub push; Drive layer off until `GDRIVE_FOLDER_ID` is set)
- Site: section on https://tools.homilabs.org (hub card `#phonemanager`), privacy
  https://tools.homilabs.org/privacy#phonemanager (use in Play Console), terms https://tools.homilabs.org/terms#phonemanager.
  Source in `/mnt/storage/projects/homilabs_tools` (see its README). Update the privacy section before any release
  that changes what the app reads or adds SDKs.

## What Android allows (the design follows this — "honest guided", Homi's choice 15 Nov 2026)
- Apps: list (`QUERY_ALL_PACKAGES`), sizes via `StorageStatsManager` (needs **Usage access**,
  `PACKAGE_USAGE_STATS`), uninstall via Android's dialog (`REQUEST_DELETE_PACKAGES`).
- Storage: total/free always; images/videos/audio/other breakdown and app totals need Usage access. "Free up
  space" opens Android's own clean-up (`StorageManager.ACTION_MANAGE_STORAGE`).
- Battery: sticky `ACTION_BATTERY_CHANGED` + `BatteryManager`, polled every 5 s while watched; buttons open battery
  saver, battery usage and battery optimisation pages. No per-app battery figures exist for normal apps; screen time
  (UsageStatsManager, last 24 h) stands in.
- Memory: `ActivityManager.MemoryInfo`, polled every 3 s. "Stop background apps" calls `killBackgroundProcesses`
  (`KILL_BACKGROUND_PROCESSES`) for non-system apps and reports the measured change — only on Android 13 and older;
  from Android 14 the system ignores it for other apps, so the button is replaced by an explanation. Never claim
  "boost" figures that were not measured.
- Cache cleaner: clears **its own** cache directly; every other app's cache is listed largest first and opens that
  app's App info with steps (only Android may clear it). No Shizuku/root.
- App permissions: runtime (dangerous) permissions held by each non-system app, grouped like Android's Permission
  manager; tap a group → apps → App Manager-style detail with the guided "Change permissions".
- Native: `android/app/src/main/kotlin/com/homilabs/phonemanager/PhoneManagerChannel.kt` (channel
  `com.homilabs.phonemanager/apps`) and `DeviceChannel.kt` (channel `com.homilabs.phonemanager/device`).
  Dart sides: `lib/features/apps/data/app_platform_service.dart`, `lib/features/device/data/device_platform_service.dart`.
- Play: `QUERY_ALL_PACKAGES` needs the "device management / app manager" declaration in Play Console.

## Ads
AdMob account homilabs.smc@gmail.com (publisher pub-2087846699268567). App `~2106024126` and units
`phonemanager_banner` and `phonemanager_break_interstitial` created 15 Nov 2026 (ids in `config/admob.json`; the app
"requires review" until the Play listing is linked in AdMob). Debug builds use Google's sample units;
`bash scripts/check-release-ad-ids.sh` must pass before a release build.
Banner at the bottom of the home dashboard and the app list; interstitial after a clean-up report (stop background
apps, clear own cache, batch uninstall), 5 minutes apart; never on a detail screen. UMP consent before the SDK starts.

## Release
- Upload key `.secrets/phonemanager-upload.keystore` (created 15 Nov 2026; gitignored; password in
  `.secrets/phonemanager-upload-keystore-credentials.txt`; `android/key.properties` points at it). Release builds are
  unsigned without it, never debug-signed. Losing it means a Play upload-key reset: it is in the local backup.
- Build: `jobq run --name phonemanager-release-aab -- bash -c 'flutter build appbundle --release --obfuscate
  --split-debug-info=build/symbols && cd android && ./gradlew --stop'`, then copy the bundle and zipped symbols to
  `releases/v<version>-<build>/` (gitignored). Bump `version:` in pubspec before every new upload.
- Icon source `assets/branding/` (SVG; launcher PNGs rendered with Inkscape); Play icon `store/play-icon-512.png`.
- Play Console notes (ids, listing, declarations, Data safety, status): `docs/play-store.md`.
- 1.0.0 (build 1) sent for Play review 15 Nov 2026. After approval: AdMob → Phone Manager → "Add store" to link the listing.

## Gate before commit
```
dart format --set-exit-if-changed lib test
flutter analyze
flutter test
```
Heavy jobs follow `~/.claude/heavy-jobs.md`: use `jobq`, then `./gradlew --stop`.
