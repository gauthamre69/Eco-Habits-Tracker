import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String get uid => _auth.currentUser!.uid;

  Future<void> initializeUserIfNew() async {
    final ref = _db.collection('users').doc(uid);
    final doc = await ref.get();
    if (!doc.exists) {
      await ref.set({
        'ecoPoints': 0,
        'habitsLogged': 0,
        'streakDays': 1,
        'lastLogDate': DateTime.now().toIso8601String(),
      });
    }
  }

  Future<Map<String, dynamic>> getUserData() async {
    final doc = await _db.collection('users').doc(uid).get();
    return doc.data() ?? {};
  }

  Future<void> updateStreakIfNeeded() async {
    final ref = _db.collection('users').doc(uid);
    final doc = await ref.get();
    final data = doc.data();
    if (data == null) return;

    final today = DateTime.now();
    final lastDateStr = data['lastLogDate'] ?? '';
    final lastDate = DateTime.tryParse(lastDateStr);

    if (lastDate == null) {
      await ref.update({
        'streakDays': 1,
        'lastLogDate': today.toIso8601String(),
      });
      return;
    }

    final difference = today.difference(lastDate).inDays;

    if (difference >= 2) {
      await ref.update({
        'streakDays': 1,
        'lastLogDate': today.toIso8601String(),
      });
    } else if (difference == 1) {
      await ref.update({
        'streakDays': (data['streakDays'] ?? 0) + 1,
        'lastLogDate': today.toIso8601String(),
      });
    }
  }

  // ✅ Correct placement of this method
  Future<void> logHabit() async {
    final ref = _db.collection('users').doc(uid);
    final snapshot = await ref.get();
    final data = snapshot.data() ?? {};

    final int ecoPoints = (data['ecoPoints'] ?? 0) + 10;
    final int habitsLogged = (data['habitsLogged'] ?? 0) + 1;

    await ref.update({
      'ecoPoints': ecoPoints,
      'habitsLogged': habitsLogged,
      'lastLogDate': DateTime.now().toIso8601String(),
    });
  }
}
