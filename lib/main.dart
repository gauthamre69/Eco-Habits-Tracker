import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth/auth_page.dart';
import 'onboarding/onboarding_screen.dart';
import 'theme/eco_theme.dart';

/// 🔥 Global theme notifier
final ValueNotifier<bool> themeNotifier = ValueNotifier(false);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final prefs = await SharedPreferences.getInstance();
  final showOnboarding = prefs.getBool('showOnboarding') ?? true;
  final isDarkMode = prefs.getBool('isDarkMode') ?? false;
  themeNotifier.value = isDarkMode;

  runApp(EcoHabitsApp(showOnboarding: showOnboarding));
}

class EcoHabitsApp extends StatelessWidget {
  final bool showOnboarding;

  const EcoHabitsApp({super.key, required this.showOnboarding});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: themeNotifier,
      builder: (_, isDarkMode, __) {
        return MaterialApp(
          title: 'Eco Habits Tracker',
          debugShowCheckedModeBanner: false,
          theme: isDarkMode ? ThemeData.dark() : EcoTheme.lightTheme,
          home: showOnboarding ? const OnboardingScreen() : const AuthPage(),
        );
      },
    );
  }
}
