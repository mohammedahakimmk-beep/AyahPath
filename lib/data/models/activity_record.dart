import 'skill_type.dart';

/// One tracked event in the learner's history (lesson, practice, assessment).
class ActivityRecord {
  const ActivityRecord({
    required this.id,
    required this.type,
    required this.at,
    this.skill,
    this.score,
    this.durationMinutes = 0,
    this.detail,
    this.best,
  });

  final String id;

  /// 'lesson' | 'practice' | 'assessment' | 'model_download'
  final String type;
  final DateTime at;
  final SkillType? skill;

  /// 0..1 quality score when available.
  final double? score;
  final int durationMinutes;
  final String? detail;

  /// Optional best match for the activity (voice/practice analysis).
  final String? best;

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'at': at.millisecondsSinceEpoch,
        'skill': skill?.name,
        'score': score,
        'durationMinutes': durationMinutes,
        'detail': detail,
        'best': best,
      };

  factory ActivityRecord.fromJson(Map<String, dynamic> json) {
    SkillType? s(String? n) =>
        n == null ? null : SkillType.values.firstWhere((e) => e.name == n, orElse: () => SkillType.reading);
    return ActivityRecord(
      id: json['id'] as String? ?? '',
      type: json['type'] as String? ?? '',
      at: DateTime.fromMillisecondsSinceEpoch(json['at'] as int? ?? 0),
      skill: s(json['skill'] as String?),
      score: (json['score'] as num?)?.toDouble(),
      durationMinutes: json['durationMinutes'] as int? ?? 0,
      detail: json['detail'] as String?,
      best: json['best'] as String?,
    );
  }
}
