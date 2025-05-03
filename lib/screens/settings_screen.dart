import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../auth/auth_page.dart';
import '../main.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _nameController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadTheme();
  }

  void _loadUserData() async {
    final doc = await _db.collection('users').doc(_auth.currentUser!.uid).get();
    final data = doc.data();
    if (data != null && data['name'] != null) {
      _nameController.text = data['name'];
    }
  }

  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  Future<void> _saveDisplayName() async {
    await _db.collection('users').doc(_auth.currentUser!.uid).update({
      'name': _nameController.text.trim(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Name updated successfully!")),
    );
  }

  Future<void> _deleteAccount() async {
    final uid = _auth.currentUser!.uid;

    await _db.collection('users').doc(uid).delete(); // Firestore
    await _auth.currentUser!.delete(); // Auth

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const AuthPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                title: Text(user?.email ?? "No email"),
                subtitle: Text("UID: ${user?.uid ?? 'Unknown'}"),
              ),
            ),
            const SizedBox(height: 24),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Account", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Display Name",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: _saveDisplayName,
                ),
              ),
            ),
            const SizedBox(height: 20),

            SwitchListTile(
              value: isDarkMode,
              onChanged: (val) async {
                setState(() => isDarkMode = val);
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('isDarkMode', val);
                themeNotifier.value = val; 
              },
              title: const Text("Dark Mode"),
              secondary: const Icon(Icons.dark_mode),
            ),

            ListTile(
              leading: const Icon(Icons.delete_forever, color: Colors.red),
              title: const Text("Delete My Account"),
              onTap: () => _confirmDelete(context),
            ),

            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () async {
                await _auth.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const AuthPage()),
                  (route) => false,
                );
              },
              icon: const Icon(Icons.logout),
              label: const Text("Logout"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: const Text("This will permanently delete your account and data."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteAccount();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }
}
