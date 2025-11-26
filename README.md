# Masroufy

A single-file Flutter Masroufy application with Material 3 design.

## Features

- ✅ Single file implementation (lib/main.dart)
- ✅ No external dependencies (intl, provider, google_fonts)
- ✅ Material 3 design
- ✅ Time-based filtering (Today/Week/Month)
- ✅ Add expenses via modal bottom sheet
- ✅ Swipe-to-delete functionality
- ✅ Category-based organization (Food, Transport, Work, Entertainment)
- ✅ Dynamic total calculation

## Running the App

Since Flutter CLI is not available in this environment, you can:

1. Copy the contents of `lib/main.dart` to your Flutter project
2. Ensure your `pubspec.yaml` matches the provided configuration
3. Run the app:
   ```bash
   flutter run
   ```

## Usage

- **View Expenses**: Filter by Today, Week, or Month using the segmented button
- **Add Expense**: Tap the floating action button and fill in the form
- **Delete Expense**: Swipe left on any expense item
- **Total**: Updates automatically based on the selected time filter
