import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_wallpaper/core/theme/app_theme.dart';
import 'package:smart_wallpaper/features/wallpapers/presentation/providers/auth_provider.dart';
import 'package:gap/gap.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _isLoading = false;

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);

    try {
      final authNotifier = ref.read(authNotifierProvider.notifier);
      final error = await authNotifier.signInWithGoogle();

      if (!mounted) return;

      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: Colors.red.shade700),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.backgroundColor,
              AppTheme.surfaceColor,
              const Color(0xFF1a1040),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                const Spacer(flex: 2),

                // App icon / branding
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: AppTheme.primaryColor.withOpacity(0.3),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.asset(
                      'assets/icon.png',
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const Gap(24),

                const Text(
                  'Vista',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
                const Gap(8),
                Text(
                  'Premium wallpapers for your device',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),

                const Spacer(flex: 3),

                // Google Sign-In button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _signInWithGoogle,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.black54,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.network(
                                'https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg',
                                width: 20,
                                height: 20,
                                errorBuilder: (_, __, ___) => const Icon(
                                  Icons.g_mobiledata,
                                  size: 24,
                                  color: Colors.red,
                                ),
                              ),
                              const Gap(12),
                              const Text(
                                'Continue with Google',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                const Gap(16),

                Text(
                  'By signing in, you agree to our Terms of Service',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.3),
                  ),
                  textAlign: TextAlign.center,
                ),
                const Gap(32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
