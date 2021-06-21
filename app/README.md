## Getting Started

- Copy/Rename `lib/.env.template.dart` to `/lib/.env.dart` and fill in the values
- `flutter pub get`
- Configure the application in the Firebase project (the package name/bundle id must match)
- Add the Firebase configuration file
  - `google-services.json` to `android/app` for [Android](https://firebase.flutter.dev/docs/installation/android/)
  - `GoogleService-Info.plist` to `ios/Runner` (using Xcode) for [iOS](https://firebase.flutter.dev/docs/installation/ios/#enabling-use-of-firebase-emulator-suite)
- `flutter run -t lib/local_main.dart` assuming you want to use the Firebase emulators. `flutter run` otherwise.
