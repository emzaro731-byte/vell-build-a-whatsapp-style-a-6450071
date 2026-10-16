# Vell Messenger — Flutter mobile app

A mobile-first Flutter messenger interface with chat list, search, unread badges, Updates, Communities, Calls, contact selection, and a local interactive chat composer.

## Build an Android APK

From the `mobile` directory with Flutter installed:

```sh
flutter pub get
flutter run
flutter build apk --release
```

APK output: `build/app/outputs/flutter-apk/app-release.apk`

## GitHub Actions

Push to `main` to build the Android APK. The workflow uploads the APK as an artifact under the Actions run.

**Note:** This version is a UI prototype. Messages are stored locally in app memory; real cross-device messaging requires a backend, authentication, and push notifications.
