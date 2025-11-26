# Masroufy

Masroufy is a modern expense tracker application built with Flutter. It helps users track daily spending, offering analytics and a personalized experience.

## Features

- **Expense Tracking**: Add, view, and manage daily expenses.
- **Local Persistence**: Data is saved locally on the device using `shared_preferences`, ensuring records are always available.
- **Dynamic Currency**: Support for multiple currencies. Changes to the preferred currency are reflected throughout the application.
- **Analytics**: Visual breakdown of spending habits with pie charts and category statistics.
- **Material 3 Design**: A user interface following the latest Material Design guidelines.
- **Onboarding Experience**: A setup flow for new users to personalize their profile and budget.
- **Time Filtering**: Filter expenses by Today, Week, Month, or All Time.
- **Swipe to Delete**: Gesture-based management of the transaction list.

## Tech Stack

- **Framework**: Flutter
- **State Management**: `setState`
- **Persistence**: `shared_preferences`
- **Charts**: `fl_chart`
- **Typography**: `google_fonts`
- **Icons**: `cupertino_icons`

## Project Structure

The project follows a modular architecture:

```
lib/
├── main.dart           # Entry point
├── data.dart           # Static data (currencies, etc.)
├── models.dart         # Data models (Expense, UserSettings)
├── widgets.dart        # Reusable UI components
├── screens.dart        # Barrel file for screens
├── services/
│   └── storage_service.dart # Local storage handling
└── screens/
    ├── home_screen.dart
    ├── add_transaction_screen.dart
    ├── settings_screen.dart
    └── splash_screen.dart
```

## Getting Started

1. **Clone the repository**:
   ```bash
   git clone https://github.com/don-frex/Monthly-Expensions-App.git
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the app**:
   ```bash
   flutter run
   ```

## Usage

- **First Run**: Complete the onboarding to set name, currency, and monthly budget.
- **Dashboard**: View recent transactions and a summary of spending vs. income.
- **Add Transaction**: Tap the add button to record a new expense.
- **Analytics**: Access the analytics view to see spending breakdown.
- **Settings**: Update profile, currency, or budget configurations.

---

Built with Flutter.
