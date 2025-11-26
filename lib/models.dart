import 'data.dart';

// Data Models
enum ExpenseCategory {
  food,
  transport,
  work,
  entertainment,
  housing,
  utilities,
  healthcare,
  education,
  shopping,
  travel,
  gifts,
  other
}

enum TimeFilter { today, week, month, all }

enum Gender { male, female }

class Expense {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final ExpenseCategory category;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  });
}

class UserSettings {
  String userName;
  String currencyCode;
  double? monthlySalary;
  Gender gender;
  bool isFirstTime;

  UserSettings({
    this.userName = 'This is me',
    this.currencyCode = 'USD',
    this.monthlySalary,
    this.gender = Gender.male,
    this.isFirstTime = true,
  });

  String get currencySymbol {
    final currency = currencyList.firstWhere(
      (c) => c['code'] == currencyCode,
      orElse: () => {'symbol': '\$'},
    );
    return currency['symbol']!;
  }

  String formatCurrency(double amount) {
    return '$currencySymbol${amount.toStringAsFixed(2)}';
  }

  String getAvatarAsset() {
    return gender == Gender.male
        ? 'assets/avatars/male.svg'
        : 'assets/avatars/female.svg';
  }
}
