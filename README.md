# Font Zombie

A typography identification game built with Flutter that challenges you to recognize historical typefaces.

## About

Font Zombie is a game that tests your typography knowledge. A letter is displayed in a random historical typeface, and your challenge is to identify which font it is. The game features a collection of the most influential typefaces in design history, along with information about their designers and year of creation.

## Features

- Test your ability to identify typefaces from a single letter
- Learn about historical typefaces and their designers
- Interactive wheel UI for selecting letters and fonts
- Track your score as you play

## Getting Started

### Prerequisites

- Flutter SDK (latest version recommended)
- Dart SDK
- Web browser (Chrome recommended for development)
- For Android builds: Android SDK and Android Studio
- For iOS builds: Xcode and CocoaPods (Mac only)

### Installation

1. Clone this repository:

```bash
git clone https://github.com/somahargitai/font-zombie.git
```

2. Navigate to the project directory:

```bash
cd font-zombie
```

3. Install dependencies:

```bash
flutter pub get
```

4. Run the app:

```bash
flutter run -d chrome
```

### Building for Mobile Devices

<details>
<summary>Building for Android</summary>

1. Make sure your Android development environment is set up:

#### Android

1. Make sure your Android development environment is set up:

```bash
flutter doctor
```

2. Connect your Android device or start an emulator

3. Build a debug APK and install it on the connected device:

```bash
flutter run
```

4. Build a release APK for distribution:

```bash
flutter build apk --release
```

The APK will be available at `build/app/outputs/flutter-apk/app-release.apk`

5. Install the release APK on a device:

```bash
adb install build/app/outputs/flutter-apk/app-release.apk
```

6. Alternatively, build an Android App Bundle for Google Play Store:

```bash
flutter build appbundle --release
```

</details>

<details>
<summary> iOS (Mac only) </summary>

1. Make sure your iOS development environment is set up:

```bash
flutter doctor
```

2. Install CocoaPods if not already installed:

```bash
sudo gem install cocoapods
```

3. Build for iOS in debug mode and run on a connected device or simulator:

```bash
flutter run -d ios
```

4. Build a release version for distribution:

```bash
flutter build ios --release
```

5. For App Store distribution, open the Xcode workspace:

```bash
open ios/Runner.xcworkspace
```

6. In Xcode:
   - Select the appropriate development team
   - Choose a connected device or simulator
   - Product → Archive
   - Follow the steps to validate and distribute your app

## How to Play

1. Start the game from the home screen
2. A letter will be displayed in a mystery font
3. Use the letter wheel to see the letter in different positions
4. Use the font wheel to select which historical typeface you think is being displayed
5. Submit your answer and see if you were correct
6. Learn interesting details about each font

## Built With

- Flutter - The UI framework
- Google Fonts - Font library
- Dart - Programming language

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Google Fonts for providing the typefaces
- The typographers who created these historic fonts
