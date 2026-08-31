import 'dart:ui';

/// Learning goals a learner can select during onboarding.
enum LearningGoal {
  readQuran('Learn to read the Qur’an', 'Start from the Arabic letters'),
  improveReading('Improve reading', 'Read more fluently'),
  tajweed('Learn Tajweed', 'Master the rules of correct recitation'),
  memorize('Memorize the Qur’an', 'Begin or advance your Hifz'),
  revise('Revise memorized Qur’an', 'Strengthen what you already know'),
  vocabulary('Understand vocabulary', 'Learn meanings and key words'),
  selectedSurahs('Learn selected Surahs', 'Focus on specific surahs'),
  regularStudy('Regular Qur’an study', 'Build a daily habit');

  const LearningGoal(this.label, this.subtitle);

  final String label;
  final String subtitle;
}

/// Self-reported reading level gathered during onboarding.
enum ReadingLevel {
  beginner('I’m a complete beginner', 'I don’t read Arabic yet'),
  letters('I know the letters', 'But can’t read connected words yet'),
  words('I can read words', 'Slowly, with effort'),
  fluent('I can read fluently', 'Quranic text, with or without harakat');

  const ReadingLevel(this.label, this.subtitle);

  final String label;
  final String subtitle;

  /// Normalized 0..1 starting reading ability.
  double get startingLevel => index / (ReadingLevel.values.length - 1);
}

/// Tajweed familiarity self-assessed during onboarding.
enum TajweedLevel {
  none('I don’t know it', ''),
  basics('I know the basics', 'Letters, madd, etc.'),
  good('I’ve studied it', 'I can apply most rules'),
  strong('I’m quite strong', 'Minor gaps only');

  const TajweedLevel(this.label, this.subtitle);

  final String label;
  final String subtitle;

  double get startingLevel => index / (TajweedLevel.values.length - 1);
}

/// How many surahs (or rough amount) the learner has memorized.
enum MemorizationLevel {
  none('None yet', ''),
  aLittle('A few surahs', 'e.g. the short ones'),
  some('Part of the Qur’an', 'e.g. some juz'),
  substantial('A substantial amount', 'A juz or more'),
  lots('Most or all', 'Nearly complete Hifz');

  const MemorizationLevel(this.label, this.subtitle);

  final String label;
  final String subtitle;

  double get startingLevel => index / (MemorizationLevel.values.length - 1);
}

/// How often the learner intends to practice.
enum PracticeFrequency {
  daily('Daily', 15),
  fewTimesWeek('3–4 times a week', 10),
  weekly('Weekly', 8),
  occasional('Occasionally', 5);

  const PracticeFrequency(this.label, this.minutesPerSession);

  final String label;
  final int minutesPerSession;
}

/// The full learner profile assembled during onboarding.
class OnboardingProfile {
  const OnboardingProfile({
    required this.locale,
    required this.goals,
    required this.readingLevel,
    required this.tajweedLevel,
    required this.memorizationLevel,
    required this.frequency,
    this.knownSurahs = const [],
    this.practicesDailyWeekly = 0,
  });

  final Locale locale;
  final List<LearningGoal> goals;
  final ReadingLevel readingLevel;
  final TajweedLevel tajweedLevel;
  final MemorizationLevel memorizationLevel;
  final PracticeFrequency frequency;
  final List<int> knownSurahs;

  /// Additional habit signal: days per week practiced (0..7).
  final int practicesDailyWeekly;

  Map<String, dynamic> toJson() => {
        'locale': locale.languageCode,
        'goals': goals.map((g) => g.name).toList(),
        'readingLevel': readingLevel.name,
        'tajweedLevel': tajweedLevel.name,
        'memorizationLevel': memorizationLevel.name,
        'frequency': frequency.name,
        'knownSurahs': knownSurahs,
        'practicesDailyWeekly': practicesDailyWeekly,
      };

  factory OnboardingProfile.fromJson(Map<String, dynamic> json) {
    final localeCode = json['locale'] as String? ?? 'en';

    LearningGoal goalByName(String n) =>
        LearningGoal.values.firstWhere((g) => g.name == n, orElse: () => LearningGoal.readQuran);
    ReadingLevel rByName(String n) => ReadingLevel.values
        .firstWhere((l) => l.name == n, orElse: () => ReadingLevel.beginner);
    TajweedLevel tByName(String n) => TajweedLevel.values
        .firstWhere((l) => l.name == n, orElse: () => TajweedLevel.none);
    MemorizationLevel mByName(String n) => MemorizationLevel.values
        .firstWhere((l) => l.name == n, orElse: () => MemorizationLevel.none);
    PracticeFrequency fByName(String n) => PracticeFrequency.values
        .firstWhere((l) => l.name == n, orElse: () => PracticeFrequency.daily);

    final rawGoals = (json['goals'] as List?)?.cast<String>() ?? const <String>[];

    return OnboardingProfile(
      locale: Locale(localeCode),
      goals: rawGoals.map(goalByName).toList(),
      readingLevel: rByName(json['readingLevel'] as String? ?? ''),
      tajweedLevel: tByName(json['tajweedLevel'] as String? ?? ''),
      memorizationLevel: mByName(json['memorizationLevel'] as String? ?? ''),
      frequency: fByName(json['frequency'] as String? ?? ''),
      knownSurahs: (json['knownSurahs'] as List?)?.cast<int>() ?? const [],
      practicesDailyWeekly: json['practicesDailyWeekly'] as int? ?? 0,
    );
  }
}
