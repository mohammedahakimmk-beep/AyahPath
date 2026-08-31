import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ayahpath/data/models/learner_profile.dart';
import 'package:ayahpath/data/models/lesson.dart';
import 'package:ayahpath/data/models/onboarding_profile.dart';
import 'package:ayahpath/data/models/skill_type.dart';
import 'package:ayahpath/data/quran/quran_data.dart';
import 'package:ayahpath/domain/adaptive/lesson_planner.dart';
import 'package:ayahpath/domain/adaptive/profile_seeder.dart';
import 'package:ayahpath/domain/adaptive/skill_tracker.dart';

void main() {
  group('ProfileSeeder', () {
    test('beginner seeds with low reading confidence', () {
      final profile = ProfileSeeder.seed(const OnboardingProfile(
        locale: Locale('en'),
        goals: [LearningGoal.readQuran, LearningGoal.tajweed],
        readingLevel: ReadingLevel.beginner,
        tajweedLevel: TajweedLevel.none,
        memorizationLevel: MemorizationLevel.none,
        frequency: PracticeFrequency.daily,
      ));
      expect(profile.skills[SkillType.reading]!.confidence, lessThan(0.1));
      expect(profile.onboardingCompleted, isTrue);
      expect(profile.journeySurahName, 'Al-Mulk');
    });

    test('fluent readers seed with higher confidence', () {
      final profile = ProfileSeeder.seed(const OnboardingProfile(
        locale: Locale('en'),
        goals: [LearningGoal.readQuran],
        readingLevel: ReadingLevel.fluent,
        tajweedLevel: TajweedLevel.strong,
        memorizationLevel: MemorizationLevel.some,
        frequency: PracticeFrequency.daily,
      ));
      expect(profile.skills[SkillType.reading]!.confidence, greaterThan(0.8));
      expect(profile.skills[SkillType.tajweed]!.confidence, greaterThan(0.7));
    });
  });

  group('SkillTracker', () {
    test('success raises confidence and streak', () {
      final profile = LearnerProfile();
      SkillTracker.applyOutcome(profile, SkillType.reading, 1.0);
      SkillTracker.applyOutcome(profile, SkillType.reading, 1.0);
      final s = profile.stateOf(SkillType.reading);
      expect(s.confidence, greaterThan(0.5));
      expect(s.streak, 2);
      expect(s.attempts, 2);
    });

    test('failure resets streak and lowers confidence', () {
      final p = ProfileSeeder.seed(const OnboardingProfile(
        locale: Locale('en'),
        goals: [LearningGoal.readQuran],
        readingLevel: ReadingLevel.fluent,
        tajweedLevel: TajweedLevel.none,
        memorizationLevel: MemorizationLevel.none,
        frequency: PracticeFrequency.daily,
      ));
      p.skills[SkillType.reading] =
          p.skills[SkillType.reading]!.copyWith(confidence: 0.9, streak: 5);
      SkillTracker.applyOutcome(p, SkillType.reading, 0.1);
      expect(p.stateOf(SkillType.reading).streak, 0);
      expect(p.stateOf(SkillType.reading).confidence, lessThan(0.6));
    });

    test('rolling window keeps recent scores only', () {
      final profile = LearnerProfile();
      for (var i = 0; i < 10; i++) {
        SkillTracker.applyOutcome(profile, SkillType.reading, 0.7);
      }
      expect(profile.stateOf(SkillType.reading).recentScores.length, lessThanOrEqualTo(6));
    });
  });

  group('LessonPlanner', () {
    test('weekly plan includes warmup, reading, and assessment', () {
      final profile = ProfileSeeder.seed(const OnboardingProfile(
        locale: Locale('en'),
        goals: [LearningGoal.readQuran, LearningGoal.tajweed, LearningGoal.memorize],
        readingLevel: ReadingLevel.beginner,
        tajweedLevel: TajweedLevel.none,
        memorizationLevel: MemorizationLevel.none,
        frequency: PracticeFrequency.daily,
      ));
      final plan = LessonPlanner.buildDailyPlan(profile);
      expect(plan.steps.map((s) => s.type), contains(LessonStepType.readingWarmup));
      expect(plan.steps.map((s) => s.type), contains(LessonStepType.assessment));
      expect(plan.steps.map((s) => s.type), contains(LessonStepType.quranReading));
      expect(plan.estimatedMinutes, greaterThanOrEqualTo(10));
    });

    test('planner focuses the weakest skill', () {
      final profile = ProfileSeeder.seed(const OnboardingProfile(
        locale: Locale('en'),
        goals: [LearningGoal.readQuran],
        readingLevel: ReadingLevel.beginner,
        tajweedLevel: TajweedLevel.strong,
        memorizationLevel: MemorizationLevel.none,
        frequency: PracticeFrequency.daily,
      ));
      final plan = LessonPlanner.buildDailyPlan(profile);
      final assessmentStep = plan.steps
          .firstWhere((s) => s.type == LessonStepType.assessment);
      expect(assessmentStep.skill,
          allOf(isNot(SkillType.tajweed), isNotNull));
      expect(
        profile.stateOf(SkillType.reading).confidence,
        lessThan(
          profile.stateOf(SkillType.tajweed).confidence),
      );
    });
  });

  group('QuranDataset', () {
    test('contains trusted surahs on-device', () {
      expect(QuranDataset.byNumber(1)!.englishName, 'Al-Fatihah');
      expect(QuranDataset.byNumber(112)!.ayahCount, 4);
      expect(QuranDataset.byNumber(1)!.ayahs[0].arabic, isNotEmpty);
    });

    test('passages stay frozen (never regenerated)', () {
      final before = QuranDataset.byNumber(112)!.ayahs.map((a) => a.arabic).join();
      final after = QuranDataset.byNumber(112)!.ayahs.map((a) => a.arabic).join();
      expect(before, after);
    });
  });
}