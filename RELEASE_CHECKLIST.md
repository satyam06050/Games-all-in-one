# Production Release Checklist

## ✅ Completed
- [x] Remove print statements
- [x] Fix deprecated withOpacity calls
- [x] Fix chess_screen.dart warning
- [x] Remove unused imports
- [x] Update app name to "Games All In One"
- [x] Update package name to com.appsly.games_all_in_one
- [x] Remove cleartext traffic security risk
- [x] Add ProGuard rules for obfuscation
- [x] Add storage permissions for screenshots
- [x] Update app description

## 🔴 Required Before Release

### 1. App Icons & Branding
```bash
# Generate app icons using flutter_launcher_icons
flutter pub add dev:flutter_launcher_icons
# Add icon configuration to pubspec.yaml
# Run: flutter pub run flutter_launcher_icons
```

### 2. Release Signing
```bash
# Generate keystore
keytool -genkey -v -keystore keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias games_all_in_one

# Store credentials securely (use environment variables or CI/CD secrets)
# Uncomment signingConfigs in android/app/build.gradle.kts
```

### 3. Privacy Policy & Terms
- Create privacy policy (required for Play Store)
- Add terms of service
- Update in Settings screen

### 4. Testing
- [ ] Test on multiple devices (Android 8+)
- [ ] Test all features offline
- [ ] Test screenshot functionality
- [ ] Test multiplayer games
- [ ] Test quiz system
- [ ] Test rewards system
- [ ] Verify no crashes

### 5. Play Store Assets
- [ ] App icon (512x512)
- [ ] Feature graphic (1024x500)
- [ ] Screenshots (phone & tablet)
- [ ] App description
- [ ] Privacy policy URL

### 6. Optional Enhancements
- [ ] Add Firebase Crashlytics for error tracking
- [ ] Add Firebase Analytics
- [ ] Add in-app updates
- [ ] Add rate app dialog
- [ ] Add share app functionality

## Build Commands

### Debug Build
```bash
flutter build apk --debug
```

### Release Build
```bash
flutter build appbundle --release
# or
flutter build apk --release --split-per-abi
```

### Test Release Build
```bash
flutter build apk --release
flutter install
```

## Version Management
Current: 1.0.0+1
- Update version in pubspec.yaml before each release
- Format: MAJOR.MINOR.PATCH+BUILD_NUMBER
