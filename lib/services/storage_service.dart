import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models.dart';

class StorageService {
  static const String _expensesKey = 'expenses';
  static const String _settingsKey = 'settings';

  // Save Expenses
  static Future<void> saveExpenses(List<Expense> expenses) async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = jsonEncode(
      expenses.map((e) => e.toJson()).toList(),
    );
    await prefs.setString(_expensesKey, encodedData);
  }

  // Load Expenses
  static Future<List<Expense>?> loadExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final String? encodedData = prefs.getString(_expensesKey);

    if (encodedData == null) return null;

    try {
      final List<dynamic> decodedData = jsonDecode(encodedData);
      return decodedData.map((item) => Expense.fromJson(item)).toList();
    } catch (e) {
      return null;
    }
  }

  // Save Settings
  static Future<void> saveSettings(UserSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = jsonEncode(settings.toJson());
    await prefs.setString(_settingsKey, encodedData);
  }

  // Load Settings
  static Future<UserSettings?> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final String? encodedData = prefs.getString(_settingsKey);

    if (encodedData == null) return null;

    try {
      final Map<String, dynamic> decodedData = jsonDecode(encodedData);
      return UserSettings.fromJson(decodedData);
    } catch (e) {
      return null;
    }
  }

  // Clear All (for debugging or reset)
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
