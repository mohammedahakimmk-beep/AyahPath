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
}
