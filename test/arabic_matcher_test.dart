import 'package:flutter_test/flutter_test.dart';

import 'package:ayahpath/domain/voice/arabic_matcher.dart';

void main() {
  group('ArabicMatcher.normalize', () {
    test('strips harakat and tatweel', () {
      expect(ArabicMatcher.normalize('بِسْمِ'), 'بسم');
      expect(ArabicMatcher.normalize('ٱللَّهِ'), 'الله');
    });

    test('normalizes alef/hamza/taa variants', () {
      expect(ArabicMatcher.normalize('أَرْحَمُ'), 'ارحم');
      expect(ArabicMatcher.normalize('إِيَّاكَ'), 'اياك');
      expect(ArabicMatcher.normalize('آمَنَ'), 'امن');
      expect(ArabicMatcher.normalize('رَحْمَةٍ'), 'رحمه');
    });

    test('removes non-Arabic and collapses spaces', () {
      expect(ArabicMatcher.normalize('  Qul  هُوَ  '), 'هو');
    });
  });

  group('ArabicMatcher.align', () {
    test('perfect recitation matches fully', () {
      final expected = ['قل', 'هو', 'الله', 'احد'];
      final spoken = ['قل', 'هو', 'الله', 'احد'];
      final r = ArabicMatcher.align(expectedWords: expected, spokenWords: spoken);
      expect(r.overallScore, greaterThanOrEqualTo(0.95));
      expect(r.missedWords, isEmpty);
      expect(r.substitutions, isEmpty);
    });

    test('missing words are flagged', () {
      final expected = ['قل', 'هو', 'الله', 'احد'];
      final spoken = ['قل', 'هو'];
      final r = ArabicMatcher.align(expectedWords: expected, spokenWords: spoken);
      expect(r.missedWords, containsAll(['الله', 'احد']));
      expect(r.overallScore, lessThan(0.6));
    });

    test('fuzzy substitutions are detected', () {
      final expected = ['الرحمن', 'الرحيم'];
      final spoken = ['الرحمن', 'الرجيم'];
      final r = ArabicMatcher.align(expectedWords: expected, spokenWords: spoken);
      expect(r.overallScore, greaterThan(0.5));
    });
  });

  group('ArabicMatcher.wordSimilarity', () {
    test('identical and close words', () {
      expect(ArabicMatcher.wordSimilarity('الله', 'الله'), 1.0);
      expect(ArabicMatcher.wordSimilarity('الرحمن', 'الرجيم'), greaterThan(0.4));
      expect(ArabicMatcher.wordSimilarity('كبير', 'صغير'), lessThan(0.6));
    });
  });
}
