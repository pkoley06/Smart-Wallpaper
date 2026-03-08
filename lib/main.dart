import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:smart_wallpaper/core/di/injection_container.dart' as di;
import 'package:smart_wallpaper/core/theme/app_theme.dart';
import 'package:smart_wallpaper/features/wallpapers/presentation/pages/home_screen.dart';
import 'package:smart_wallpaper/features/wallpapers/presentation/pages/login_screen.dart';
import 'package:smart_wallpaper/features/wallpapers/presentation/providers/auth_provider.dart';
import 'package:smart_wallpaper/features/wallpapers/presentation/pages/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://feycrgmmimlmrnfxafmb.supabase.co',
    anonKey: 'sb_publishable_R-6ByLVRzsDVb1vacQStvA_QpMHskX1',
  );

  // Initialize Dependency Injection
  await di.init();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vista',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const SplashScreen(),
    );
  }
}

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedIn = ref.watch(authNotifierProvider);
    return isLoggedIn ? const HomeScreen() : const LoginScreen();
  }
}
