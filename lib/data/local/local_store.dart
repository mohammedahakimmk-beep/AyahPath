import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Wraps [SharedPreferences] as a simple key/value + JSON document store.
///
/// This is the local persistence layer (offline-first). It is deliberately
/// abstracted so a more robust backend (Drift/SQLite) can be swapped in
/// without changing the rest of the app.
class LocalStore {
  LocalStore(this._prefs);

  final SharedPreferences _prefs;
  static const String _profileKey = 'ayahpath.learner_profile';
  static const String _completedLessonsKey = 'ayahpath.completed_lessons';
  static const String _masteryScoresKey = 'ayahpath.mastery_scores';

  Future<void> saveLearnerProfile(Map<String, dynamic> json) async {
    await _prefs.setString(_profileKey, jsonEncode(json));
  }

  Map<String, dynamic>? loadLearnerProfile() {
    final raw = _prefs.getString(_profileKey);
    if (raw == null) return null;
    try {
      final decoded = jsonDecode(raw);
      return decoded is Map<String, dynamic> ? decoded : null;
    } catch (_) {
      return null;
    }
  }

  Future<void> clearLearnerData() async {
    await _prefs.remove(_profileKey);
  }

  // ---------- Surah lesson persistence ----------

  Future<void> saveCompletedLessonIds(List<int> ids) async {
    await _prefs.setString(_completedLessonsKey, jsonEncode(ids));
  }

  List<int>? loadCompletedLessonIds() {
    final raw = _prefs.getString(_completedLessonsKey);
    if (raw == null) return null;
    try {
      final decoded = jsonDecode(raw);
      return (decoded as List).map((e) => e as int).toList();
    } catch (_) {
      return null;
    }
  }

  Future<void> saveMasteryScores(Map<String, double> scores) async {
    await _prefs.setString(_masteryScoresKey, jsonEncode(scores));
  }

  Map<String, double>? loadMasteryScores() {
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

  Future<void> clearSurahLessonData() async {
    await _prefs.remove(_completedLessonsKey);
    await _prefs.remove(_masteryScoresKey);
  }
}
