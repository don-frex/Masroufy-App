import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models.dart';
import 'screens.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // Load data
  final expenses = await StorageService.loadExpenses();
  final settings = await StorageService.loadSettings();

  runApp(ExpenseTrackerApp(
    initialExpenses: expenses,
    initialSettings: settings,
  ));
}

// Main App
class ExpenseTrackerApp extends StatefulWidget {
  final List<Expense>? initialExpenses;
  final UserSettings? initialSettings;

  const ExpenseTrackerApp({
    super.key,
    this.initialExpenses,
    this.initialSettings,
  });

  @override
  State<ExpenseTrackerApp> createState() => _ExpenseTrackerAppState();
}

class _ExpenseTrackerAppState extends State<ExpenseTrackerApp> {
  // Global State
  late UserSettings _settings;
  late List<Expense> _expenses;
  bool _showSplash = true;
  bool _isOnboarding = false;

  @override
  void initState() {
    super.initState();
    _settings = widget.initialSettings ?? UserSettings();
    _expenses = widget.initialExpenses ?? [];
  }

  void _updateSettings(UserSettings newSettings) {
    setState(() {
      _settings = newSettings;
    });
    StorageService.saveSettings(newSettings);
  }

  void _completeSplash() {
    setState(() {
      _showSplash = false;
      // If expenses is null (meaning no data found), show Welcome Page (Onboarding)
      if (widget.initialExpenses == null) {
        _isOnboarding = true;
      } else {
        _isOnboarding = false;
      }
    });
  }

  void _completeOnboarding(UserSettings newSettings) {
    setState(() {
      _settings = newSettings;
      _isOnboarding = false;
      // Initialize expenses as empty list if it was null
      _expenses = [];
    });
    StorageService.saveSettings(newSettings);
    StorageService.saveExpenses(
        _expenses); // Save empty list to mark as initialized
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Masroufy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
        useMaterial3: true,
      ),
      home: _showSplash
          ? SplashScreen(onStart: _completeSplash)
          : _isOnboarding
              ? OnboardingScreen(onSave: _completeOnboarding)
              : ExpenseTrackerHome(
                  settings: _settings,
                  onUpdateSettings: _updateSettings,
                  initialExpenses: _expenses,
                ),
    );
  }
}
