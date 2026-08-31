import 'package:flutter/widgets.dart';

import '../../data/models/skill_type.dart';
import '../../data/quran/quran_data.dart';
import '../../data/quran/quran_models.dart';
import '../../l10n/app_localizations.dart';

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
  PlacementEngine({List<PlacementItem>? pool}) : _pool = pool ?? buildPool();

  final List<PlacementItem> _pool;

  /// The items for the current assessment run.
  List<PlacementItem> get pool => _pool;

  static List<PlacementItem> buildPool([AppLocalizations? l]) {
    l ??= lookupAppLocalizations(const Locale('en'));
    return <PlacementItem>[
      // ---- READING ----
      PlacementItem(
        skill: SkillType.reading,
        difficulty: 1,
        prompt: l.plReadingLettersPrompt,
        options: [l.plYesRecognize, l.plSomeRecognize, l.plNotYet],
        correctIndex: 0,
      ),
      PlacementItem(
        skill: SkillType.reading,
        difficulty: 2,
        prompt: l.plReadingHarakatPrompt,
        options: [l.plYesComfortably, l.plWithEffort, l.plNotYet],
        correctIndex: 0,
      ),
      PlacementItem(
        skill: SkillType.reading,
        difficulty: 3,
        prompt: l.plReadingNoTranslitPrompt,
        options: [l.plYesFluently, l.plMostly, l.plNotYet],
        correctIndex: 0,
      ),
      // ---- TAJWEED ----
      PlacementItem(
        skill: SkillType.tajweed,
        difficulty: 1,
        prompt: l.plTajweedMaddPrompt,
        options: [l.plYes, l.plHeardOfIt, l.plNo],
        correctIndex: 0,
      ),
      PlacementItem(
        skill: SkillType.tajweed,
        difficulty: 2,
        prompt: l.plTajweedGhunnahPrompt,
        options: [l.plYes, l.plSomewhat, l.plNo],
        correctIndex: 0,
      ),
      PlacementItem(
        skill: SkillType.tajweed,
        difficulty: 3,
        prompt: l.plTajweedRulesPrompt,
        options: [l.plYesInDepth, l.plBriefly, l.plNo],
        correctIndex: 0,
      ),
      // ---- MEMORIZATION ----
      PlacementItem(
        skill: SkillType.memorization,
        difficulty: 1,
        prompt: l.plMemShortSurahsPrompt,
        options: [l.plManyMost, l.plAFew, l.plNoneYet],
        correctIndex: 0,
      ),
      PlacementItem(
        skill: SkillType.memorization,
        difficulty: 2,
        prompt: l.plMemFatihahPrompt,
        options: [l.plYesFully, l.plPartly, l.plNo],
        correctIndex: 0,
      ),
      // ---- COMPREHENSION ----
      PlacementItem(
        skill: SkillType.comprehension,
        difficulty: 1,
        prompt: l.plCompRabbPrompt,
        options: [l.plYes, l.plSomeRecognize, l.plNo],
        correctIndex: 0,
      ),
      PlacementItem(
        skill: SkillType.comprehension,
        difficulty: 2,
        prompt: l.plCompAlhamduPrompt,
        options: [l.plYes, l.plRoughly, l.plNo],
        correctIndex: 0,
      ),
    ];
  }

  /// A short, Quran-focused reading passage used with the voice practice.
  List<Ayah> readingPassage(int surah, int count) {
    final s = QuranDataset.byNumber(surah);
    if (s == null) return const [];
    return s.ayahs.take(count).toList();
  }
}
