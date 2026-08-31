import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

/// Persistence contract for all learning/user data.
///
/// In production this is backed by Firebase Realtime Database (online, keyed
/// per authenticated user). Only login status is meant to remain local (that
/// is handled by FirebaseAuth itself). A local/SharedPreferences-backed
/// implementation is retained solely for tests and offline tooling.
abstract class DataStore {
  Future<Map<String, dynamic>?> loadLearnerProfile();
  Future<void> saveLearnerProfile(Map<String, dynamic> json);

  Future<List<int>?> loadCompletedLessonIds();
  Future<void> saveCompletedLessonIds(List<int> ids);

  Future<Map<String, double>?> loadMasteryScores();
  Future<void> saveMasteryScores(Map<String, double> scores);

  Future<void> clearLearnerData();
  Future<void> clearSurahLessonData();

  /// Removes every record belonging to the current user/session.
  Future<void> clearAllUserData();
}

/// Realtime Database-backed [DataStore], scoped to the current Firebase user.
///
/// Data lives under `users/{uid}/`, guarded by RTDB security rules so only the
/// authenticated owner can read/write their own records. If the user signs out
/// or is anonymous, reads return `null` and writes are no-ops.
class FirebaseDataStore implements DataStore {
  FirebaseDataStore({FirebaseAuth? auth, FirebaseDatabase? database})
      : _auth = auth ?? FirebaseAuth.instance,
        _db = database ?? FirebaseDatabase.instance;

  final FirebaseAuth _auth;
  final FirebaseDatabase _db;

  String? get _uid => _auth.currentUser?.uid;

  DatabaseReference get _userRef => _db.ref('users/$_uid');

  bool get _signedIn => _uid != null;

  Future<void> _write(String key, Object? value) async {
    if (!_signedIn) return;
    await _userRef.child(key).set(value);
  }

  @override
  Future<void> saveLearnerProfile(Map<String, dynamic> json) async {
    await _write('profile', json);
  }

  @override
  Future<Map<String, dynamic>?> loadLearnerProfile() async {
    if (!_signedIn) return null;
    final snap = await _userRef.child('profile').once();
    final value = snap.snapshot.value;
    return value is Map ? Map<String, dynamic>.from(value) : null;
  }

  @override
  Future<void> saveCompletedLessonIds(List<int> ids) async {
    await _write('lessons/completed', ids);
  }

  @override
  Future<List<int>?> loadCompletedLessonIds() async {
    if (!_signedIn) return null;
    final snap = await _userRef.child('lessons/completed').once();
    final value = snap.snapshot.value;
    if (value is List) {
      return value.map((e) => (e as num).toInt()).toList();
    }
    return null;
  }

  @override
  Future<void> saveMasteryScores(Map<String, double> scores) async {
    await _write('lessons/mastery', scores);
  }

  @override
  Future<Map<String, double>?> loadMasteryScores() async {
    if (!_signedIn) return null;
    final snap = await _userRef.child('lessons/mastery').once();
    final value = snap.snapshot.value;
    if (value is Map) {
      final map = Map<String, dynamic>.from(value);
      return map.map((k, v) => MapEntry(k, (v as num).toDouble()));
    }
    return null;
  }

  @override
  Future<void> clearLearnerData() async {
    await _userRef.child('profile').remove();
  }

  @override
  Future<void> clearSurahLessonData() async {
    await _userRef.child('lessons').remove();
  }

  @override
  Future<void> clearAllUserData() async {
    if (!_signedIn) return;
    await _userRef.remove();
  }

  /// Exposed for debugging / tooling only.
  String? get debugUid => _uid;
}
