import 'dart:math';

import '../../data/models/learner_profile.dart';
import '../../data/models/lesson.dart';
import '../../data/models/onboarding_profile.dart';
import '../../data/models/skill_type.dart';
import '../../data/quran/quran_data.dart';
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
  static LessonPlan buildDailyPlan(LearnerProfile profile) {
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

    steps.add(_warmup(profile));

    // Targeted practice for the focus skill.
    steps.add(_focusStep(focus, focusDifficulty, profile));

    // Qur'an reading step (always present).
    final passage = _journeyRange(profile);
    steps.add(LessonStep(
      type: LessonStepType.quranReading,
      title: _passageTitle(passage),
      instructions: 'Read aloud slowly and clearly. Listen carefully to each word.',
      ayahlRange: passage,
      durationMinutes: 4,
    ));

    // Memorization or revision depending on needs.
    if (wantsMemorization) {
      steps.add(_memorizationStep(profile));
    }
    if (wantsTajweed && profile.stateOf(SkillType.tajweed).confidence >= 0.45) {
      steps.add(LessonStep(
        type: LessonStepType.tajweedPractice,
        title: 'Tajweed focus: ${_tajweedTopic(focusDifficulty)}',
        instructions:
            'Practice the selected rule gently. If unsure, tap "Ask the tutor" for guidance.',
        skill: SkillType.tajweed,
        durationMinutes: 3,
        prompt: _tajweedPrompt(focusDifficulty),
      ));
    }

    // Closing assessment on the focus skill.
    steps.add(LessonStep(
      type: LessonStepType.assessment,
      title: 'Quick check: ${focus.label}',
      instructions:
          'Answer a short question to help AyahPath adjust tomorrow’s lesson.',
      skill: focus,
      prompt: _assessmentPrompt(focus, focusDifficulty),
      durationMinutes: 2,
    ));

    final now = DateTime.now();
    return LessonPlan(
      id: 'lesson-${now.millisecondsSinceEpoch}',
      title: 'Today’s Lesson',
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

  static LessonStep _warmup(LearnerProfile profile) {
    final readingConf = profile.stateOf(SkillType.reading).confidence;
    if (readingConf < 0.35) {
      return const LessonStep(
        type: LessonStepType.readingWarmup,
        title: 'Letter warm-up',
        instructions:
            'Review the Arabic letters you find most challenging. Say each one slowly.',
        durationMinutes: 2,
      );
    }
    return LessonStep(
      type: LessonStepType.readingWarmup,
      title: readingConf < 0.7 ? 'Reading warm-up' : 'Fluency warm-up',
      instructions:
          'Read a short passage from your current surah at a gentle pace, then once a little faster.',
      durationMinutes: 2,
    );
  }

  static LessonStep _focusStep(SkillType focus, int difficulty, LearnerProfile profile) {
    const titles = {
      SkillType.reading: [
        'Letters & sounds',
        'Reading words with harakat',
        'Reading Qur’anic phrases',
      ],
      SkillType.tajweed: [
        'Tajweed foundations',
        'Practicing madd & ghunnah',
        'Advanced tajweed rules',
      ],
      SkillType.memorization: [
        'Introducing a new ayah',
        'Building on today’s ayahs',
        'Strengthening your Hifz',
      ],
      SkillType.revision: [
        'Refreshing what you know',
        'Revision & linking ayahs',
        'Deep revision session',
      ],
      SkillType.comprehension: [
        'Key words & meaning',
        'Understanding phrases',
        'Exploring meaning deeply',
      ],
    };
    final list = titles[focus] ?? const ['Focused practice', 'Practice', 'Advanced practice'];
    return LessonStep(
      type: focus == SkillType.tajweed
          ? LessonStepType.tajweedPractice
          : focus == SkillType.memorization || focus == SkillType.revision
              ? LessonStepType.memorization
              : LessonStepType.readingWarmup,
      title: list[difficulty - 1],
      instructions:
          'Follow along with the provided exercise. Practice until it feels smooth.',
      skill: focus,
      durationMinutes: 3,
    );
  }

  static LessonStep _memorizationStep(LearnerProfile profile) {
    final conf = profile.stateOf(SkillType.memorization).confidence;
    if (conf < 0.4) {
      return const LessonStep(
        type: LessonStepType.memorization,
        title: 'Start memorizing',
        instructions:
            'Hear an ayah, then repeat it 3 times. Try to say it from memory once.',
        skill: SkillType.memorization,
        durationMinutes: 3,
      );
    }
    return const LessonStep(
      type: LessonStepType.memorization,
      title: 'Memorization & revision',
      instructions:
          'Recite your recent ayahs from memory, then add one new line using spaced repetition.',
      skill: SkillType.memorization,
      durationMinutes: 3,
    );
  }

  static String _journeyRange(LearnerProfile profile) {
    final surah = profile.journeySurahNumber != 0
        ? QuranDataset.byNumber(profile.journeySurahNumber)
        : QuranDataset.byNumber(67);
    if (surah == null) return '1:1-7';
    final count = min(5, surah.ayahCount);
    return '${surah.number}:1-$count';
  }

  static String _passageTitle(String range) {
    final parts = range.split(':');
    final s = parts.isNotEmpty ? QuranDataset.byNumber(int.tryParse(parts[0]) ?? 1) : null;
    return s == null ? 'Qur’an reading' : 'Reading ${s.englishName}';
  }

  static String _tajweedTopic(int difficulty) {
    const topics = ['basic madd', 'madd and ghunnah', 'qalqalah and ikhfa'];
    return topics[difficulty - 1];
  }

  static String _tajweedPrompt(int difficulty) {
    const prompts = [
      'Which letter brings a natural elongation (madd)?',
      'Which rule produces a nasal sound (ghunnah)?',
      'Which term refers to a voicing bounce (qalqalah)?',
    ];
    return prompts[difficulty - 1];
  }

  static String _assessmentPrompt(SkillType skill, int difficulty) {
    switch (skill) {
      case SkillType.reading:
        return difficulty >= 3
            ? 'How would you rate your smoothness reading today’s ayah?'
            : 'Could you read today’s words clearly?';
      case SkillType.tajweed:
        return 'How well did you apply today’s tajweed rule?';
      case SkillType.memorization:
        return 'How much of today’s memorization can you recall?';
      case SkillType.revision:
        return 'How confidently did you revise today?';
      case SkillType.comprehension:
        return 'Could you explain today’s key words?';
      case SkillType.fluency:
        return 'How fluent did today’s reading feel?';
    }
  }

  /// Turns an assessment rating (0..3) into a 0..1 score.
  static double ratingToScore(int rating) => (rating / 3).clamp(0.0, 1.0);
}
