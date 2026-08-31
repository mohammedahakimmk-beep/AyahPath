import 'dart:math';
import 'dart:ui' show Locale;

import '../../data/models/learner_profile.dart';
import '../../data/models/lesson.dart';
import '../../data/models/onboarding_profile.dart';
import '../../data/models/skill_type.dart';
import '../../data/quran/quran_data.dart';
import '../../l10n/app_localizations.dart';
import 'skill_tracker.dart';

/// Generates personalized lesson plans from the learner model.
///
/// Pattern:
///  Reading warm-up → focus skill practice → Qur'an reading → memorization/
///  revision → short assessment. Focus shifts toward weaker skills and away
///  from mastered ones. Difficulty rises as confidence does.
class LessonPlanner {
  LessonPlanner._();

  /// Builds today's lesson tailored to [profile].
  static LessonPlan buildDailyPlan(LearnerProfile profile, [AppLocalizations? l]) {
    final loc = l ?? lookupAppLocalizations(const Locale('en'));
    final goals = profile.onboarding?.goals ?? const [LearningGoal.readQuran];
    final wantsTajweed = goals.contains(LearningGoal.tajweed) ||
        profile.stateOf(SkillType.tajweed).needsPractice;
    final wantsMemorization = goals.contains(LearningGoal.memorize) ||
        goals.contains(LearningGoal.revise) ||
        goals.contains(LearningGoal.regularStudy);

    // Choose a focus skill: weakest among active skills.
    final active = <SkillType>{
      SkillType.reading,
      if (wantsTajweed) SkillType.tajweed,
      if (wantsMemorization) SkillType.memorization,
      SkillType.revision,
      if (goals.contains(LearningGoal.vocabulary)) SkillType.comprehension,
    }.toList();

    SkillType focus = _weakest(profile, active);
    final focusDifficulty = SkillTracker.difficultyFor(profile.stateOf(focus).confidence);

    final steps = <LessonStep>[];

    steps.add(_warmup(profile, loc));

    // Targeted practice for the focus skill.
    steps.add(_focusStep(focus, focusDifficulty, profile, loc));

    // Qur'an reading step (always present).
    final passage = _journeyRange(profile);
    steps.add(LessonStep(
      type: LessonStepType.quranReading,
      title: _passageTitle(passage, loc),
      instructions: loc.planReadAloud,
      ayahlRange: passage,
      durationMinutes: 4,
    ));

    // Memorization or revision depending on needs.
    if (wantsMemorization) {
      steps.add(_memorizationStep(profile, loc));
    }
    if (wantsTajweed && profile.stateOf(SkillType.tajweed).confidence >= 0.45) {
      steps.add(LessonStep(
        type: LessonStepType.tajweedPractice,
        title: loc.planTajweedFocus(_tajweedTopic(focusDifficulty, loc)),
        instructions: loc.planTajweedInstr,
        skill: SkillType.tajweed,
        durationMinutes: 3,
        prompt: _tajweedPrompt(focusDifficulty, loc),
      ));
    }

    // Closing assessment on the focus skill.
    steps.add(LessonStep(
      type: LessonStepType.assessment,
      title: loc.planQuickCheck(focus.localizedLabel(loc)),
      instructions: loc.planAssessmentInstr,
      skill: focus,
      prompt: _assessmentPrompt(focus, focusDifficulty, loc),
      durationMinutes: 2,
    ));

    final now = DateTime.now();
    return LessonPlan(
      id: 'lesson-${now.millisecondsSinceEpoch}',
      title: loc.planTitle,
      createdAt: now,
      estimatedMinutes: steps.fold(0, (s, e) => s + e.durationMinutes),
      steps: steps,
      dateLabel: '${now.day}/${now.month}/${now.year}',
    );
  }

  static SkillType _weakest(LearnerProfile profile, List<SkillType> active) {
    SkillType weakest = active.isNotEmpty ? active.first : SkillType.reading;
    double minConf = 1.1;
    for (final s in active) {
      final c = profile.stateOf(s).confidence;
      if (c < minConf) {
        minConf = c;
        weakest = s;
      }
    }
    return weakest;
  }

  static LessonStep _warmup(LearnerProfile profile, AppLocalizations loc) {
    final readingConf = profile.stateOf(SkillType.reading).confidence;
    if (readingConf < 0.35) {
      return LessonStep(
        type: LessonStepType.readingWarmup,
        title: loc.planWarmupLetters,
        instructions: loc.planWarmupLettersInstr,
        durationMinutes: 2,
      );
    }
    return LessonStep(
      type: LessonStepType.readingWarmup,
      title: readingConf < 0.7 ? loc.planWarmupReading : loc.planWarmupFluency,
      instructions: loc.planWarmupInstr,
      durationMinutes: 2,
    );
  }

  static LessonStep _focusStep(
      SkillType focus, int difficulty, LearnerProfile profile, AppLocalizations loc) {
    final list = _focusTitles(focus, loc);
    return LessonStep(
      type: focus == SkillType.tajweed
          ? LessonStepType.tajweedPractice
          : focus == SkillType.memorization || focus == SkillType.revision
              ? LessonStepType.memorization
              : LessonStepType.readingWarmup,
      title: list[difficulty - 1],
      instructions: loc.planFocusInstr,
      skill: focus,
      durationMinutes: 3,
    );
  }

  static List<String> _focusTitles(SkillType focus, AppLocalizations loc) {
    switch (focus) {
      case SkillType.reading:
        return [loc.planFocusReading1, loc.planFocusReading2, loc.planFocusReading3];
      case SkillType.tajweed:
        return [loc.planFocusTajweed1, loc.planFocusTajweed2, loc.planFocusTajweed3];
      case SkillType.memorization:
        return [loc.planFocusMemo1, loc.planFocusMemo2, loc.planFocusMemo3];
      case SkillType.revision:
        return [loc.planFocusRevision1, loc.planFocusRevision2, loc.planFocusRevision3];
      case SkillType.comprehension:
        return [loc.planFocusCompre1, loc.planFocusCompre2, loc.planFocusCompre3];
      case SkillType.fluency:
        return [loc.planFocusFluency1, loc.planFocusFluency2, loc.planFocusFluency3];
    }
  }

  static LessonStep _memorizationStep(LearnerProfile profile, AppLocalizations loc) {
    final conf = profile.stateOf(SkillType.memorization).confidence;
    if (conf < 0.4) {
      return LessonStep(
        type: LessonStepType.memorization,
        title: loc.planMemoStart,
        instructions: loc.planMemoStartInstr,
        skill: SkillType.memorization,
        durationMinutes: 3,
      );
    }
    return LessonStep(
      type: LessonStepType.memorization,
      title: loc.planMemoReview,
      instructions: loc.planMemoReviewInstr,
      skill: SkillType.memorization,
      durationMinutes: 3,
    );
  }

  static String _journeyRange(LearnerProfile profile) {
    final surah = profile.journeySurahNumber != 0
        ? QuranDataset.byNumber(profile.journeySurahNumber)
        : QuranDataset.byNumber(114);
    if (surah == null) return '1:1-7';
    final count = min(5, surah.ayahCount);
    return '${surah.number}:1-$count';
  }

  static String _passageTitle(String range, AppLocalizations loc) {
    final parts = range.split(':');
    final s = parts.isNotEmpty ? QuranDataset.byNumber(int.tryParse(parts[0]) ?? 1) : null;
    return s == null ? loc.planQuranReading : loc.planReadingSurah(s.englishName);
  }

  static String _tajweedTopic(int difficulty, AppLocalizations loc) {
    switch (difficulty) {
      case 1:
        return loc.planTajweedTopic1;
      case 2:
        return loc.planTajweedTopic2;
      default:
        return loc.planTajweedTopic3;
    }
  }

  static String _tajweedPrompt(int difficulty, AppLocalizations loc) {
    switch (difficulty) {
      case 1:
        return loc.planTajweedPrompt1;
      case 2:
        return loc.planTajweedPrompt2;
      default:
        return loc.planTajweedPrompt3;
    }
  }

  static String _assessmentPrompt(SkillType skill, int difficulty, AppLocalizations loc) {
    switch (skill) {
      case SkillType.reading:
        return difficulty >= 3
            ? loc.planAssessReadingHi
            : loc.planAssessReadingLo;
      case SkillType.tajweed:
        return loc.planAssessTajweed;
      case SkillType.memorization:
        return loc.planAssessMemo;
      case SkillType.revision:
        return loc.planAssessRevision;
      case SkillType.comprehension:
        return loc.planAssessCompre;
      case SkillType.fluency:
        return loc.planAssessFluency;
    }
  }

  /// Turns an assessment rating (0..3) into a 0..1 score.
  static double ratingToScore(int rating) => (rating / 3).clamp(0.0, 1.0);
}
