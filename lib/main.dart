import 'package:flutter/material.dart';

void main() {
  runApp(const ExpenseTrackerApp());
}

// Data Models
enum ExpenseCategory { food, transport, work, entertainment }

enum TimeFilter { today, week, month }

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

// Main App
class ExpenseTrackerApp extends StatelessWidget {
  const ExpenseTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const ExpenseTrackerHome(),
    );
  }
}

// Home Screen with State Management
class ExpenseTrackerHome extends StatefulWidget {
  const ExpenseTrackerHome({super.key});

  @override
  State<ExpenseTrackerHome> createState() => _ExpenseTrackerHomeState();
}

class _ExpenseTrackerHomeState extends State<ExpenseTrackerHome> {
  final List<Expense> _expenses = [];
  TimeFilter _selectedFilter = TimeFilter.month;

  @override
  void initState() {
    super.initState();
    _addSampleData();
  }

  void _addSampleData() {
    final now = DateTime.now();
    _expenses.addAll([
      Expense(
        id: _generateId(),
        title: 'Lunch at Restaurant',
        amount: 25.50,
        date: now,
        category: ExpenseCategory.food,
      ),
      Expense(
        id: _generateId(),
        title: 'Uber to Office',
        amount: 12.00,
        date: now.subtract(const Duration(days: 1)),
        category: ExpenseCategory.transport,
      ),
      Expense(
        id: _generateId(),
        title: 'Office Supplies',
        amount: 45.99,
        date: now.subtract(const Duration(days: 3)),
        category: ExpenseCategory.work,
      ),
      Expense(
        id: _generateId(),
        title: 'Movie Tickets',
        amount: 30.00,
        date: now.subtract(const Duration(days: 8)),
        category: ExpenseCategory.entertainment,
      ),
    ]);
  }

  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  List<Expense> _getFilteredExpenses() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return _expenses.where((expense) {
      final expenseDate = DateTime(
        expense.date.year,
        expense.date.month,
        expense.date.day,
      );

      switch (_selectedFilter) {
        case TimeFilter.today:
          return expenseDate.isAtSameMomentAs(today);
        case TimeFilter.week:
          final weekAgo = today.subtract(const Duration(days: 7));
          return expenseDate.isAfter(weekAgo.subtract(const Duration(days: 1))) &&
              expenseDate.isBefore(today.add(const Duration(days: 1)));
        case TimeFilter.month:
          final monthAgo = DateTime(now.year, now.month - 1, now.day);
          return expenseDate.isAfter(monthAgo.subtract(const Duration(days: 1)));
      }
    }).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  double _getTotalExpense() {
    final filtered = _getFilteredExpenses();
    return filtered.fold(0.0, (sum, expense) => sum + expense.amount);
  }

  void _addExpense(Expense expense) {
    setState(() {
      _expenses.add(expense);
    });
  }

  void _deleteExpense(String id) {
    setState(() {
      _expenses.removeWhere((expense) => expense.id == id);
    });
  }

  void _showAddExpenseModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddExpenseModal(
        onAddExpense: _addExpense,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredExpenses = _getFilteredExpenses();
    final total = _getTotalExpense();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Total Spent Card
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primaryContainer,
                  Theme.of(context).colorScheme.secondaryContainer,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Spent',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '\$${total.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),

          // Time Filter Segmented Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SegmentedButton<TimeFilter>(
              segments: const [
                ButtonSegment(
                  value: TimeFilter.today,
                  label: Text('Today'),
                  icon: Icon(Icons.today),
                ),
                ButtonSegment(
                  value: TimeFilter.week,
                  label: Text('Week'),
                  icon: Icon(Icons.date_range),
                ),
                ButtonSegment(
                  value: TimeFilter.month,
                  label: Text('Month'),
                  icon: Icon(Icons.calendar_month),
                ),
              ],
              selected: {_selectedFilter},
              onSelectionChanged: (Set<TimeFilter> selected) {
                setState(() {
                  _selectedFilter = selected.first;
                });
              },
            ),
          ),

          const SizedBox(height: 16),

          // Expense List
          Expanded(
            child: filteredExpenses.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt_long_outlined,
                          size: 64,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No expenses found',
                          style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Add your first expense using the + button',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredExpenses.length,
                    itemBuilder: (context, index) {
                      final expense = filteredExpenses[index];
                      return ExpenseListItem(
                        expense: expense,
                        onDelete: () => _deleteExpense(expense.id),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddExpenseModal,
        icon: const Icon(Icons.add),
        label: const Text('Add Expense'),
      ),
    );
  }
}

// Expense List Item with Swipe to Delete
class ExpenseListItem extends StatelessWidget {
  final Expense expense;
  final VoidCallback onDelete;

  const ExpenseListItem({
    super.key,
    required this.expense,
    required this.onDelete,
  });

  IconData _getCategoryIcon() {
    switch (expense.category) {
      case ExpenseCategory.food:
        return Icons.restaurant;
      case ExpenseCategory.transport:
        return Icons.directions_car;
      case ExpenseCategory.work:
        return Icons.work;
      case ExpenseCategory.entertainment:
        return Icons.movie;
    }
  }

  Color _getCategoryColor(BuildContext context) {
    switch (expense.category) {
      case ExpenseCategory.food:
        return Colors.orange;
      case ExpenseCategory.transport:
        return Colors.blue;
      case ExpenseCategory.work:
        return Colors.purple;
      case ExpenseCategory.entertainment:
        return Colors.pink;
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day.toString().padLeft(2, '0')}, ${date.year}';
  }

  String _getCategoryName() {
    return expense.category.name[0].toUpperCase() + 
           expense.category.name.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(expense.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 32,
        ),
      ),
      onDismissed: (direction) {
        onDelete();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${expense.title} deleted'),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 8),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: CircleAvatar(
            backgroundColor: _getCategoryColor(context).withOpacity(0.2),
            child: Icon(
              _getCategoryIcon(),
              color: _getCategoryColor(context),
            ),
          ),
          title: Text(
            expense.title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                _getCategoryName(),
                style: TextStyle(
                  fontSize: 12,
                  color: _getCategoryColor(context),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                _formatDate(expense.date),
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          trailing: Text(
            '\$${expense.amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }
}

// Add Expense Modal Bottom Sheet
class AddExpenseModal extends StatefulWidget {
  final Function(Expense) onAddExpense;

  const AddExpenseModal({
    super.key,
    required this.onAddExpense,
  });

  @override
  State<AddExpenseModal> createState() => _AddExpenseModalState();
}

class _AddExpenseModalState extends State<AddExpenseModal> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  ExpenseCategory _selectedCategory = ExpenseCategory.food;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  void _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day.toString().padLeft(2, '0')}, ${date.year}';
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final expense = Expense(
        id: _generateId(),
        title: _titleController.text.trim(),
        amount: double.parse(_amountController.text),
        date: _selectedDate,
        category: _selectedCategory,
      );

      widget.onAddExpense(expense);
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Expense "${expense.title}" added successfully'),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Title
                Text(
                  'Add New Expense',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),

                // Title Field
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    hintText: 'Enter expense title',
                    prefixIcon: const Icon(Icons.title),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Amount Field
                TextFormField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    hintText: 'Enter amount',
                    prefixIcon: const Icon(Icons.attach_money),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter an amount';
                    }
                    final amount = double.tryParse(value);
                    if (amount == null || amount <= 0) {
                      return 'Please enter a valid amount';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Date Picker
                InkWell(
                  onTap: _pickDate,
                  borderRadius: BorderRadius.circular(12),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Date',
                      prefixIcon: const Icon(Icons.calendar_today),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(_formatDate(_selectedDate)),
                  ),
                ),
                const SizedBox(height: 16),

                // Category Dropdown
                DropdownButtonFormField<ExpenseCategory>(
                  value: _selectedCategory,
                  decoration: InputDecoration(
                    labelText: 'Category',
                    prefixIcon: const Icon(Icons.category),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: ExpenseCategory.values.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(
                        category.name[0].toUpperCase() + category.name.substring(1),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 24),

                // Submit Button
                FilledButton(
                  onPressed: _submitForm,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Add Expense',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
