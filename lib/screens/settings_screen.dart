import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../models.dart';
import '../data.dart';

class SettingsScreen extends StatefulWidget {
  final UserSettings settings;
  final Function(UserSettings) onSave;

  const SettingsScreen({
    super.key,
    required this.settings,
    required this.onSave,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _salaryController;
  late String _selectedCurrencyCode;
  late Gender _selectedGender;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.settings.userName);
    _salaryController = TextEditingController(
      text: widget.settings.monthlySalary?.toString() ?? '',
    );
    _selectedCurrencyCode = widget.settings.currencyCode;
    _selectedGender = widget.settings.gender;
  }

  Color get _primaryColor {
    return _selectedGender == Gender.male
        ? const Color(0xFFB4E50D)
        : const Color(0xFFFFB6C1);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _salaryController.dispose();
    super.dispose();
  }

  void _saveSettings() {
    if (_formKey.currentState!.validate()) {
      final updatedSettings = UserSettings(
        userName: _nameController.text.trim(),
        currencyCode: _selectedCurrencyCode,
        monthlySalary: _salaryController.text.trim().isEmpty
            ? null
            : double.parse(_salaryController.text.trim()),
        gender: _selectedGender,
        isFirstTime: false,
      );

      widget.onSave(updatedSettings);
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Settings saved successfully'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Match Dashboard background
      body: SafeArea(
        child: Column(
          children: [
            // Custom Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(CupertinoIcons.arrow_left,
                        color: Color(0xFF2D3436)),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3436),
                    ),
                  ),
                  TextButton(
                    onPressed: _saveSettings,
                    child: Text(
                      'Done',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _primaryColor, // Dynamic Color
                      ),
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
                    // Avatar Section
                    Center(
                      child: Container(
                        width: 100,
                        height: 100,
                        margin: const EdgeInsets.only(bottom: 24, top: 8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 4,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          clipBehavior: Clip.antiAlias,
                          child: Transform.scale(
                            scale: 1.2,
                            child: Image.asset(
                              _selectedGender == Gender.male
                                  ? 'assets/avatars/male.png'
                                  : 'assets/avatars/female.png',
                              fit: BoxFit.cover,
                              filterQuality: FilterQuality.high,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 8, bottom: 8),
                      child: Text(
                        'PROFILE',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF8E8E93),
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(24), // Rounded corners
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
                              decoration: InputDecoration(
                                labelText: 'Name',
                                labelStyle: const TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                                prefixIcon: Icon(CupertinoIcons.person_fill,
                                    color: _primaryColor),
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
                                Icon(CupertinoIcons.person_2_fill,
                                    color: _primaryColor),
                                const SizedBox(width: 12),
                                const Text('Gender',
                                    style: TextStyle(fontSize: 16)),
                                const Spacer(),
                                CupertinoSlidingSegmentedControl<Gender>(
                                  groupValue: _selectedGender,
                                  thumbColor: _primaryColor,
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
                    const Padding(
                      padding: EdgeInsets.only(left: 8, bottom: 8),
                      child: Text(
                        'PREFERENCES',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF8E8E93),
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
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
                              isExpanded: true,
                              value: _selectedCurrencyCode,
                              decoration: InputDecoration(
                                labelText: 'Currency',
                                labelStyle: const TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                                prefixIcon: Icon(
                                    CupertinoIcons.money_dollar_circle_fill,
                                    color: _primaryColor),
                              ),
                              items:
                                  (List<Map<String, String>>.from(currencyList)
                                        ..sort((a, b) => (a['name'] ?? '')
                                            .compareTo(b['name'] ?? '')))
                                      .map((currency) {
                                return DropdownMenuItem(
                                  value: currency['code'],
                                  child: Text(
                                    '${currency['symbol']} - ${currency['name']}',
                                    overflow: TextOverflow.ellipsis,
                                  ),
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
                              decoration: InputDecoration(
                                labelText: 'Monthly Budget',
                                labelStyle: const TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                                prefixIcon: Icon(CupertinoIcons.chart_bar_fill,
                                    color: _primaryColor),
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
                    const Padding(
                      padding: EdgeInsets.only(left: 16, top: 12),
                      child: Text(
                        'Set your monthly budget to track your spending progress.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF8E8E93),
                        ),
                      ),
                    ),
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
