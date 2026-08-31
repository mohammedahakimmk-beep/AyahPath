import 'package:flutter/material.dart';

import '../data/local/local_store.dart';
import '../data/models/activity_record.dart';
import '../data/models/learner_profile.dart';
import '../data/models/lesson.dart';
import '../data/models/onboarding_profile.dart';
import '../data/models/skill_type.dart';
import '../data/models/surah_lesson.dart';
import '../data/quran/quran_data.dart';
import '../domain/adaptive/lesson_planner.dart';
import '../domain/adaptive/profile_seeder.dart';
import '../domain/adaptive/skill_tracker.dart';
import '../domain/adaptive/surah_lesson_generator.dart';
import '../domain/model/model_manager_service.dart';
import '../domain/voice/voice_analysis_service.dart';
import '../domain/voice/whisper_voice_analysis.dart';

/// Central application state: the learner model + per-cycle lesson plan.
///
/// This is the orchestrator of AyahPath's core feedback loop:
/// onboarding → placement → learner profile → personalized plan → lesson →
/// practice → voice analysis → assessment → profile update → next lesson.
class AppState extends ChangeNotifier {
  AppState({required this._store})
      : voice = WhisperVoiceAnalysisService() {
    _load();
  }

  final LocalStore _store;

  LearnerProfile profile = LearnerProfile();

  /// The most recently generated personalized lesson.
  LessonPlan? currentLesson;

  /// Voice analysis (on-device by default).
  final VoiceAnalysisService voice;

  /// Real on-device model manager (the Whisper recitation model).
  final ModelManagerService models = ModelManagerService();

  /// Installation status of the on-device voice model.
  bool get voiceModelInstalled => voice.isModelReady;
  String? get voiceModelError => (voice is WhisperVoiceAnalysisService)
      ? (voice as WhisperVoiceAnalysisService).lastError
      : null;
  double get voiceStorageUsedMb =>
      voiceModelInstalled ? ModelManagerService.availableModels.first.sizeMb.toDouble() : 0;

  ThemeMode themeMode = ThemeMode.system;
  bool notificationsEnabled = true;

  // ---------- Surah lesson tracking ----------

  /// Set of completed lesson IDs (surahNumber * 1000 + partNumber).
  final Set<int> completedLessonIds = {};

  /// Mastery scores per lesson ID as string key.
  final Map<String, double> masteryScores = {};

  bool get isBootstrapped => profile.onboardingCompleted;

  bool get needsOnboarding => !profile.onboardingCompleted;

  /// Next recommended surah lesson.
  SurahLesson? get nextSurahLesson => SurahLessonGenerator.nextLesson(
        completedLessonIds: completedLessonIds,
        masteryScores: masteryScores,
      );

  /// Overall lesson stats.
  LessonStats get lessonStats => SurahLessonGenerator.getStats(
        completedLessonIds: completedLessonIds,
        masteryScores: masteryScores,
      );

  void _load() {
    final json = _store.loadLearnerProfile();
    if (json != null) {
      profile = LearnerProfile.fromJson(json);
    } else {
      profile = LearnerProfile();
    }
    // Load surah lesson progress
    final savedLessonIds = _store.loadCompletedLessonIds();
    if (savedLessonIds != null) {
      completedLessonIds.addAll(savedLessonIds);
    }
    final savedMastery = _store.loadMasteryScores();
    if (savedMastery != null) {
      masteryScores.addAll(savedMastery);
    }
  }

  Future<void> persist() async {
    await _store.saveLearnerProfile(profile.toJson());
    await _store.saveCompletedLessonIds(completedLessonIds.toList());
    await _store.saveMasteryScores(masteryScores);
  }

  // ---------- Surah lesson completion ----------

  void markSurahLessonComplete(int lessonId, double score) {
    completedLessonIds.add(lessonId);
    masteryScores[lessonId.toString()] = score;

    profile.lessonsCompleted += 1;
    _recordStreak();

    profile.history.add(ActivityRecord(
      id: 'act-${DateTime.now().millisecondsSinceEpoch}',
      type: 'surah_lesson',
      at: DateTime.now(),
      score: score,
      detail: 'Lesson $lessonId completed',
    ));

    persist();
    notifyListeners();
  }

  bool isSurahLessonCompleted(int lessonId) {
    return completedLessonIds.contains(lessonId);
  }

  double? getMasteryScore(int lessonId) {
    return masteryScores[lessonId.toString()];
  }

  /// Gets lessons for a specific surah with completion status.
  List<SurahLesson> surahLessons(int surahNumber) {
    return SurahLessonGenerator.lessonsForSurah(
      surahNumber,
      completedLessonIds: completedLessonIds,
      masteryScores: masteryScores,
    );
  }

  /// Gets all lessons with completion status.
  List<SurahLesson> allLessons() {
    return SurahLessonGenerator.generateAllLessons(
      completedLessonIds: completedLessonIds,
      masteryScores: masteryScores,
    );
  }

  // ---------- Onboarding ----------

  Future<void> completeOnboarding(OnboardingProfile onboarding) async {
    profile = ProfileSeeder.seed(onboarding);
    profile.onboardingCompleted = true;
    _generateLesson();
    await persist();
    notifyListeners();
  }

  void skipOnboarding() {
    profile = LearnerProfile();
    profile.onboardingSkipped = true;
    profile.onboardingCompleted = true;
    profile.onboarding ??= const OnboardingProfile(
      locale: Locale('en'),
      goals: [LearningGoal.readQuran],
      readingLevel: ReadingLevel.words,
      tajweedLevel: TajweedLevel.none,
      memorizationLevel: MemorizationLevel.none,
      frequency: PracticeFrequency.daily,
    );
    _generateLesson();
    persist();
    notifyListeners();
  }

  // ---------- Placement ----------

  void applyPlacementScores(Map<SkillType, double> scores) {
    scores.forEach((skill, score) {
      SkillTracker.applyOutcome(profile, skill, score);
    });
    profile.placementCompleted = true;
    _generateLesson();
    persist();
    notifyListeners();
  }

  // ---------- Lesson planning ----------

  void _generateLesson() {
    currentLesson = LessonPlanner.buildDailyPlan(profile);
  }

  /// Rebuilds today's lesson after any profile change.
  void refreshLesson() {
    _generateLesson();
    persist();
    notifyListeners();
  }

  /// Marks the current lesson as completed, updating streak and time.
  Future<void> completeLesson({int minutes = 0}) async {
    profile.lessonsCompleted += 1;
    profile.totalPracticeMinutes += minutes;
    _recordStreak();
    profile.history.add(ActivityRecord(
      id: 'act-${DateTime.now().millisecondsSinceEpoch}',
      type: 'lesson',
      at: DateTime.now(),
      durationMinutes: minutes,
      detail: currentLesson?.title,
    ));
    // A completed lesson for a focus skill is a mild positive signal.
    final focus = _focusSkill();
    if (focus != null) {
      SkillTracker.applyOutcome(profile, focus, 0.7);
    }
    _generateLesson();
    await persist();
    notifyListeners();
  }

  SkillType? _focusSkill() {
    final assessment = currentLesson?.steps
        .where((s) => s.type == LessonStepType.assessment)
        .toList();
    if (assessment == null || assessment.isEmpty) return null;
    return assessment.first.skill;
  }

  // ---------- Assessment & practice outcomes ----------

  /// Applies an assessment result (0..3 or 0..1) for a skill.
  Future<void> applyAssessment(SkillType skill, int rating, {String? detail}) async {
    final score = rating / 3.0;
    SkillTracker.applyOutcome(profile, skill, score);
    profile.history.add(ActivityRecord(
      id: 'act-${DateTime.now().millisecondsSinceEpoch}',
      type: 'assessment',
      skill: skill,
      at: DateTime.now(),
      score: score,
      detail: detail,
    ));
    _recordStreak();
    _generateLesson();
    await persist();
    notifyListeners();
  }

  /// Records a practice session result, feeding the adaptive engine.
  Future<void> recordPractice({
    required SkillType skill,
    required double score,
    required int durationMinutes,
    String? detail,
    String? best,
  }) async {
    SkillTracker.applyOutcome(profile, skill, score);
    profile.totalPracticeMinutes += durationMinutes;
    profile.history.add(ActivityRecord(
      id: 'act-${DateTime.now().millisecondsSinceEpoch}',
      type: 'practice',
      skill: skill,
      at: DateTime.now(),
      score: score,
      durationMinutes: durationMinutes,
      detail: detail,
      best: best,
    ));
    _recordStreak();
    _generateLesson();
    await persist();
    notifyListeners();
  }

  void _recordStreak() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    if (profile.lastActivityDay == null) {
      profile.currentStreak = 1;
    } else {
      final last = DateTime(
          profile.lastActivityDay!.year, profile.lastActivityDay!.month, profile.lastActivityDay!.day);
      final diff = today.difference(last).inDays;
      if (diff == 0) {
        // same day, no change
      } else if (diff == 1) {
        profile.currentStreak += 1;
      } else {
        profile.currentStreak = 1;
      }
    }
    profile.lastActivityDay = today;
    if (profile.currentStreak > profile.bestStreak) {
      profile.bestStreak = profile.currentStreak;
    }
  }

  // ---------- Memorization / Hifz ----------

  void ensureMemorizationEntry(int surahNumber) {
    final surah = QuranDataset.byNumber(surahNumber);
    if (surah == null) return;
    if (!profile.memorization.containsKey(surahNumber)) {
      profile.memorization[surahNumber] = MemorizationEntry(
        surahNumber: surah.number,
        surahName: surah.englishName,
        totalAyahs: surah.ayahCount,
      );
    }
  }

  void markAyahMemorized(int surahNumber, int ayah) {
    ensureMemorizationEntry(surahNumber);
    final entry = profile.memorization[surahNumber]!;
    if (ayah >= 1 && ayah <= entry.totalAyahs && ayah > entry.memorizedAyahs) {
      entry.memorizedAyahs = ayah;
    }
    persist();
    notifyListeners();
  }

  void reviewMemorized(int surahNumber, {bool strong = false}) {
    final entry = profile.memorization[surahNumber];
    if (entry == null) return;
    entry.lastReviewed = DateTime.now();
    // Spaced repetition: strong → review later; weak → sooner.
    final delta = strong ? 3 : 1;
    entry.reviewIntervalDays = (entry.reviewIntervalDays + delta).clamp(1, 30);
    final skill = SkillType.revision;
    SkillTracker.applyOutcome(profile, skill, strong ? 0.85 : 0.5);
    _recordStreak();
    persist();
    notifyListeners();
  }

  // ---------- Reader progress ----------

  void saveJourneyPosition(int surahNumber, int ayahNumber) {
    final surah = QuranDataset.byNumber(surahNumber);
    if (surah != null) {
      profile.journeySurahName = surah.englishName;
      profile.journeySurahNumber = surahNumber;
    }
    persist();
    notifyListeners();
  }

  // ---------- Model manager hooks ----------

  Future<void> downloadModel(ModelOption option) async {
    // The real Whisper model downloads (once) from HuggingFace on first use.
    await voice.prepareModel();
    persist();
    notifyListeners();
  }

  Future<void> removeModel() async {
    if (voice is WhisperVoiceAnalysisService) {
      await (voice as WhisperVoiceAnalysisService).deleteModel();
    }
    persist();
    notifyListeners();
  }

  // ---------- Settings ----------

  void setThemeMode(ThemeMode mode) {
    themeMode = mode;
    notifyListeners();
  }

  void setNotificationsEnabled(bool enabled) {
    notificationsEnabled = enabled;
    notifyListeners();
  }

  // ---------- Data control ----------

  Future<void> resetAllData() async {
    profile = LearnerProfile();
    currentLesson = null;
    completedLessonIds.clear();
    masteryScores.clear();
    await _store.clearLearnerData();
    await _store.clearSurahLessonData();
    notifyListeners();
  }
}
