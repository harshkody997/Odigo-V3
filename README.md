# odigov3

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

[✓] Flutter (Channel stable, 3.32.0, on macOS 15.3.2 24D81 darwin-arm64, locale en-US) [267ms]
• Flutter version 3.32.0 on channel stable at
/Users/amaandhanerawala/Documents/workspace/flutter3.32.0
• Upstream repository https://github.com/flutter/flutter.git
• Framework revision be698c48a6 (10 days ago), 2025-05-19 12:59:14 -0700
• Engine revision 1881800949
• Dart version 3.8.0
• DevTools version 2.45.1

[✓] Android toolchain - develop for Android devices (Android SDK version 35.0.0) [992ms]
• Android SDK at /Users/amaandhanerawala/Library/Android/sdk
• Platform android-36, build-tools 35.0.0
• ANDROID_HOME = /Users/amaandhanerawala/Library/Android/sdk
• Java binary at:
/Users/amaandhanerawala/Library/Java/JavaVirtualMachines/corretto-17.0.15-1/Contents/Home/bin/java
This JDK is specified in your Flutter configuration.
To change the current JDK, run: `flutter config --jdk-dir="path/to/jdk"`.
• Java version OpenJDK Runtime Environment Corretto-17.0.15.6.1 (build 17.0.15+6-LTS)
• All Android licenses accepted.

[✓] Xcode - develop for iOS and macOS (Xcode 16.2) [546ms]
• Xcode at /Applications/Xcode.app/Contents/Developer
• Build 16C5032a
• CocoaPods version 1.16.2

[✓] Chrome - develop for the web [22ms]
• Chrome at /Applications/Google Chrome.app/Contents/MacOS/Google Chrome

[✓] Android Studio (version 2025.1.1) [21ms]
• Android Studio at /Applications/Android Studio Preview.app/Contents
• Flutter plugin can be installed from:
🔨 https://plugins.jetbrains.com/plugin/9212-flutter
• Dart plugin can be installed from:
🔨 https://plugins.jetbrains.com/plugin/6351-dart
• Java version OpenJDK Runtime Environment (build 21.0.6+-13391695-b895.109)

[✓] IntelliJ IDEA Community Edition (version 2024.3.1.1) [20ms]
• IntelliJ at /Applications/IntelliJ IDEA CE.app
• Flutter plugin can be installed from:
🔨 https://plugins.jetbrains.com/plugin/9212-flutter
• Dart plugin can be installed from:
🔨 https://plugins.jetbrains.com/plugin/6351-dart

[✓] VS Code (version 1.100.2) [7ms]
• VS Code at /Applications/Visual Studio Code.app/Contents
• Flutter extension can be installed from:
🔨 https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter

[✓] Connected device (3 available) [5.8s]
• C:Malvare/Cipher/Virus.exe (wireless) (mobile) • 00008130-00126C200241001C • ios • iOS 18.4.1
22E252
• macOS (desktop)                                • macos • darwin-arm64 • macOS 15.3.2 24D81
darwin-arm64
• Chrome (web)                                   • chrome • web-javascript • Google Chrome
136.0.7103.114
The device must be opted into Developer Mode to connect wirelessly. (code -27)

[✓] Network resources [964ms]
• All expected network resources are available.

• No issues found!

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
flutter clean && flutter pub get && dart run build_runner build --delete-conflicting-outputs &&
dart run easy_localization:generate --source-dir assets/lang/ -f keys -O lib/ui/utils/theme --output-file app_strings.g.dart &&
dart pub global activate flutter_gen && fluttergen
--------------------------------------------------------------------------------------------
flutter clean && flutter pub get && dart run build_runner build --delete-conflicting-outputs
flutter pub run build_runner watch --delete-conflicting-outputs
For windows: 
flutter clean; flutter pub get; dart run build_runner build --delete-conflicting-outputs;
dart run easy_localization:generate --source-dir assets/lang/ -f keys -O lib/ui/utils/theme --output-file app_strings.g.dart;
dart pub global activate flutter_gen; fluttergen


-----------------------------------------------------------------------------------------------------------------------
Common Widget Entries
-----------------------------------------------
Common Switch  -  CommonCupertinoSwitch
Common Table header widget - CommonTableHeaderWidget
Common Table Value widget - CommonTableValueWidget
Common Back with title widget - CommonBackTitleWidget
Common Button widget - CommonButton
Common Confirmation overlay widget - CommonConfirmationOverlayWidget
Common Form field widget - CommonInputFormField
Common Search form field widget - CommonSearchFormField
Common Searchable dropdown widget - CommonSearchableDropdown
Common Svg widget - CommonSVG
Common Text widget - CommonText
Common Outline container widget - CommonOutlineBox
Common Checkbox widget - CommonCheckBox
Common Appbar Widget - CommonAppbar
Common Success Dialog Widget - showSuccessDialogue
Common success toast widget - showToast
Common radio button - CommonRadioButton
