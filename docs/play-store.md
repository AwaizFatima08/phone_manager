# Play Console — Phone Manager

Package `com.homilabs.phonemanager` (cannot change after the first upload). Organization account Homilabs
(9161588402757830740), Play app id 4974014361060128944. In the desktop app's built-in browser the account is
`/u/0/` (homilabs.smc@gmail.com); that browser has no file-upload tool, so bundles and images are dragged in by Homi.

## Release files
- Bundle: `releases/v<version>-<build>/phonemanager-<version>-<build>.aab` (signed with the upload key below; gitignored).
- Symbols: `releases/v<version>-<build>/phonemanager-<version>-<build>-symbols.zip` (keep for `flutter symbolize`).
- Store icon `store/play-icon-512.png`; feature graphic `store/feature-graphic.png` (from
  `assets/branding/feature_graphic.svg`); phone screenshots `store/screenshots/` (1080×1920, 9:16, taken on the
  Oppo CPH2743 from a profile build, status bar and test ad cropped out).
- QUERY_ALL_PACKAGES review video `store/review-query-all-packages.mp4`, hosted at
  https://tools.homilabs.org/phonemanager/review.mp4 (uploaded by scp, not in the homilabs_tools repo; keep it online
  while Play may re-review the declaration). The Oppo blocks `screenrecord`, so it is built from a screencap
  sequence with ffmpeg.

## Status
- 15 Nov 2026: Play app "Phone Manager: Storage & Apps" created. Done: privacy policy, ads (yes), sign-in details
  (no restrictions), advertising ID (advertising), government (no), financial (none), health (none), target audience
  18+, content rating (Everyone / PEGI 3 / 3+), data safety, store listing text, store settings (Tools,
  homilabs.smc@gmail.com, https://tools.homilabs.org).
- Not done yet: store graphics upload, production release (bundle upload, countries), QUERY_ALL_PACKAGES
  declaration (appears after the bundle is uploaded), send for review.

## Signing
- Upload key `.secrets/phonemanager-upload.keystore`, alias `phonemanager-upload` (gitignored; password in
  `.secrets/phonemanager-upload-keystore-credentials.txt`). Keep Play App Signing on (default).
- Upload certificate SHA-256:
  `F0:A3:40:25:24:F1:98:AF:AF:C1:04:06:33:9F:05:F2:D0:60:53:55:22:48:43:DF:C5:79:95:E6:87:DE:98:37`

## Listing
- App name: Phone Manager: Storage & Apps (no "cleaner"/"booster" claims: Play reviews those closely)
- Short description: Check storage, battery, memory, cache and app permissions in one simple place.
- Full description: as entered in Play Console on 15 Nov 2026 (storage, battery, apps, memory, cache cleaner, app
  permissions bullets; "honest about what Android allows"; Usage access stays on the phone).
- Privacy policy: https://tools.homilabs.org/privacy#phonemanager

## App content (declarations)
- **Ads**: yes (AdMob banner and interstitial). **Advertising ID**: yes, advertising or marketing.
- **QUERY_ALL_PACKAGES**: core purpose is device/app management — listing installed apps with size, cache and
  permissions, and uninstalling them. Link the review video above.
- **Usage access (PACKAGE_USAGE_STATS)** and **KILL_BACKGROUND_PROCESSES**: no Play form.
- **Target audience**: 18+. **Content rating**: IARC "All other app types", every answer "No".
- **Data safety** (the app itself collects nothing; answers cover the AdMob SDK): collected and shared, required,
  not ephemeral — approximate location, app interactions, crash logs, diagnostics, device or other IDs; purposes
  analytics, advertising or marketing, fraud prevention. Encrypted in transit: yes. No accounts. Deletion requests:
  no. Installed apps, sizes and permissions are processed on the device only and are not collected.

## After the listing is live
- AdMob → Apps → Phone Manager → "Add store" to link the Play listing (app is "Requires review" until then).
