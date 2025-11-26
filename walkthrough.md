# Walkthrough - Persistence, Welcome Page, Dynamic Currency, and Renaming

I have implemented local persistence, welcome page logic, ensured that currency updates are reflected throughout the app, and renamed the application to **Masroufy**.

## Changes

### 1. Renamed App to Masroufy
- Updated `pubspec.yaml` description.
- Updated `AndroidManifest.xml` label.
- Updated `main.dart` title.
- Updated `splash_screen.dart` text.
- Updated `README.md`.

### 2. Persistence & Welcome Page
- Added `shared_preferences` dependency.
- Created `StorageService` to handle saving/loading expenses and settings.
- Updated `main.dart` to load data on startup.
- Implemented logic to show **Onboarding Screen** if no expenses are found (first run or data cleared).

### 3. Dynamic Currency Updates
- Updated `SummaryCard` in `lib/widgets.dart` to accept `currencySymbol` and use it instead of hardcoded `$`.
- Updated `AnalyticsScreen` in `lib/screens.dart` to accept `settings` and use `settings.formatCurrency()` for category breakdown.
- Updated `ExpenseTrackerHome` in `lib/screens/home_screen.dart` to pass the correct currency symbol and settings to these widgets.

## Verification

### Manual Verification Steps
1. **App Name**:
   - Verify the app name is **Masroufy** in the launcher, recent apps, and Splash Screen.

2. **Currency Update**:
   - Go to **Settings**.
   - Change **Currency** (e.g., to Euro or GBP).
   - Save.
   - Verify that:
     - **Summary Card** on Home Screen shows the new symbol.
     - **Transaction List** items show the new symbol.
     - **Analytics Screen** shows the new symbol in the breakdown list.

3. **Persistence**:
   - Add expenses, change settings.
   - Restart the app.
   - Verify all data and settings (including currency) are preserved.

4. **Welcome Page**:
   - Clear app data or uninstall/reinstall.
   - Verify Welcome Page appears.
