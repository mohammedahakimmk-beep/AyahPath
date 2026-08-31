import '../../l10n/app_localizations.dart';

/// The core learning skills AyahPath tracks and adapts.
enum SkillType {
  reading('Reading', 'Read Arabic and Quranic text fluently'),
  tajweed('Tajweed', 'Apply the rules of correct recitation'),
  memorization('Memorization', 'Commit ayahs and surahs to memory (Hifz)'),
  revision('Revision', 'Retain and review memorized Qur’an'),
  comprehension('Comprehension', 'Understand vocabulary and meaning'),
  fluency('Fluency', 'Read with natural pacing and flow');

  const SkillType(this.label, this.description);

  final String label;
  final String description;

  /// Localized label.
  String localizedLabel(AppLocalizations l) {
    switch (this) {
      case SkillType.reading:
        return l.skillReading;
      case SkillType.tajweed:
        return l.skillTajweed;
      case SkillType.memorization:
        return l.skillMemorization;
      case SkillType.revision:
        return l.skillRevision;
      case SkillType.comprehension:
        return l.skillComprehension;
      case SkillType.fluency:
        return l.skillFluency;
    }
  }

  /// Localized description.
  String localizedDescription(AppLocalizations l) {
    switch (this) {
      case SkillType.reading:
        return l.skillReadingDesc;
      case SkillType.tajweed:
        return l.skillTajweedDesc;
      case SkillType.memorization:
        return l.skillMemorizationDesc;
      case SkillType.revision:
        return l.skillRevisionDesc;
      case SkillType.comprehension:
        return l.skillComprehensionDesc;
      case SkillType.fluency:
        return l.skillFluencyDesc;
    }
  }
}
