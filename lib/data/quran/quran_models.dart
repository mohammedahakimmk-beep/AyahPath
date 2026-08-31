/// A single ayah of the Qur’an.
class Ayah {
  const Ayah({
    required this.surahNumber,
    required this.ayahNumber,
    required this.arabic,
    this.translationEng,
    this.transliteration,
  });

  final int surahNumber;
  final int ayahNumber;

  /// Uthmani Arabic text.
  final String arabic;

  /// English translation (trusted dataset).
  final String? translationEng;

  /// A simple English transliteration (for beginners).
  final String? transliteration;

  Map<String, dynamic> toJson() => {
        'surah': surahNumber,
        'ayah': ayahNumber,
        'arabic': arabic,
        'en': translationEng,
        'translit': transliteration,
      };
}

/// A surah (chapter) of the Qur’an.
class Surah {
  const Surah({
    required this.number,
    required this.name,
    required this.englishName,
    required this.ayahCount,
    required this.revelationPlace,
    required this.ayahs,
  });

  final int number;
  final String name;
  final String englishName;
  final int ayahCount;
  final String revelationPlace;
  final List<Ayah> ayahs;

  Ayah ayahAt(int n) => ayahs.firstWhere((a) => a.ayahNumber == n);
  bool containsAyah(int n) => n >= 1 && n <= ayahs.length;
}
