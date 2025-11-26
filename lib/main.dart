import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models.dart';
import 'screens.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const ExpenseTrackerApp());
}

// Main App
class ExpenseTrackerApp extends StatefulWidget {
  const ExpenseTrackerApp({super.key});

  @override
  State<ExpenseTrackerApp> createState() => _ExpenseTrackerAppState();
}

class _ExpenseTrackerAppState extends State<ExpenseTrackerApp> {
  // Global State
  UserSettings _settings = UserSettings();
  bool _showSplash = true;
  bool _isOnboarding = false;

  void _updateSettings(UserSettings newSettings) {
    setState(() {
      _settings = newSettings;
    });
  }

  void _completeSplash() {
    setState(() {
      _showSplash = false;
      if (_settings.isFirstTime) {
        _isOnboarding = true;
      }
    });
  }

  void _completeOnboarding(UserSettings newSettings) {
    setState(() {
      _settings = newSettings;
      _isOnboarding = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
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
                ),
    );
  }
}
