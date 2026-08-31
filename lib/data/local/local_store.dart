import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'data_store.dart';

/// Wraps [SharedPreferences] as a simple key/value + JSON document store.
///
/// Retained for tests and offline tooling. In production AyahPath stores all
/// learning data in Firebase Realtime Database via [FirebaseDataStore]; only
/// the login session (handled by FirebaseAuth) stays local.
class LocalStore implements DataStore {
  LocalStore(this._prefs);

  final SharedPreferences _prefs;
  static const String _profileKey = 'ayahpath.learner_profile';
  static const String _completedLessonsKey = 'ayahpath.completed_lessons';
  static const String _masteryScoresKey = 'ayahpath.mastery_scores';

  @override
  Future<void> saveLearnerProfile(Map<String, dynamic> json) async {
    await _prefs.setString(_profileKey, jsonEncode(json));
  }

  @override
  Future<Map<String, dynamic>?> loadLearnerProfile() async {
    final raw = _prefs.getString(_profileKey);
    if (raw == null) return null;
    try {
      final decoded = jsonDecode(raw);
      return decoded is Map<String, dynamic> ? decoded : null;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> clearLearnerData() async {
    await _prefs.remove(_profileKey);
  }

  // ---------- Surah lesson persistence ----------

  @override
  Future<void> saveCompletedLessonIds(List<int> ids) async {
    await _prefs.setString(_completedLessonsKey, jsonEncode(ids));
  }

  @override
  Future<List<int>?> loadCompletedLessonIds() async {
    final raw = _prefs.getString(_completedLessonsKey);
    if (raw == null) return null;
    try {
      final decoded = jsonDecode(raw);
      return (decoded as List).map((e) => e as int).toList();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveMasteryScores(Map<String, double> scores) async {
    await _prefs.setString(_masteryScoresKey, jsonEncode(scores));
  }

  @override
  Future<Map<String, double>?> loadMasteryScores() async {
    final raw = _prefs.getString(_masteryScoresKey);
    if (raw == null) return null;
    try {
      final decoded = jsonDecode(raw);
      return (decoded as Map<String, dynamic>).map(
        (k, v) => MapEntry(k, (v as num).toDouble()),
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> clearSurahLessonData() async {
    await _prefs.remove(_completedLessonsKey);
    await _prefs.remove(_masteryScoresKey);
  }

  @override
  Future<void> clearAllUserData() async {
    await clearLearnerData();
    await clearSurahLessonData();
  }
}
