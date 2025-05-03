import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/habit_logging_screen.dart';
import '../screens/achievements_screen.dart';
import '../screens/settings_screen.dart';
import '../widgets/bottom_nav_bar.dart';

class BottomNavWrapper extends StatefulWidget {
  const BottomNavWrapper({super.key});

  @override
  State<BottomNavWrapper> createState() => _BottomNavWrapperState();
}

class _BottomNavWrapperState extends State<BottomNavWrapper> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const HabitLoggingScreen(),
    const AchievementsScreen(),
    const SettingsScreen(),
  ];

  void _onTabSelected(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _currentIndex,
        onItemTapped: _onTabSelected,
      ),
    );
  }
}
