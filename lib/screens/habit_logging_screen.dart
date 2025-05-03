import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class HabitLoggingScreen extends StatefulWidget {
  const HabitLoggingScreen({super.key});

  @override
  State<HabitLoggingScreen> createState() => _HabitLoggingScreenState();
}

class _HabitLoggingScreenState extends State<HabitLoggingScreen> {
  final FirestoreService _firestore = FirestoreService();

  final List<Map<String, dynamic>> _habitOptions = [
    {"label": "Used a reusable bag", "icon": Icons.shopping_bag},
    {"label": "Took a short shower", "icon": Icons.shower},
    {"label": "Recycled plastic", "icon": Icons.recycling},
    {"label": "Used public transport", "icon": Icons.directions_bus},
    {"label": "Saved electricity", "icon": Icons.bolt},
    {"label": "Planted a tree", "icon": Icons.park},
  ];

  Future<void> _logHabit(String habitLabel) async {
    await _firestore.logHabit();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("✅ '$habitLabel' logged! +10 eco points")),
    );
  }

  Future<void> _showCustomHabitDialog() async {
    String customHabit = "";

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add Custom Habit"),
        content: TextField(
          autofocus: true,
          decoration: const InputDecoration(hintText: "e.g. Donated old clothes"),
          onChanged: (value) => customHabit = value,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (customHabit.trim().isNotEmpty) {
                _logHabit(customHabit.trim());
                Navigator.pop(context);
              }
            },
            child: const Text("Log Habit"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text("Log Eco Habits")),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCustomHabitDialog,
        tooltip: "Add Custom Habit",
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _habitOptions.length,
        itemBuilder: (context, index) {
          final habit = _habitOptions[index];
          return Card(
            color: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: Icon(habit['icon'], color: Colors.green),
              title: Text(habit['label']),
              trailing: IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => _logHabit(habit['label']),
              ),
            ),
          );
        },
      ),
    );
  }
}
