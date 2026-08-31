import 'skill_state.dart';
import 'skill_type.dart';
import 'activity_record.dart';
import 'onboarding_profile.dart';

/// A memorized surah held in the Hifz tracker.
class MemorizationEntry {
  MemorizationEntry({
    required this.surahNumber,
    required this.surahName,
    this.memorizedAyahs = 0,
    this.totalAyahs = 0,
    this.lastReviewed,
    this.reviewIntervalDays = 1,
  });

  final int surahNumber;
  final String surahName;
  int memorizedAyahs;
  int totalAyahs;
  DateTime? lastReviewed;

  /// Days before next review in the spaced-repetition schedule.
  int reviewIntervalDays;

  double get progress => totalAyahs == 0 ? 0 : memorizedAyahs / totalAyahs;

  bool get needsReview {
    if (lastReviewed == null) return memorizedAyahs > 0;
    return DateTime.now().difference(lastReviewed!).inDays >= reviewIntervalDays;
  }

  Map<String, dynamic> toJson() => {
        'surahNumber': surahNumber,
        'surahName': surahName,
        'memorizedAyahs': memorizedAyahs,
        'totalAyahs': totalAyahs,
        'lastReviewed': lastReviewed?.millisecondsSinceEpoch,
        'interval': reviewIntervalDays,
      };

  factory MemorizationEntry.fromJson(Map<String, dynamic> json) =>
      MemorizationEntry(
        surahNumber: json['surahNumber'] as int? ?? 0,
        surahName: json['surahName'] as String? ?? '',
        memorizedAyahs: json['memorizedAyahs'] as int? ?? 0,
        totalAyahs: json['totalAyahs'] as int? ?? 0,
        lastReviewed: json['lastReviewed'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(json['lastReviewed'] as int),
        reviewIntervalDays: json['interval'] as int? ?? 1,
      );
}

/// The evolving learner model that drives the adaptive learning engine.
class LearnerProfile {
  LearnerProfile({Map<SkillType, SkillState>? skills, this.onboarding})
      : skills = skills ?? _initialSkills();

  OnboardingProfile? onboarding;
  Map<SkillType, SkillState> skills;

  final List<ActivityRecord> history = [];

  // Memorization tracking (Hifz).
  final Map<int, MemorizationEntry> memorization = {};

  // Habits & progress.
  int currentStreak = 0;
  int bestStreak = 0;
  DateTime? lastActivityDay;
  int lessonsCompleted = 0;
  int totalPracticeMinutes = 0;
  bool onboardingCompleted = false;
  bool placementCompleted = false;
  bool onboardingSkipped = false;

  String? journeySurahName;
  int journeySurahNumber = 0;

  static Map<SkillType, SkillState> _initialSkills() => {
        for (final s in SkillType.values) s: const SkillState(),
      };

  SkillState stateOf(SkillType skill) => skills[skill] ?? const SkillState();

  double get overallProgress {
    if (skills.isEmpty) return 0;
    final sum = skills.values.fold<double>(0, (acc, s) => acc + s.confidence);
    return sum / skills.length;
  }

  /// 0..1 skill progression sum used on the home dashboard.
  double get journeyProgress {
    final weights = {
      SkillType.reading: 0.25,
      SkillType.tajweed: 0.25,
      SkillType.memorization: 0.2,
      SkillType.revision: 0.15,
      SkillType.comprehension: 0.15,
    };
    double acc = 0;
    weights.forEach((k, w) => acc += stateOf(k).confidence * w);
    return acc;
  }

  List<SkillType> skillsNeedingPractice() {
    final list = skills.entries.where((e) => e.value.needsPractice).map((e) => e.key).toList();
    list.sort((a, b) => stateOf(a).confidence.compareTo(stateOf(b).confidence));
    return list;
  }

  List<MemorizationEntry> surahsNeedingReview() => memorization.values
      .where((m) => m.needsReview && m.memorizedAyahs > 0)
      .toList()
    ..sort((a, b) => b.reviewIntervalDays.compareTo(a.reviewIntervalDays));

  int get totalMemorizedAyahs =>
      memorization.values.fold(0, (s, m) => s + m.memorizedAyahs);

  Map<String, dynamic> toJson() => {
        'onboarding':
            onboarding == null ? null : (onboarding!.toJson() as dynamic),
        'skills': {
          for (final e in skills.entries) e.key.name: e.value.toJson(),
        },
        'history': history.map((h) => h.toJson()).toList(),
        'memorization': {
          for (final e in memorization.entries) e.key.toString(): e.value.toJson(),
        },
        'currentStreak': currentStreak,
        'bestStreak': bestStreak,
        'lastActivityDay': lastActivityDay?.millisecondsSinceEpoch,
        'lessonsCompleted': lessonsCompleted,
        'totalPracticeMinutes': totalPracticeMinutes,
        'onboardingCompleted': onboardingCompleted,
        'placementCompleted': placementCompleted,
        'onboardingSkipped': onboardingSkipped,
        'journeySurahName': journeySurahName,
        'journeySurahNumber': journeySurahNumber,
      };

  factory LearnerProfile.fromJson(Map<String, dynamic> json) {
    final skills = <SkillType, SkillState>{};
    (json['skills'] as Map?)?.forEach((k, v) {
      final skill =
          SkillType.values.firstWhere((e) => e.name == k, orElse: () => SkillType.reading);
      skills[skill] = SkillState.fromJson(v as Map<String, dynamic>);
    });
    final profile = LearnerProfile(skills: skills.isEmpty ? null : skills);
    profile.onboarding = json['onboarding'] == null
        ? null
        : OnboardingProfile.fromJson(json['onboarding'] as Map<String, dynamic>);
    profile.history.addAll((json['history'] as List?)?.map(
          (e) => ActivityRecord.fromJson(e as Map<String, dynamic>),
        ) ??
        const <ActivityRecord>[]);
    (json['memorization'] as Map?)?.forEach((k, v) {
      profile.memorization[int.parse(k.toString())] =
          MemorizationEntry.fromJson(v as Map<String, dynamic>);
    });
    profile.currentStreak = json['currentStreak'] as int? ?? 0;
    profile.bestStreak = json['bestStreak'] as int? ?? 0;
    profile.lastActivityDay = json['lastActivityDay'] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(json['lastActivityDay'] as int);
    profile.lessonsCompleted = json['lessonsCompleted'] as int? ?? 0;
    profile.totalPracticeMinutes = json['totalPracticeMinutes'] as int? ?? 0;
    profile.onboardingCompleted = json['onboardingCompleted'] as bool? ?? false;
    profile.placementCompleted = json['placementCompleted'] as bool? ?? false;
    profile.onboardingSkipped = json['onboardingSkipped'] as bool? ?? false;
    profile.journeySurahName = json['journeySurahName'] as String?;
    profile.journeySurahNumber = json['journeySurahNumber'] as int? ?? 0;
    return profile;
  }
}
