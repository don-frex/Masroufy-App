# Implementation Plan - Rename App to Masroufy

Rename the application from "Expense Tracker" to "Masroufy" across the codebase.

## Proposed Changes

### Configuration
#### [MODIFY] [pubspec.yaml](file:///home/adnane/Desktop/expenses_monthly/pubspec.yaml)
- Update description to mention "Masroufy".

#### [MODIFY] [AndroidManifest.xml](file:///home/adnane/Desktop/expenses_monthly/android/app/src/main/AndroidManifest.xml)
- Update `android:label` to "Masroufy".

### Code
#### [MODIFY] [main.dart](file:///home/adnane/Desktop/expenses_monthly/lib/main.dart)
- Update `MaterialApp` title to "Masroufy".

#### [MODIFY] [splash_screen.dart](file:///home/adnane/Desktop/expenses_monthly/lib/screens/splash_screen.dart)
- Update Splash Screen title text to "Masroufy".

### Documentation
#### [MODIFY] [README.md](file:///home/adnane/Desktop/expenses_monthly/README.md)
- Update title and description.

## Verification Plan

### Manual Verification
1. **App Label**: Run the app on Android emulator and check the app name in the launcher (if possible) or the task switcher.
2. **Splash Screen**: Launch the app and verify the text says "Masroufy".
3. **Recent Apps**: Check the app name in the recent apps list (controlled by `MaterialApp` title).
