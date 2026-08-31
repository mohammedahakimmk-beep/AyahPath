/// Global constants used across AyahPath.
class AppConstants {
  AppConstants._();

  static const String appName = 'AyahPath';
  static const String tagline = 'Your Personalized Path to Learning the Quran';

  // Birkash taweel character used to preserve proper glyph joining in Arabic.
  static const String bismillah =
      'بِسْمِ اللَّـهِ الرَّحْمَـٰنِ الرَّحِيمِ';

  // Reference context for the "Continue your learning" journey default.
  static const String defaultJourneySurah = 'An-Nas';
  static const int defaultJourneySurahNumber = 114;

  // Privacy
  static const String modelStoreKey = 'ayahpath.model.state';
}
