import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:smart_wallpaper/main.dart';
import 'package:gap/gap.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(milliseconds: 2500));
    if (!mounted) return;

    // Navigate with a simple fade transition
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const AuthGate(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // The generated App Icon
            Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    image: const DecorationImage(
                      image: AssetImage('assets/icon.png'),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueAccent.withOpacity(0.3),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                )
                .animate()
                .scale(
                  duration: 800.ms,
                  curve: Curves.easeOutBack,
                  begin: const Offset(0.5, 0.5),
                )
                .fadeIn(duration: 800.ms)
                .shimmer(
                  delay: 1000.ms,
                  duration: 1500.ms,
                  color: Colors.white24,
                ),

            const Gap(30),

            // App Name text
            const Text(
                  'Vista',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                )
                .animate()
                .fadeIn(delay: 500.ms, duration: 800.ms)
                .slideY(begin: 0.3, curve: Curves.easeOut),

            const Gap(10),

            // Subtitle
            const Text(
              'Intelligent Wallpapers',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
                letterSpacing: 2.0,
              ),
            ).animate().fadeIn(delay: 1000.ms, duration: 800.ms),
          ],
        ),
      ),
    );
  }
}
