import 'skill_type.dart';

/// Type of a single lesson step.
enum LessonStepType {
  readingWarmup('Reading warm-up'),
  tajweedPractice('Tajweed practice'),
  quranReading('Qur’an reading'),
  memorization('Memorization'),
  revision('Revision'),
  comprehension('Vocabulary & meaning'),
  assessment('Short assessment');

  const LessonStepType(this.label);

  final String label;
}

/// A single step in a lesson.
class LessonStep {
  const LessonStep({
    required this.type,
    required this.title,
    required this.instructions,
    this.skill,
    this.ayahlRange,
    this.durationMinutes = 3,
    this.prompt,
  });

  final LessonStepType type;
  final String title;
  final String instructions;

  /// Primary skill this step targets (for assessment steps).
  final SkillType? skill;

  /// Optional "surah:fromAyah-toAyah" reference, e.g. "67:1-4".
  final String? ayahlRange;

  final int durationMinutes;

  /// For practice/assessment: optional question prompt or exercise text.
  final String? prompt;

  Map<String, dynamic> toJson() => {
        'type': type.name,
        'title': title,
        'instructions': instructions,
        'skill': skill?.name,
        'range': ayahlRange,
        'durationMinutes': durationMinutes,
        'prompt': prompt,
      };

  factory LessonStep.fromJson(Map<String, dynamic> json) {
    LessonStepType t(String n) =>
        LessonStepType.values.firstWhere((e) => e.name == n, orElse: () => LessonStepType.readingWarmup);
    SkillType? s(String? n) =>
        n == null ? null : SkillType.values.firstWhere((e) => e.name == n, orElse: () => SkillType.reading);
    return LessonStep(
      type: t(json['type'] as String? ?? ''),
      title: json['title'] as String? ?? '',
      instructions: json['instructions'] as String? ?? '',
      skill: s(json['skill'] as String?),
      ayahlRange: json['range'] as String?,
      durationMinutes: json['durationMinutes'] as int? ?? 3,
      prompt: json['prompt'] as String?,
    );
  }
}

/// A personalized lesson plan for a given day.
class LessonPlan {
  const LessonPlan({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.estimatedMinutes,
    required this.steps,
    this.dateLabel,
  });

  final String id;
  final String title;
  final DateTime createdAt;
  final int estimatedMinutes;
  final List<LessonStep> steps;
  final String? dateLabel;

  int get totalDurationMinutes => steps.fold(0, (s, e) => s + e.durationMinutes);

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'createdAt': createdAt.millisecondsSinceEpoch,
        'estimatedMinutes': estimatedMinutes,
        'steps': steps.map((s) => s.toJson()).toList(),
        'dateLabel': dateLabel,
      };

  factory LessonPlan.fromJson(Map<String, dynamic> json) => LessonPlan(
        id: json['id'] as String? ?? '',
        title: json['title'] as String? ?? '',
        createdAt:
            DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int? ?? 0),
        estimatedMinutes: json['estimatedMinutes'] as int? ?? 0,
        steps: (json['steps'] as List?)
                ?.map((e) => LessonStep.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
        dateLabel: json['dateLabel'] as String?,
      );
}
