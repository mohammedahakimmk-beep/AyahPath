import '../../data/models/learner_profile.dart';
import '../../data/models/onboarding_profile.dart';
import '../../data/models/skill_state.dart';
import '../../data/models/skill_type.dart';
import 'skill_tracker.dart';

/// Seeds a fresh [LearnerProfile] from onboarding self-assessments.
///
/// Converts subjective answers into initial confidences so the lesson planner
/// has a warm start before any placement/assessment data arrives.
class ProfileSeeder {
  ProfileSeeder._();

  static LearnerProfile seed(OnboardingProfile onboarding) {
    final profile = LearnerProfile(onboarding: onboarding);
    profile.onboardingCompleted = true;
    profile.journeySurahName = AppDefault.journeySurah;
    profile.journeySurahNumber = AppDefault.journeySurahNumber;

    final readLevel = onboarding.readingLevel.startingLevel;
    final tajweedLevel = onboarding.tajweedLevel.startingLevel;
    final memLevel = onboarding.memorizationLevel.startingLevel;

    profile.skills[SkillType.reading] = SkillState(
      confidence: SkillTracker.startingConfidence(readLevel),
      mastery: SkillTracker.startingConfidence(readLevel) * 0.9,
    );
    profile.skills[SkillType.tajweed] = SkillState(
      confidence: SkillTracker.startingConfidence(tajweedLevel),
      mastery: SkillTracker.startingConfidence(tajweedLevel) * 0.9,
    );
    profile.skills[SkillType.memorization] = SkillState(
      confidence: SkillTracker.startingConfidence(memLevel),
      mastery: SkillTracker.startingConfidence(memLevel) * 0.9,
    );
    profile.skills[SkillType.revision] = SkillState(
      confidence: SkillTracker.startingConfidence(memLevel),
    );

    return profile;
  }
}

class AppDefault {
  AppDefault._();
  static const String journeySurah = 'An-Nas';
  static const int journeySurahNumber = 114;
}
