import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../models.dart';
import '../widgets.dart';
import '../screens.dart';
import 'settings_screen.dart';
import 'add_transaction_screen.dart';

// Home Screen with State Management
class ExpenseTrackerHome extends StatefulWidget {
  final UserSettings settings;
  final Function(UserSettings) onUpdateSettings;

  const ExpenseTrackerHome({
    super.key,
    required this.settings,
    required this.onUpdateSettings,
  });

  @override
  State<ExpenseTrackerHome> createState() => _ExpenseTrackerHomeState();
}

class _ExpenseTrackerHomeState extends State<ExpenseTrackerHome> {
  final List<Expense> _expenses = [];
  TimeFilter _selectedFilter = TimeFilter.month;

  @override
  void initState() {
    super.initState();
    // Start with empty list
  }

  List<Expense> _getFilteredExpenses() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final weekStart = today.subtract(Duration(days: today.weekday - 1));
    final monthStart = DateTime(now.year, now.month, 1);

    return _expenses.where((expense) {
      switch (_selectedFilter) {
        case TimeFilter.today:
          return expense.date.isAfter(today);
        case TimeFilter.week:
          return expense.date.isAfter(weekStart);
        case TimeFilter.month:
          return expense.date.isAfter(monthStart);
        case TimeFilter.all:
          return true;
      }
    }).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  double _getTotalExpense() {
    return _getFilteredExpenses().fold(0, (sum, item) => sum + item.amount);
  }

  void _addExpense(Expense expense) {
    setState(() {
      _expenses.add(expense);
    });
  }

  void _deleteExpense(String id) {
    setState(() {
      _expenses.removeWhere((item) => item.id == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Transaction deleted'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showAddExpenseModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AddTransactionScreen(
        onAddExpense: _addExpense,
        settings: widget.settings,
      ),
    );
  }

  void _navigateToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsScreen(
          settings: widget.settings,
          onSave: widget.onUpdateSettings,
        ),
      ),
    );
  }

  void _navigateToAnalytics() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AnalyticsScreen(
          expenses: _expenses,
          totalSpent: _getTotalExpense(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredExpenses = _getFilteredExpenses();
    final total = _getTotalExpense();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello,',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            widget.settings.userName.split(' ')[0],
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D3436),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(CupertinoIcons.bell,
                            color: Color(0xFF2D3436)),
                      ),
                    ],
                  ),
                ),

                // Filter Tabs
                FilterTabs(
                  selectedFilter: _selectedFilter,
                  onSelect: (filter) {
                    setState(() {
                      _selectedFilter = filter;
                    });
                  },
                ),

                const SizedBox(height: 24),

                // Summary Card
                SummaryCard(
                  totalSpent: total,
                  income: widget.settings.monthlySalary ?? 5000.0,
                ),

                const SizedBox(height: 24),

                // Transaction List Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Recent transactions',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3436),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ViewAllScreen(
                                expenses: _expenses,
                                onDelete: _deleteExpense,
                                settings: widget.settings,
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          'View All',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),

                // Transaction List
                Expanded(
                  child: filteredExpenses.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(CupertinoIcons.doc_text_search,
                                  size: 64, color: Colors.grey[300]),
                              const SizedBox(height: 16),
                              Text(
                                'No expenses found',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[500],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
                          itemCount: filteredExpenses.length,
                          itemBuilder: (context, index) {
                            final expense = filteredExpenses[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: ExpenseListItem(
                                expense: expense,
                                onDelete: () => _deleteExpense(expense.id),
                                settings: widget.settings,
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),

          // Floating Bottom Nav
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CustomBottomNavBar(
              onAdd: _showAddExpenseModal,
              onProfile: _navigateToSettings,
              onAnalytics: _navigateToAnalytics,
            ),
          ),
        ],
      ),
    );
  }
}
