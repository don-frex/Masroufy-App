import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../widgets.dart';

// Splash Screen
class SplashScreen extends StatelessWidget {
  final VoidCallback onStart;

  const SplashScreen({super.key, required this.onStart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Match Dashboard background
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            // Logo / Icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40), // Softer corners
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFB4E50D)
                        .withOpacity(0.3), // Pastel Green Shadow
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                CupertinoIcons.money_dollar,
                size: 60,
                color: Color(0xFFB4E50D), // Pastel Green
              ),
            ),
            const SizedBox(height: 40),
            // Title
            const Text(
              'Masroufy',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
                color: Color(0xFF2D3436),
              ),
            ),
            const SizedBox(height: 12),
            // Subtitle
            Text(
              'Track your spending\nwith style and ease.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                color: Colors.grey[600],
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            // Start Button
            Padding(
              padding: const EdgeInsets.all(32),
              child: ScaleButton(
                onTap: onStart,
                child: Container(
                  width: double.infinity,
                  height: 64, // Taller button
                  decoration: BoxDecoration(
                    color: const Color(0xFFB4E50D), // Pastel Green
                    borderRadius: BorderRadius.circular(24), // Rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFB4E50D).withOpacity(0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Get Started',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
