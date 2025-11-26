import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fl_chart/fl_chart.dart';
import 'models.dart';
import 'widgets.dart';
import 'data.dart';

export 'screens/splash_screen.dart';
export 'screens/settings_screen.dart';
export 'screens/home_screen.dart';
export 'screens/add_transaction_screen.dart';

// Analytics Screen
class AnalyticsScreen extends StatelessWidget {
  final List<Expense> expenses;
  final double totalSpent;
  final UserSettings settings;

  const AnalyticsScreen({
    super.key,
    required this.expenses,
    required this.totalSpent,
    required this.settings,
  });

  Map<ExpenseCategory, double> _calculateCategorySpending() {
    final Map<ExpenseCategory, double> spending = {};
    for (var expense in expenses) {
      spending[expense.category] =
          (spending[expense.category] ?? 0) + expense.amount;
    }
    return spending;
  }

  @override
  Widget build(BuildContext context) {
    final categorySpending = _calculateCategorySpending();
    final sortedCategories = categorySpending.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Analytics',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.arrow_left, color: Color(0xFF2D3436)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: expenses.isEmpty
          ? Center(
              child: Text(
                'No data available',
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Pie Chart Section
                  Container(
                    height: 300,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                        sections: sortedCategories.map((entry) {
                          final percentage = (entry.value / totalSpent) * 100;
                          return PieChartSectionData(
                            color: _getCategoryColor(entry.key),
                            value: entry.value,
                            title: '${percentage.toStringAsFixed(0)}%',
                            radius: 80,
                            titleStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Category Breakdown
                  ...sortedCategories.map((entry) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color:
                                  _getCategoryColor(entry.key).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              _getCategoryIcon(entry.key),
                              color: _getCategoryColor(entry.key),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              entry.key.name[0].toUpperCase() +
                                  entry.key.name.substring(1),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2D3436),
                              ),
                            ),
                          ),
                          Text(
                            settings.formatCurrency(entry.value),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D3436),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
    );
  }

  Color _getCategoryColor(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.food:
        return const Color(0xFFFFCC80);
      case ExpenseCategory.transport:
        return const Color(0xFF90CAF9);
      case ExpenseCategory.work:
        return const Color(0xFFCE93D8);
      case ExpenseCategory.entertainment:
        return const Color(0xFFF48FB1);
      case ExpenseCategory.housing:
        return const Color(0xFFB4E50D);
      case ExpenseCategory.utilities:
        return const Color(0xFFFFF59D);
      case ExpenseCategory.healthcare:
        return const Color(0xFFEF9A9A);
      case ExpenseCategory.education:
        return const Color(0xFFB39DDB);
      case ExpenseCategory.shopping:
        return const Color(0xFF80CBC4);
      case ExpenseCategory.travel:
        return const Color(0xFF81D4FA);
      case ExpenseCategory.gifts:
        return const Color(0xFFFFAB91);
      case ExpenseCategory.other:
        return const Color(0xFFB0BEC5);
    }
  }

  IconData _getCategoryIcon(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.food:
        return CupertinoIcons.cart_fill;
      case ExpenseCategory.transport:
        return CupertinoIcons.car_detailed;
      case ExpenseCategory.work:
        return CupertinoIcons.briefcase_fill;
      case ExpenseCategory.entertainment:
        return CupertinoIcons.film_fill;
      case ExpenseCategory.housing:
        return CupertinoIcons.house_fill;
      case ExpenseCategory.utilities:
        return CupertinoIcons.lightbulb_fill;
      case ExpenseCategory.healthcare:
        return CupertinoIcons.heart_fill;
      case ExpenseCategory.education:
        return CupertinoIcons.book_fill;
      case ExpenseCategory.shopping:
        return CupertinoIcons.bag_fill;
      case ExpenseCategory.travel:
        return CupertinoIcons.airplane;
      case ExpenseCategory.gifts:
        return CupertinoIcons.gift_fill;
      case ExpenseCategory.other:
        return CupertinoIcons.circle_grid_3x3_fill;
    }
  }
}

// View All Screen
class ViewAllScreen extends StatelessWidget {
  final List<Expense> expenses;
  final Function(String) onDelete;
  final UserSettings settings;

  const ViewAllScreen({
    super.key,
    required this.expenses,
    required this.onDelete,
    required this.settings,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'All Transactions',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.arrow_left, color: Color(0xFF2D3436)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: expenses.isEmpty
          ? Center(
              child: Text(
                'No transactions yet',
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                final expense = expenses[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: ExpenseListItem(
                    expense: expense,
                    onDelete: () => onDelete(expense.id),
                    settings: settings,
                  ),
                );
              },
            ),
    );
  }
}

// Onboarding Screen
class OnboardingScreen extends StatefulWidget {
  final Function(UserSettings) onSave;

  const OnboardingScreen({super.key, required this.onSave});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _salaryController = TextEditingController();
  String _selectedCurrencyCode = 'USD';
  Gender _selectedGender = Gender.male;

  @override
  void dispose() {
    _nameController.dispose();
    _salaryController.dispose();
    super.dispose();
  }

  void _saveOnboarding() {
    if (_formKey.currentState!.validate()) {
      final newSettings = UserSettings(
        userName: _nameController.text.trim(),
        currencyCode: _selectedCurrencyCode,
        monthlySalary: _salaryController.text.trim().isEmpty
            ? null
            : double.parse(_salaryController.text.trim()),
        gender: _selectedGender,
        isFirstTime: false,
      );

      widget.onSave(newSettings);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
              child: Column(
                children: [
                  const Icon(
                    CupertinoIcons.sparkles,
                    size: 48,
                    color: Color(0xFFB4E50D),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Welcome!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3436),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Let\'s set up your profile to get started.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // Form Content
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  children: [
                    // Profile Section
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: TextFormField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                labelText: 'Name',
                                labelStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                                prefixIcon: Icon(CupertinoIcons.person_fill,
                                    color: Color(0xFFB4E50D)),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                            ),
                          ),
                          const Divider(height: 1, indent: 50),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                const Icon(CupertinoIcons.person_2_fill,
                                    color: Color(0xFFB4E50D)),
                                const SizedBox(width: 12),
                                const Text('Gender',
                                    style: TextStyle(fontSize: 16)),
                                const Spacer(),
                                CupertinoSlidingSegmentedControl<Gender>(
                                  groupValue: _selectedGender,
                                  thumbColor: const Color(0xFFB4E50D),
                                  backgroundColor: const Color(0xFFF5F7FA),
                                  children: const {
                                    Gender.male: Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8),
                                      child: Text('Male'),
                                    ),
                                    Gender.female: Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8),
                                      child: Text('Female'),
                                    ),
                                  },
                                  onValueChanged: (Gender? value) {
                                    if (value != null) {
                                      setState(() {
                                        _selectedGender = value;
                                      });
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Preferences Section
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: DropdownButtonFormField<String>(
                              value: _selectedCurrencyCode,
                              decoration: const InputDecoration(
                                labelText: 'Currency',
                                labelStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                                prefixIcon: Icon(
                                    CupertinoIcons.money_dollar_circle_fill,
                                    color: Color(0xFFB4E50D)),
                              ),
                              items: currencyList.map((currency) {
                                return DropdownMenuItem(
                                  value: currency['code'],
                                  child: Text(
                                      '${currency['symbol']} - ${currency['name']}'),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    _selectedCurrencyCode = value;
                                  });
                                }
                              },
                            ),
                          ),
                          const Divider(height: 1, indent: 50),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: TextFormField(
                              controller: _salaryController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Monthly Budget',
                                labelStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                                prefixIcon: Icon(CupertinoIcons.chart_bar_fill,
                                    color: Color(0xFFB4E50D)),
                              ),
                              validator: (value) {
                                if (value != null && value.isNotEmpty) {
                                  if (double.tryParse(value) == null) {
                                    return 'Please enter a valid number';
                                  }
                                  if (double.parse(value) <= 0) {
                                    return 'Budget must be greater than 0';
                                  }
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Continue Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _saveOnboarding,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFB4E50D),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
