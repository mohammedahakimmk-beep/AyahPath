/// Normalization + similarity helpers for Tarteel-style ayah matching.
class ArabicMatcher {
  ArabicMatcher._();

  static final RegExp _nonArabicLike = RegExp(r'[^\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\s]');
  static final RegExp _spaces = RegExp(r'\s+');
  static final RegExp _harakat = RegExp(
    r'[\u064B-\u065F\u0670\u06D6-\u06ED\u08D3-\u08FF\u0640\u064E\u064F\u0650'
    r'\u0651\u0652\u0653\u0654\u0655\u0656\u0657\u0658\u0640]',
  );

  /// Reduce an Arabic string to a normalized "plain" form for matching.
  static String normalize(String input) {
    var s = input;
    // Remove everything that is not Arabic letters or spaces (punctuation,
    // English, digits, the ayah-end mark etc.).
    s = s.replaceAll(_nonArabicLike, ' ');
    // Remove diacritics/harakat and tatweel.
    s = s.replaceAll(_harakat, '');
    s = s
        // alef variants -> ا
        .replaceAll('\u0623', '\u0627') // أ
        .replaceAll('\u0625', '\u0627') // إ
        .replaceAll('\u0622', '\u0627') // آ
        .replaceAll('\u0671', '\u0627') // ٱ (alef wasla)
        .replaceAll('\u0624', '\u0648') // ؤ -> و
        .replaceAll('\u0626', '\u064A') // ئ -> ي
        .replaceAll('\u0629', '\u0647') // ة -> ه
        .replaceAll('\u0649', '\u064A'); // ى -> ي
    // Collapse whitespace.
    s = s.replaceAll(_spaces, ' ').trim();
    return s;
  }

  static List<String> words(String normalized) =>
      normalized.isEmpty ? const [] : normalized.split(' ');

  /// Damerau-Levenshtein distance between two strings (bounded edit distance).
  static int editDistance(String a, String b, {int max = 3}) {
    if (a == b) return 0;
    if (a.isEmpty) return b.length;
    if (b.isEmpty) return a.length;
    if ((a.length - b.length).abs() > max) return max + 1;

    List<int> prev = List.generate(b.length + 1, (i) => i);
    List<int> curr = List.filled(b.length + 1, 0);
    int prevPrev = 0;
    for (int i = 1; i <= a.length; i++) {
      curr[0] = i;
      for (int j = 1; j <= b.length; j++) {
        final cost = a.codeUnitAt(i - 1) == b.codeUnitAt(j - 1) ? 0 : 1;
        curr[j] = _min3(curr[j - 1] + 1, prev[j] + 1, prev[j - 1] + cost);
        if (i > 1 && j > 1 &&
            a.codeUnitAt(i - 1) == b.codeUnitAt(j - 2) &&
            a.codeUnitAt(i - 2) == b.codeUnitAt(j - 1)) {
          curr[j] = _min2(curr[j], prevPrev + 1);
        }
      }
      prevPrev = prev[b.length];
      final tmp = prev;
      prev = curr;
      curr = tmp;
    }
    return prev[b.length];
  }

  /// Similarity 0..1 of one word (normalized) to another.
  static double wordSimilarity(String w1, String w2) {
    if (w1 == w2) return 1.0;
    final maxLen = w1.length > w2.length ? w1.length : w2.length;
    if (maxLen == 0) return 1.0;
    final dist = editDistance(w1, w2, max: maxLen ~/ 2);
    if (dist > maxLen) return 0.0;
    final sim = 1.0 - (dist / maxLen);
    return sim.clamp(0.0, 1.0);
  }

  static int _min3(int a, int b, int c) => a < b ? (a < c ? a : c) : (b < c ? b : c);
  static int _min2(int a, int b) => a < b ? a : b;

  /// Greedy word-by-word alignment where each expected word maps to its best
  /// match in the spoken transcript (in order), including missing words.
  static WordAlignmentResult align({
    required List<String> expectedWords,
    required List<String> spokenWords,
    double threshold = 0.55,
  }) {
    final matchedList = <WordMatch>[];
    final missed = <String>[];
    final substitutions = <String>[];

    var spokenIdx = 0;
    for (final exp in expectedWords) {
      // Find the best spoken word at or after the current position.
      int bestIdx = -1;
      double bestSim = 0;
      for (var j = spokenIdx; j < spokenWords.length; j++) {
        final sim = wordSimilarity(exp, spokenWords[j]);
        if (sim > bestSim) {
          bestSim = sim;
          bestIdx = j;
        }
        // Once matches stop improving nearby, don't scan the whole clip.
        if (sim >= 0.85) break;
      }

      if (bestIdx >= 0 && bestSim >= threshold) {
        matchedList.add(WordMatch(expected: exp, spoken: spokenWords[bestIdx], similarity: bestSim));
        spokenIdx = bestIdx + 1;
      } else {
        missed.add(exp);
      }
    }
    // Anything spoken but not aligned near any expected word is a possible
    // substitution / insertion.
    for (final sp in spokenWords) {
      var best = 0.0;
      for (final ex in expectedWords) {
        final s = wordSimilarity(ex, sp);
        if (s > best) best = s;
      }
      if (best < threshold) substitutions.add(sp);
    }

    final matchedCount = matchedList.length;
    final overall = expectedWords.isEmpty
        ? 0.0
        : (matchedCount / expectedWords.length) * 0.85 +
            (matchedList.fold<double>(0, (a, m) => a + m.similarity) /
                (expectedWords.isEmpty ? 1 : expectedWords.length)) *
                0.15;

    return WordAlignmentResult(
      matches: matchedList,
      missedWords: missed,
      substitutions: substitutions,
      overallScore: overall.clamp(0.0, 1.0),
    );
  }
}

class WordMatch {
  const WordMatch({required this.expected, required this.spoken, required this.similarity});
  final String expected;
  final String spoken;
  final double similarity;
}

class WordAlignmentResult {
  const WordAlignmentResult({
    required this.matches,
    required this.missedWords,
    required this.substitutions,
    required this.overallScore,
  });
  final List<WordMatch> matches;
  final List<String> missedWords;
  final List<String> substitutions;
  final double overallScore;
}
