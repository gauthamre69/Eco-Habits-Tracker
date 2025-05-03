import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/firestore_service.dart';
import 'leaderboard_screen.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  final FirestoreService _firestore = FirestoreService();
  Map<String, dynamic>? userStats;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final data = await _firestore.getUserData();
    setState(() => userStats = data);
  }

  @override
  Widget build(BuildContext context) {
    if (userStats == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Achievements"),
        actions: [
          IconButton(
            icon: const Icon(Icons.leaderboard),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LeaderboardScreen()),
              );
            },
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildAchievementCard(
            title: "First Habit Logged",
            icon: FontAwesomeIcons.shoePrints,
            isUnlocked: (userStats!['habitsLogged'] ?? 0) >= 1,
          ),
          _buildAchievementCard(
            title: "10 Habits Champion",
            icon: FontAwesomeIcons.clipboardCheck,
            isUnlocked: (userStats!['habitsLogged'] ?? 0) >= 10,
          ),
          _buildAchievementCard(
            title: "7-Day Streak Hero",
            icon: FontAwesomeIcons.fire,
            isUnlocked: (userStats!['streakDays'] ?? 0) >= 7,
          ),
          _buildAchievementCard(
            title: "100 Eco Points",
            icon: FontAwesomeIcons.leaf,
            isUnlocked: (userStats!['ecoPoints'] ?? 0) >= 100,
          ),
          _buildAchievementCard(
            title: "Consistency Master",
            icon: FontAwesomeIcons.calendarCheck,
            isUnlocked: (userStats!['streakDays'] ?? 0) >= 30,
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementCard({
    required String title,
    required IconData icon,
    required bool isUnlocked,
  }) {
    final theme = Theme.of(context);
    final bgColor = theme.brightness == Brightness.dark
        ? Colors.grey.shade900
        : Colors.grey.shade100;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Icon(icon, color: isUnlocked ? Colors.green : Colors.grey),
        title: Text(title, style: theme.textTheme.bodyLarge),
        trailing: Icon(
          isUnlocked ? Icons.check_circle : Icons.lock,
          color: isUnlocked ? Colors.green : Colors.grey,
        ),
      ),
    );
  }
}
