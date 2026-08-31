import '../../data/models/skill_type.dart';
import '../../data/quran/quran_data.dart';
import '../../data/quran/quran_models.dart';

/// A single placement question/activity.
class PlacementItem {
  const PlacementItem({
    required this.skill,
    required this.prompt,
    this.options,
    this.correctIndex,
    this.surahNumber,
    this.ayahNumber,
    this.difficulty = 1,
  });

  final SkillType skill;

  /// Question/instruction shown to the learner.
  final String prompt;

  /// Optional multiple-choice options. If null, the item is an
  /// "I can do this / I struggle" style self/recognition check.
  final List<String>? options;
  final int? correctIndex;

  /// Referenced ayah for reading-style items.
  final int? surahNumber;
  final int? ayahNumber;

  /// 1 = beginner, 2 = intermediate, 3 = advanced.
  final int difficulty;
}

/// Result of a placement run.
class PlacementResult {
  const PlacementResult({
    required this.completed,
    this.itemsAnswered = 0,
    this.skillScores = const {},
    this.startingLevel,
  });

  final bool completed;
  final int itemsAnswered;
  final Map<SkillType, double> skillScores;
  final double? startingLevel;
}

/// Builds and adapts the placement assessment.
///
/// Difficulty adapts based on the learner's answers: correct answers push
/// difficulty up, mistakes pull it back down. Never overwhelms beginners.
class PlacementEngine {
  PlacementEngine({List<PlacementItem>? pool}) : _pool = pool ?? defaultPool;

  final List<PlacementItem> _pool;

  /// The items for the current assessment run.
  List<PlacementItem> get pool => _pool;

  static final List<PlacementItem> defaultPool = <PlacementItem>[
    // ---- READING ----
    const PlacementItem(
      skill: SkillType.reading,
      difficulty: 1,
      prompt: 'Can you recognize these letters:',
      options: ['Yes, I recognize them', 'Some of them', 'Not yet'],
      correctIndex: 0,
    ),
    const PlacementItem(
      skill: SkillType.reading,
      difficulty: 2,
      prompt: 'Do you read words with harakat comfortably?',
      options: ['Yes, comfortably', 'With effort', 'Not yet'],
      correctIndex: 0,
    ),
    const PlacementItem(
      skill: SkillType.reading,
      difficulty: 3,
      prompt: 'Can you read Quranic text without transliteration?',
      options: ['Yes, fluently', 'Mostly', 'Not yet'],
      correctIndex: 0,
    ),
    // ---- TAJWEED ----
    const PlacementItem(
      skill: SkillType.tajweed,
      difficulty: 1,
      prompt: 'Do you know what madd (elongation) means?',
      options: ['Yes', 'I’ve heard of it', 'No'],
      correctIndex: 0,
    ),
    const PlacementItem(
      skill: SkillType.tajweed,
      difficulty: 2,
      prompt: 'Can you identify ghunnah (nasal sound) in your recitation?',
      options: ['Yes', 'Somewhat', 'No'],
      correctIndex: 0,
    ),
    const PlacementItem(
      skill: SkillType.tajweed,
      difficulty: 3,
      prompt: 'Have you studied rules like qalqalah and ikhfa?',
      options: ['Yes, in depth', 'Briefly', 'No'],
      correctIndex: 0,
    ),
    // ---- MEMORIZATION ----
    const PlacementItem(
      skill: SkillType.memorization,
      difficulty: 1,
      prompt: 'How many short surahs can you recite from memory?',
      options: ['Many / most', 'A few', 'None yet'],
      correctIndex: 0,
    ),
    const PlacementItem(
      skill: SkillType.memorization,
      difficulty: 2,
      prompt: 'Can you continue Al-Fatihah from memory to completion?',
      options: ['Yes, fully', 'Partly', 'No'],
      correctIndex: 0,
    ),
    // ---- COMPREHENSION ----
    const PlacementItem(
      skill: SkillType.comprehension,
      difficulty: 1,
      prompt: 'Do you understand common Quranic words like "رَبّ" (Lord)?',
      options: ['Yes', 'Some', 'No'],
      correctIndex: 0,
    ),
    const PlacementItem(
      skill: SkillType.comprehension,
      difficulty: 2,
      prompt: 'Can you explain the meaning of "Alhamdu lillah"?',
      options: ['Yes', 'Roughly', 'No'],
      correctIndex: 0,
    ),
  ];

  /// A short, Quran-focused reading passage used with the voice practice.
  List<Ayah> readingPassage(int surah, int count) {
    final s = QuranDataset.byNumber(surah);
    if (s == null) return const [];
    return s.ayahs.take(count).toList();
  }
}
