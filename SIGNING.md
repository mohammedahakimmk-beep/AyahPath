# AyahPath — Signing & Release Info

## Package / Application ID
- **Application ID**: `com.ayahpath.ayahpath`
- **App name**: AyahPath

## Release APK
- Location: `build/app/outputs/flutter-apk/app-release.apk`
- Size: ~57 MB (armeabi-v7a, arm64-v8a, x86_64 included)
- Version: `1.0.0` (versionCode `1`)
- Download: https://github.com/mohammedahakimmk-beep/AyahPath/releases/download/v1.0.0/app-release.apk

## Signing Keystore
- File: `android/app/ayahpath-upload.jks` (NOT committed to git — keep it safe!)
- Alias: `ayahpath`
- Key: RSA 4096, SHA384withRSA, valid 10,000 days
- Credentials stored in `android/key.properties` (also NOT committed)

> ⚠️ This is the upload/signing keystore. **Back it up** — losing it means you can never
> publish updates to an app already in users' hands.

## SHA Fingerprints (signing certificate)

Use these to register your app in **Google Play Console** (App signing) or
**Firebase App Distribution** for testing via Firebase.

| Field | Value |
|-------|-------|
| SHA-1 | `3F:67:91:87:7D:86:7C:80:85:14:16:B0:4D:81:1E:9B:F1:22:99:8D` |
| SHA-256 | `1A:58:22:90:0D:A4:9B:B8:75:98:CF:6F:D1:D9:D9:75:0D:B9:CC:63:A8:44:0E:63:41:B6:EC:0B:44:71:C9:3B` |

To re-print them later:
```bash
keytool -list -v -keystore android/app/ayahpath-upload.jks -alias ayahpath
```

## Firebase
- **Project ID**: `ayahpath`
- **Hosting**: https://ayahpath.web.app
- **Update config**: https://ayahpath.web.app/version.json

## Building a new release
```bash
flutter pub get
flutter analyze
flutter test
flutter build apk --release
# Re-upload the generated APK to a GitHub Release and bump version.json
```
