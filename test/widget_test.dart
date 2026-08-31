import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ayahpath/data/local/local_store.dart';
import 'package:ayahpath/features/learn/learn_screen.dart';
import 'package:ayahpath/features/learn/surah_lesson_player_screen.dart';
import 'package:ayahpath/data/models/surah_lesson.dart';
import 'package:ayahpath/services/app_state.dart';
import 'package:ayahpath/services/null_auth_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<AppState> createAppState() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final app = AppState(store: LocalStore(prefs), auth: NullAuthService());
    await app.initialize();
    return app;
  }

  testWidgets('app boots to onboarding when no profile exists', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final app = await createAppState();
    expect(app.needsOnboarding, isTrue);
    expect(app.isBootstrapped, isFalse);
  });

  testWidgets('LessonPlayer screen renders for a short surah', (tester) async {
    const lesson = SurahLesson(
      id: '1001',
      surahNumber: 1,
      surahName: 'الفاتحة',
      surahEnglishName: 'Al-Fatihah',
      partNumber: 1,
      totalParts: 1,
      ayahRange: AyahRange(surahNumber: 1, fromAyah: 1, toAyah: 7),
      phases: [LessonPhase.listenRepeat, LessonPhase.readAlone, LessonPhase.aiTest],
      isCompleted: false,
    );

    await tester.pumpWidget(
      MaterialApp(home: SurahLessonPlayerScreen(lesson: lesson)),
    );
    await tester.pump();
    expect(find.textContaining('Al-Fatihah'), findsWidgets);
    expect(find.textContaining('Listen'), findsWidgets);
  });

  testWidgets('LearnScreen renders surah list with stats', (tester) async {
    final app = await createAppState();
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: app,
        child: const MaterialApp(home: LearnScreen()),
      ),
    );
    await tester.pump();
    // Header present
    expect(find.text('Learn Quran'), findsOneWidget);
    // Surah names render
    expect(find.text('Al-Fatihah'), findsWidgets);
  });

  testWidgets('SurahLesson model round trip preserves progress', (tester) async {
    const lesson = SurahLesson(
      id: '6703',
      surahNumber: 67,
      surahName: 'الملك',
      surahEnglishName: 'Al-Mulk',
      partNumber: 1,
      totalParts: 2,
      ayahRange: AyahRange(surahNumber: 67, fromAyah: 1, toAyah: 15),
      phases: [LessonPhase.listenRepeat, LessonPhase.readAlone, LessonPhase.aiTest, LessonPhase.translationStudy],
      isCompleted: true,
      masteryScore: 0.9,
    );
    final json = lesson.toJson();
    final back = SurahLesson.fromJson(json);
    expect(back.isCompleted, isTrue);
    expect(back.masteryScore, 0.9);
    expect(back.phases.length, 4);
  });
}
