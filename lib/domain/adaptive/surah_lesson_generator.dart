import 'dart:math';
import '../../data/models/surah_lesson.dart';
import '../../data/quran/quran_data.dart';
import '../../data/quran/quran_metadata.dart';

/// Maximum ayahs per lesson part (1 page ≈ 15 ayahs).
const int kMaxAyahsPerPart = 15;

/// Generates structured surah-based lessons.
///
/// Every surah becomes one or more lessons following the flow:
///   Listen & Repeat → Read Alone → AI Test → (optional) Translation
///
/// Long surahs (>15 ayahs) are split into parts of max 15 ayahs each.
class SurahLessonGenerator {
  SurahLessonGenerator._();

  /// Generates lessons for all 114 surahs based on metadata.
  /// Returns ordered list of lessons (part 1, part 2, etc. for long surahs).
  static List<SurahLesson> generateAllLessons({
    required Set<int> completedLessonIds,
    Map<String, double>? masteryScores,
  }) {
    final lessons = <SurahLesson>[];
    for (final meta in QuranMetadata.allSurahs) {
      lessons.addAll(_generateSurahLessons(
        meta: meta,
        completedLessonIds: completedLessonIds,
        masteryScores: masteryScores ?? {},
      ));
    }
    return lessons;
  }

  /// Generates lessons for a single surah.
  static List<SurahLesson> _generateSurahLessons({
    required SurahMeta meta,
    required Set<int> completedLessonIds,
    required Map<String, double> masteryScores,
  }) {
    // Surahs with no bundled Arabic text get placeholder lessons (metadata only)
    final hasText = QuranDataset.byNumber(meta.number) != null;

    final parts = meta.lessonParts;
    final lessons = <SurahLesson>[];

    for (int part = 1; part <= parts; part++) {
      final fromAyah = (part - 1) * kMaxAyahsPerPart + 1;
      final toAyah = min(part * kMaxAyahsPerPart, meta.ayahCount);

      final range = AyahRange(
        surahNumber: meta.number,
        fromAyah: fromAyah,
        toAyah: toAyah,
      );

      final lessonId = meta.number * 1000 + part; // e.g. 2001 = Al-Baqarah Part 1

      lessons.add(SurahLesson(
        id: lessonId.toString(),
        surahNumber: meta.number,
        surahName: meta.name,
        surahEnglishName: meta.englishName,
        partNumber: part,
        totalParts: parts,
        ayahRange: range,
        phases: _defaultPhases(meta, hasText, range),
        isCompleted: completedLessonIds.contains(lessonId),
        masteryScore: masteryScores['$lessonId'],
      ));
    }

    return lessons;
  }

  /// Default phases for a lesson based on the surah type.
  static List<LessonPhase> _defaultPhases(
    SurahMeta meta,
    bool hasText,
    AyahRange range,
  ) {
    final phases = <LessonPhase>[
      LessonPhase.listenRepeat,
      LessonPhase.readAlone,
      LessonPhase.aiTest,
    ];

    // Add translation study for longer ayahs or if it's a Madinan surah
    // (often more legal/contextual meaning).
    if (range.ayahCount >= 3 || meta.revelationPlace == 'Medinan') {
      phases.add(LessonPhase.translationStudy);
    }

    return phases;
  }

  /// Generates the recommended learning path (short surahs first, then progressive).
  static List<SurahLesson> generateRecommendedPath({
    required Set<int> completedLessonIds,
    Map<String, double>? masteryScores,
  }) {
    final allLessons = generateAllLessons(
      completedLessonIds: completedLessonIds,
      masteryScores: masteryScores,
    );

    // Sort by: uncompleted first, then by ayah count (shortest first),
    // then by surah number for same-length lessons.
    final sorted = List<SurahLesson>.from(allLessons);
    sorted.sort((a, b) {
      // Uncompleted first
      if (a.isCompleted != b.isCompleted) {
        return a.isCompleted ? 1 : -1;
      }
      // Shortest ayah range first (easier)
      final aLen = a.ayahRange.ayahCount;
      final bLen = b.ayahRange.ayahCount;
      if (aLen != bLen) return aLen.compareTo(bLen);
      // Then by surah number
      if (a.surahNumber != b.surahNumber) return a.surahNumber.compareTo(b.surahNumber);
      return a.partNumber.compareTo(b.partNumber);
    });

    return sorted;
  }

  /// Gets the next uncompleted lesson from the recommended path.
  static SurahLesson? nextLesson({
    required Set<int> completedLessonIds,
    Map<String, double>? masteryScores,
  }) {
    final path = generateRecommendedPath(
      completedLessonIds: completedLessonIds,
      masteryScores: masteryScores,
    );
    for (final lesson in path) {
      if (!lesson.isCompleted) return lesson;
    }
    return path.isNotEmpty ? path.last : null; // All completed — review the last one
  }

  /// Gets all lessons for a specific surah (may be multiple parts).
  static List<SurahLesson> lessonsForSurah(
    int surahNumber, {
    required Set<int> completedLessonIds,
    Map<String, double>? masteryScores,
  }) {
    return generateAllLessons(
      completedLessonIds: completedLessonIds,
      masteryScores: masteryScores,
    ).where((l) => l.surahNumber == surahNumber).toList();
  }

  /// Gets overall completion stats.
  static LessonStats getStats({
    required Set<int> completedLessonIds,
    Map<String, double>? masteryScores,
  }) {
    final all = generateAllLessons(
      completedLessonIds: completedLessonIds,
      masteryScores: masteryScores,
    );
    final completed = all.where((l) => l.isCompleted).toList();
    final totalAyahs = all.fold(0, (s, l) => s + l.ayahRange.ayahCount);
    final completedAyahs = completed.fold(0, (s, l) => s + l.ayahRange.ayahCount);

    final avgMastery = completed.isNotEmpty
        ? completed.where((l) => l.masteryScore != null).fold(0.0, (s, l) => s + l.masteryScore!) /
            max(1, completed.where((l) => l.masteryScore != null).length)
        : 0.0;

    return LessonStats(
      totalLessons: all.length,
      completedLessons: completed.length,
      totalAyahs: totalAyahs,
      completedAyahs: completedAyahs,
      averageMastery: avgMastery,
      totalSurahs: QuranMetadata.allSurahs.length,
      surahsStarted: completed.isNotEmpty
          ? completed.map((l) => l.surahNumber).toSet().length
          : 0,
    );
  }
}

/// Aggregate stats for the lesson system.
class LessonStats {
  const LessonStats({
    required this.totalLessons,
    required this.completedLessons,
    required this.totalAyahs,
    required this.completedAyahs,
    required this.averageMastery,
    required this.totalSurahs,
    required this.surahsStarted,
  });

  final int totalLessons;
  final int completedLessons;
  final int totalAyahs;
  final int completedAyahs;
  final double averageMastery;
  final int totalSurahs;
  final int surahsStarted;

  double get completionPercent =>
      totalLessons > 0 ? (completedLessons / totalLessons * 100).clamp(0, 100) : 0;

  double get ayahProgress =>
      totalAyahs > 0 ? (completedAyahs / totalAyahs).clamp(0.0, 1.0) : 0.0;
}
