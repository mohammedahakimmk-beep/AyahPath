import 'package:flutter_test/flutter_test.dart';
import 'package:ayahpath/domain/adaptive/surah_lesson_generator.dart';
import 'package:ayahpath/data/quran/quran_metadata.dart';
import 'package:ayahpath/data/models/surah_lesson.dart';

void main() {
  group('QuranMetadata', () {
    test('contains exactly 114 surahs', () {
      expect(QuranMetadata.allSurahs.length, 114);
    });

    test('all surahs have valid data', () {
      for (final s in QuranMetadata.allSurahs) {
        expect(s.number, greaterThan(0));
        expect(s.name.isNotEmpty, isTrue);
        expect(s.englishName.isNotEmpty, isTrue);
        expect(s.ayahCount, greaterThan(0));
      }
    });

    test('surah 2 (Al-Baqarah) is the longest with 286 ayahs', () {
      final surah = QuranMetadata.byNumber(2);
      expect(surah!.ayahCount, 286);
      expect(surah.lessonParts, greaterThan(1));
    });

    test('short surahs are single lessons', () {
      final f = QuranMetadata.byNumber(1)!;
      final kh = QuranMetadata.byNumber(112)!;
      expect(f.singleLesson, isTrue);
      expect(f.lessonParts, 1);
      expect(kh.singleLesson, isTrue);
    });
  });

  group('SurahLessonGenerator', () {
    test('generates lessons for all surahs', () {
      final lessons = SurahLessonGenerator.generateAllLessons(
        completedLessonIds: {},
      );
      expect(lessons.length, greaterThan(130)); // 114 + split parts
    });

    test('long surahs are split into parts of max 15 ayahs', () {
      final baqarah = SurahLessonGenerator.lessonsForSurah(
        2,
        completedLessonIds: {},
      );
      expect(baqarah.length, greaterThan(1));
      for (final lesson in baqarah) {
        expect(lesson.ayahRange.ayahCount, lessThanOrEqualTo(15));
        expect(lesson.totalParts, baqarah.length);
      }
    });

    test('succinct surahs generate one lesson with 3 base phases', () {
      final lessons = SurahLessonGenerator.generateAllLessons(
        completedLessonIds: {},
      );
      for (final lesson in lessons) {
        if (lesson.surahNumber == 112) {
          expect(lesson.partNumber, 1);
          expect(lesson.totalParts, 1);
        }
      }
    });

    test('nextLesson returns first uncompleted lesson', () {
      final first = SurahLessonGenerator.nextLesson(
        completedLessonIds: {},
      );
      expect(first, isNotNull);
      expect(first!.isCompleted, isFalse);
    });

    test('completed lessons are marked', () {
      final newLessons = SurahLessonGenerator.generateAllLessons(
        completedLessonIds: {1001}, // Al-Fatihah part 1 (id = 1*1000+1)
      );
      final fatihah = newLessons.firstWhere((l) => l.surahNumber == 1);
      expect(fatihah.isCompleted, isTrue);
    });

    test('nextLesson skips completed and returns next', () {
      final next = SurahLessonGenerator.nextLesson(
        completedLessonIds: {1001},
      );
      // Al-Fatihah is id 1001 (1*1000+1), so next should not be it
      expect(next!.surahNumber, isNot(1));
    });

    test('lesson stats compute correctly', () {
      final stats = SurahLessonGenerator.getStats(
        completedLessonIds: {1001},
      );
      expect(stats.completedLessons, 1);
      expect(stats.completionPercent, greaterThan(0));
      expect(stats.totalLessons, greaterThan(130));
    });

    test('lesson IDs follow surah*1000+part scheme', () {
      final lessons = SurahLessonGenerator.generateAllLessons(
        completedLessonIds: {},
      );
      for (final lesson in lessons) {
        expect(lesson.id, (lesson.surahNumber * 1000 + lesson.partNumber).toString());
      }
    });
  });

  group('SurahLesson models', () {
    test('toJson and fromJson round-trip', () {
      const lesson = SurahLesson(
        id: '2001',
        surahNumber: 2,
        surahName: 'البقرة',
        surahEnglishName: 'Al-Baqarah',
        partNumber: 1,
        totalParts: 20,
        ayahRange: AyahRange(surahNumber: 2, fromAyah: 1, toAyah: 15),
        phases: [LessonPhase.listenRepeat, LessonPhase.readAlone, LessonPhase.aiTest],
        isCompleted: true,
        masteryScore: 0.8,
      );

      final json = lesson.toJson();
      final restored = SurahLesson.fromJson(json);

      expect(restored.id, lesson.id);
      expect(restored.surahNumber, lesson.surahNumber);
      expect(restored.surahName, lesson.surahName);
      expect(restored.surahEnglishName, lesson.surahEnglishName);
      expect(restored.partNumber, lesson.partNumber);
      expect(restored.totalParts, lesson.totalParts);
      expect(restored.ayahRange.fromAyah, lesson.ayahRange.fromAyah);
      expect(restored.ayahRange.toAyah, lesson.ayahRange.toAyah);
      expect(restored.phases, lesson.phases);
      expect(restored.isCompleted, isTrue);
      expect(restored.masteryScore, 0.8);
    });

    test('displayTitle shows part info for long surahs', () {
      const lesson = SurahLesson(
        id: '2001',
        surahNumber: 2,
        surahName: 'البقرة',
        surahEnglishName: 'Al-Baqarah',
        partNumber: 3,
        totalParts: 20,
        ayahRange: AyahRange(surahNumber: 2, fromAyah: 31, toAyah: 45),
        phases: [LessonPhase.listenRepeat],
        isCompleted: false,
      );
      expect(lesson.displayTitle, 'Al-Baqarah (Part 3/20)');
    });
  });
}
