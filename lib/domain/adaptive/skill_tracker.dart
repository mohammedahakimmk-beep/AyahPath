import '../../data/models/learner_profile.dart';
import '../../data/models/skill_state.dart';
import '../../data/models/skill_type.dart';

/// Rolling window length for recent assessment scores.
const int kRecentWindow = 6;

/// Applies assessment/practice outcomes to the learner model.
///
/// This is the "adaptive learning engine": struggling lowers confidence and
/// adds targeted practice; success raises confidence and increases difficulty.
///
/// Feedback loop: outcome -> confidence/mastery update -> future lesson focus.
class SkillTracker {
  SkillTracker._();

  /// Applies a scored outcome (0..1) for a skill.
  static void applyOutcome(LearnerProfile profile, SkillType skill, double score) {
    final current = profile.skills[skill] ?? const SkillState();
    final clamped = score.clamp(0.0, 1.0);
    final correctBinary = clamped >= 0.6 ? 1 : 0;

    final running = [...current.recentScores, clamped];
    final recent = running.length > kRecentWindow
        ? running.sublist(running.length - kRecentWindow)
        : running;

    final recentAvg = recent.isEmpty ? 0.0 : recent.reduce((a, b) => a + b) / recent.length;

    // Confidence moves toward recent performance.
    final nextConfidence = (current.confidence * 0.35 + recentAvg * 0.65).clamp(0.0, 1.0);

    // Mastery is a slower-moving EMA.
    final nextMastery = (current.mastery * 0.8 + recentAvg * 0.2).clamp(0.0, 1.0);

    final nextStreak = correctBinary == 1 ? current.streak + 1 : 0;

    profile.skills[skill] = SkillState(
      confidence: nextConfidence,
      mastery: nextMastery,
      attempts: current.attempts + 1,
      correct: current.correct + correctBinary,
      streak: nextStreak,
      developing: nextConfidence < 0.8,
      recentScores: recent,
    );
  }

  /// Difficulty level (1..3) for lesson planning based on confidence.
  static int difficultyFor(double confidence) {
    if (confidence >= 0.75) return 3;
    if (confidence >= 0.5) return 2;
    return 1;
  }

  /// Seeds a starting confidence (0..~0.85) from onboarding self-assessment.
  static double startingConfidence(double level) => (level * 0.9 + 0.05).clamp(0.0, 0.85);

  /// Recent-performance summary for a skill (for UI).
  static RecentPerformance summary(SkillState s) => RecentPerformance(
        average: s.recentScores.isEmpty
            ? s.confidence
            : s.recentScores.reduce((a, b) => a + b) / s.recentScores.length,
        trend: s.recentScores.length < 2
            ? 0
            : s.recentScores[s.recentScores.length - 1] -
                s.recentScores[s.recentScores.length - 2],
        attempts: s.attempts,
      );
}

class RecentPerformance {
  const RecentPerformance({
    required this.average,
    required this.trend,
    required this.attempts,
  });

  final double average;
  final double trend;
  final int attempts;
}
