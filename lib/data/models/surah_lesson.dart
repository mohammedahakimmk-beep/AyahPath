/// Represents the sequential phases of a Surah-based lesson.
///
/// Each lesson follows: Listen & Repeat → Read Alone → AI Test → (optional) Translation.
/// This mirrors how tarteel.ai and top Quran apps structure memorization.
enum LessonPhase {
  listenRepeat('Listen & Repeat', 'Listen carefully and repeat after each ayah'),
  readAlone('Read Alone', 'Read the ayahs from memory'),
  aiTest('AI Recitation Test', 'Recite without looking — AI analyzes your voice'),
  translationStudy('Meaning', 'Understand the translation and key words');

  const LessonPhase(this.label, this.description);
  final String label;
  final String description;
}

/// A single ayah range within a lesson.
class AyahRange {
  const AyahRange({
    required this.surahNumber,
    required this.fromAyah,
    required this.toAyah,
  });

  final int surahNumber;
  final int fromAyah;
  final int toAyah;

  int get ayahCount => toAyah - fromAyah + 1;
  String get display => '$surahNumber:$fromAyah-$toAyah';

  Map<String, dynamic> toJson() => {
        'surahNumber': surahNumber,
        'fromAyah': fromAyah,
        'toAyah': toAyah,
      };

  factory AyahRange.fromJson(Map<String, dynamic> json) => AyahRange(
        surahNumber: json['surahNumber'] as int? ?? 1,
        fromAyah: json['fromAyah'] as int? ?? 1,
        toAyah: json['toAyah'] as int? ?? 1,
      );
}

/// A surah-based lesson — either a full short surah or one part of a long surah.
///
/// Every surah is a lesson. Long surahs (>15 ayahs) are split into parts
/// of max 15 ayahs each (~1 page). Each part follows the same 3-phase flow.
class SurahLesson {
  const SurahLesson({
    required this.id,
    required this.surahNumber,
    required this.surahName,
    required this.surahEnglishName,
    required this.partNumber,
    required this.totalParts,
    required this.ayahRange,
    required this.phases,
    required this.isCompleted,
    this.masteryScore,
  });

  final String id;
  final int surahNumber;
  final String surahName;
  final String surahEnglishName;
  final int partNumber;
  final int totalParts;
  final AyahRange ayahRange;
  final List<LessonPhase> phases;
  final bool isCompleted;
  final double? masteryScore; // 0..1, null if not yet assessed

  bool get isSinglePart => totalParts == 1;
  bool get isPartOfLongSurah => totalParts > 1;

  String get displayTitle {
    if (isSinglePart) return surahEnglishName;
    return '$surahEnglishName (Part $partNumber/$totalParts)';
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'surahNumber': surahNumber,
        'surahName': surahName,
        'surahEnglishName': surahEnglishName,
        'partNumber': partNumber,
        'totalParts': totalParts,
        'ayahRange': ayahRange.toJson(),
        'phases': phases.map((p) => p.name).toList(),
        'isCompleted': isCompleted,
        'masteryScore': masteryScore,
      };

  factory SurahLesson.fromJson(Map<String, dynamic> json) => SurahLesson(
        id: json['id'] as String? ?? '',
        surahNumber: json['surahNumber'] as int? ?? 1,
        surahName: json['surahName'] as String? ?? '',
        surahEnglishName: json['surahEnglishName'] as String? ?? '',
        partNumber: json['partNumber'] as int? ?? 1,
        totalParts: json['totalParts'] as int? ?? 1,
        ayahRange: AyahRange.fromJson(json['ayahRange'] as Map<String, dynamic>? ?? {}),
        phases: (json['phases'] as List?)
                ?.map((p) => LessonPhase.values.firstWhere(
                      (lp) => lp.name == p,
                      orElse: () => LessonPhase.listenRepeat,
                    ))
                .toList() ??
            const [],
        isCompleted: json['isCompleted'] as bool? ?? false,
        masteryScore: (json['masteryScore'] as num?)?.toDouble(),
      );
}

/// Progress tracker for a single lesson phase.
class PhaseProgress {
  const PhaseProgress({
    required this.phase,
    this.ayahIndex = 0,
    this.repetitionsDone = 0,
    this.repetitionsRequired = 3,
    this.isComplete = false,
    this.score,
  });

  final LessonPhase phase;
  final int ayahIndex;
  final int repetitionsDone;
  final int repetitionsRequired;
  final bool isComplete;
  final double? score;

  PhaseProgress copyWith({
    int? ayahIndex,
    int? repetitionsDone,
    int? repetitionsRequired,
    bool? isComplete,
    double? score,
  }) =>
      PhaseProgress(
        phase: phase,
        ayahIndex: ayahIndex ?? this.ayahIndex,
        repetitionsDone: repetitionsDone ?? this.repetitionsDone,
        repetitionsRequired: repetitionsRequired ?? this.repetitionsRequired,
        isComplete: isComplete ?? this.isComplete,
        score: score ?? this.score,
      );
}
