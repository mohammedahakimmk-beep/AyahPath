/// A single skill's tracked state over time.
class SkillState {
  const SkillState({
    this.confidence = 0.0,
    this.mastery = 0.0,
    this.attempts = 0,
    this.correct = 0,
    this.streak = 0,
    this.developing = true,
    this.recentScores = const [],
  });

  /// Latest confidence (0..1). Drives lesson planning and adaptive changes.
  final double confidence;

  /// Long-run mastery estimate (0..1).
  final double mastery;

  /// Total assessment attempts for this skill.
  final int attempts;

  /// Total correct assessment answers for this skill.
  final int correct;

  /// Consecutive successful practices (resets on failure).
  final int streak;

  /// Whether the skill is still "developing" vs "mastered".
  final bool developing;

  /// Rolling window of recent assessment scores (most recent last).
  final List<double> recentScores;

  double get accuracy => attempts == 0 ? 0 : correct / attempts;

  bool get needsPractice => confidence < 0.55;

  bool get mastered => confidence >= 0.85 && streak >= 3;

  SkillState copyWith({
    double? confidence,
    double? mastery,
    int? attempts,
    int? correct,
    int? streak,
    bool? developing,
    List<double>? recentScores,
  }) {
    return SkillState(
      confidence: confidence ?? this.confidence,
      mastery: mastery ?? this.mastery,
      attempts: attempts ?? this.attempts,
      correct: correct ?? this.correct,
      streak: streak ?? this.streak,
      developing: developing ?? this.developing,
      recentScores: recentScores ?? this.recentScores,
    );
  }

  Map<String, dynamic> toJson() => {
        'confidence': confidence,
        'mastery': mastery,
        'attempts': attempts,
        'correct': correct,
        'streak': streak,
        'developing': developing,
        'recent': recentScores,
      };

  factory SkillState.fromJson(Map<String, dynamic> json) => SkillState(
        confidence: (json['confidence'] as num?)?.toDouble() ?? 0,
        mastery: (json['mastery'] as num?)?.toDouble() ?? 0,
        attempts: json['attempts'] as int? ?? 0,
        correct: json['correct'] as int? ?? 0,
        streak: json['streak'] as int? ?? 0,
        developing: json['developing'] as bool? ?? true,
        recentScores:
            (json['recent'] as List?)?.map((e) => (e as num).toDouble()).toList() ??
                const [],
      );
}
