/// Metadata for all 114 surahs of the Qur'an.
///
/// Arabic text is only included for the subset of surahs bundled offline.
/// This metadata layer covers all surahs for navigation, planning, and
/// lesson generation — even for surahs whose ayah text will be added later.
class SurahMeta {
  const SurahMeta({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.ayahCount,
    required this.revelationPlace,
  });

  final int number;
  final String name;
  final String englishName;
  final String englishNameTranslation;
  final int ayahCount;
  final String revelationPlace;

  /// Whether this surah is short enough for a single lesson (<=15 ayahs).
  bool get singleLesson => ayahCount <= 15;

  /// Number of lesson parts needed when splitting long surahs.
  /// 1 page ≈ 15 ayahs ≈ a comfortable 15-minute lesson.
  int get lessonParts {
    if (singleLesson) return 1;
    return (ayahCount / 15).ceil();
  }

  Map<String, dynamic> toJson() => {
        'number': number,
        'name': name,
        'englishName': englishName,
        'englishNameTranslation': englishNameTranslation,
        'ayahCount': ayahCount,
        'revelationPlace': revelationPlace,
      };

  factory SurahMeta.fromJson(Map<String, dynamic> json) => SurahMeta(
        number: json['number'] as int? ?? 0,
        name: json['name'] as String? ?? '',
        englishName: json['englishName'] as String? ?? '',
        englishNameTranslation: json['englishNameTranslation'] as String? ?? '',
        ayahCount: json['ayahCount'] as int? ?? 0,
        revelationPlace: json['revelationPlace'] as String? ?? '',
      );
}

/// Complete metadata for all 114 surahs.
class QuranMetadata {
  QuranMetadata._();

  static const List<SurahMeta> allSurahs = [
    SurahMeta(number: 1, name: 'الفاتحة', englishName: 'Al-Fatihah', englishNameTranslation: 'The Opening', ayahCount: 7, revelationPlace: 'Meccan'),
    SurahMeta(number: 2, name: 'البقرة', englishName: 'Al-Baqarah', englishNameTranslation: 'The Cow', ayahCount: 286, revelationPlace: 'Medinan'),
    SurahMeta(number: 3, name: 'آل عمران', englishName: 'Ali Imran', englishNameTranslation: 'The Family of Imran', ayahCount: 200, revelationPlace: 'Medinan'),
    SurahMeta(number: 4, name: 'النساء', englishName: 'An-Nisa', englishNameTranslation: 'The Women', ayahCount: 176, revelationPlace: 'Medinan'),
    SurahMeta(number: 5, name: 'المائدة', englishName: 'Al-Maidah', englishNameTranslation: 'The Table Spread', ayahCount: 120, revelationPlace: 'Medinan'),
    SurahMeta(number: 6, name: 'الأنعام', englishName: 'Al-Anam', englishNameTranslation: 'The Cattle', ayahCount: 165, revelationPlace: 'Meccan'),
    SurahMeta(number: 7, name: 'الأعراف', englishName: 'Al-Araf', englishNameTranslation: 'The Heights', ayahCount: 206, revelationPlace: 'Meccan'),
    SurahMeta(number: 8, name: 'الأنفال', englishName: 'Al-Anfal', englishNameTranslation: 'The Spoils of War', ayahCount: 75, revelationPlace: 'Medinan'),
    SurahMeta(number: 9, name: 'التوبة', englishName: 'At-Tawbah', englishNameTranslation: 'The Repentance', ayahCount: 129, revelationPlace: 'Medinan'),
    SurahMeta(number: 10, name: 'يونس', englishName: 'Yunus', englishNameTranslation: 'Jonah', ayahCount: 109, revelationPlace: 'Meccan'),
    SurahMeta(number: 11, name: 'هود', englishName: 'Hud', englishNameTranslation: 'Hud', ayahCount: 123, revelationPlace: 'Meccan'),
    SurahMeta(number: 12, name: 'يوسف', englishName: 'Yusuf', englishNameTranslation: 'Joseph', ayahCount: 111, revelationPlace: 'Meccan'),
    SurahMeta(number: 13, name: 'الرعد', englishName: 'Ar-Rad', englishNameTranslation: 'The Thunder', ayahCount: 43, revelationPlace: 'Medinan'),
    SurahMeta(number: 14, name: 'إبراهيم', englishName: 'Ibrahim', englishNameTranslation: 'Abraham', ayahCount: 52, revelationPlace: 'Meccan'),
    SurahMeta(number: 15, name: 'الحجر', englishName: 'Al-Hijr', englishNameTranslation: 'The Rocky Tract', ayahCount: 99, revelationPlace: 'Meccan'),
    SurahMeta(number: 16, name: 'النحل', englishName: 'An-Nahl', englishNameTranslation: 'The Bee', ayahCount: 128, revelationPlace: 'Meccan'),
    SurahMeta(number: 17, name: 'الإسراء', englishName: 'Al-Isra', englishNameTranslation: 'The Night Journey', ayahCount: 111, revelationPlace: 'Meccan'),
    SurahMeta(number: 18, name: 'الكهف', englishName: 'Al-Kahf', englishNameTranslation: 'The Cave', ayahCount: 110, revelationPlace: 'Meccan'),
    SurahMeta(number: 19, name: 'مريم', englishName: 'Maryam', englishNameTranslation: 'Mary', ayahCount: 98, revelationPlace: 'Meccan'),
    SurahMeta(number: 20, name: 'طه', englishName: 'Taha', englishNameTranslation: 'Ta-Ha', ayahCount: 135, revelationPlace: 'Meccan'),
    SurahMeta(number: 21, name: 'الأنبياء', englishName: 'Al-Anbiya', englishNameTranslation: 'The Prophets', ayahCount: 112, revelationPlace: 'Meccan'),
    SurahMeta(number: 22, name: 'الحج', englishName: 'Al-Hajj', englishNameTranslation: 'The Pilgrimage', ayahCount: 78, revelationPlace: 'Medinan'),
    SurahMeta(number: 23, name: 'المؤمنون', englishName: 'Al-Muminun', englishNameTranslation: 'The Believers', ayahCount: 118, revelationPlace: 'Meccan'),
    SurahMeta(number: 24, name: 'النور', englishName: 'An-Nur', englishNameTranslation: 'The Light', ayahCount: 64, revelationPlace: 'Medinan'),
    SurahMeta(number: 25, name: 'الفرقان', englishName: 'Al-Furqan', englishNameTranslation: 'The Criterion', ayahCount: 77, revelationPlace: 'Meccan'),
    SurahMeta(number: 26, name: 'الشعراء', englishName: 'Ash-Shuara', englishNameTranslation: 'The Poets', ayahCount: 227, revelationPlace: 'Meccan'),
    SurahMeta(number: 27, name: 'النمل', englishName: 'An-Naml', englishNameTranslation: 'The Ant', ayahCount: 93, revelationPlace: 'Meccan'),
    SurahMeta(number: 28, name: 'القصص', englishName: 'Al-Qasas', englishNameTranslation: 'The Stories', ayahCount: 88, revelationPlace: 'Meccan'),
    SurahMeta(number: 29, name: 'العنكبوت', englishName: 'Al-Ankabut', englishNameTranslation: 'The Spider', ayahCount: 69, revelationPlace: 'Meccan'),
    SurahMeta(number: 30, name: 'الروم', englishName: 'Ar-Rum', englishNameTranslation: 'The Romans', ayahCount: 60, revelationPlace: 'Meccan'),
    SurahMeta(number: 31, name: 'لقمان', englishName: 'Luqman', englishNameTranslation: 'Luqman', ayahCount: 34, revelationPlace: 'Meccan'),
    SurahMeta(number: 32, name: 'السجدة', englishName: 'As-Sajdah', englishNameTranslation: 'The Prostration', ayahCount: 30, revelationPlace: 'Meccan'),
    SurahMeta(number: 33, name: 'الأحزاب', englishName: 'Al-Ahzab', englishNameTranslation: 'The Combined Forces', ayahCount: 73, revelationPlace: 'Medinan'),
    SurahMeta(number: 34, name: 'سبأ', englishName: 'Saba', englishNameTranslation: 'Sheba', ayahCount: 54, revelationPlace: 'Meccan'),
    SurahMeta(number: 35, name: 'فاطر', englishName: 'Fatir', englishNameTranslation: 'Originator', ayahCount: 45, revelationPlace: 'Meccan'),
    SurahMeta(number: 36, name: 'يس', englishName: 'Ya-Sin', englishNameTranslation: 'Ya-Sin', ayahCount: 83, revelationPlace: 'Meccan'),
    SurahMeta(number: 37, name: 'الصافات', englishName: 'As-Saffat', englishNameTranslation: 'Those Who Set The Ranks', ayahCount: 182, revelationPlace: 'Meccan'),
    SurahMeta(number: 38, name: 'ص', englishName: 'Sad', englishNameTranslation: 'Sad', ayahCount: 88, revelationPlace: 'Meccan'),
    SurahMeta(number: 39, name: 'الزمر', englishName: 'Az-Zumar', englishNameTranslation: 'The Troops', ayahCount: 75, revelationPlace: 'Meccan'),
    SurahMeta(number: 40, name: 'غافر', englishName: 'Ghafir', englishNameTranslation: 'The Forgiver', ayahCount: 85, revelationPlace: 'Meccan'),
    SurahMeta(number: 41, name: 'فصلت', englishName: 'Fussilat', englishNameTranslation: 'Explained in Detail', ayahCount: 54, revelationPlace: 'Meccan'),
    SurahMeta(number: 42, name: 'الشورى', englishName: 'Ash-Shura', englishNameTranslation: 'The Consultation', ayahCount: 53, revelationPlace: 'Meccan'),
    SurahMeta(number: 43, name: 'الزخرف', englishName: 'Az-Zukhruf', englishNameTranslation: 'The Gold Adornments', ayahCount: 89, revelationPlace: 'Meccan'),
    SurahMeta(number: 44, name: 'الدخان', englishName: 'Ad-Dukhan', englishNameTranslation: 'The Smoke', ayahCount: 59, revelationPlace: 'Meccan'),
    SurahMeta(number: 45, name: 'الجاثية', englishName: 'Al-Jathiyah', englishNameTranslation: 'The Crouching', ayahCount: 37, revelationPlace: 'Meccan'),
    SurahMeta(number: 46, name: 'الأحقاف', englishName: 'Al-Ahqaf', englishNameTranslation: 'The Wind-Curved Sandhills', ayahCount: 35, revelationPlace: 'Meccan'),
    SurahMeta(number: 47, name: 'محمد', englishName: 'Muhammad', englishNameTranslation: 'Muhammad', ayahCount: 38, revelationPlace: 'Medinan'),
    SurahMeta(number: 48, name: 'الفتح', englishName: 'Al-Fath', englishNameTranslation: 'The Victory', ayahCount: 29, revelationPlace: 'Medinan'),
    SurahMeta(number: 49, name: 'الحجرات', englishName: 'Al-Hujurat', englishNameTranslation: 'The Rooms', ayahCount: 18, revelationPlace: 'Medinan'),
    SurahMeta(number: 50, name: 'ق', englishName: 'Qaf', englishNameTranslation: 'Qaf', ayahCount: 45, revelationPlace: 'Meccan'),
    SurahMeta(number: 51, name: 'الذاريات', englishName: 'Adh-Dhariyat', englishNameTranslation: 'The Winnowing Winds', ayahCount: 60, revelationPlace: 'Meccan'),
    SurahMeta(number: 52, name: 'الطور', englishName: 'At-Tur', englishNameTranslation: 'The Mount', ayahCount: 49, revelationPlace: 'Meccan'),
    SurahMeta(number: 53, name: 'النجم', englishName: 'An-Najm', englishNameTranslation: 'The Star', ayahCount: 62, revelationPlace: 'Meccan'),
    SurahMeta(number: 54, name: 'القمر', englishName: 'Al-Qamar', englishNameTranslation: 'The Moon', ayahCount: 55, revelationPlace: 'Meccan'),
    SurahMeta(number: 55, name: 'الرحمن', englishName: 'Ar-Rahman', englishNameTranslation: 'The Beneficent', ayahCount: 78, revelationPlace: 'Medinan'),
    SurahMeta(number: 56, name: 'الواقعة', englishName: 'Al-Waqiah', englishNameTranslation: 'The Inevitable', ayahCount: 96, revelationPlace: 'Meccan'),
    SurahMeta(number: 57, name: 'الحديد', englishName: 'Al-Hadid', englishNameTranslation: 'The Iron', ayahCount: 29, revelationPlace: 'Medinan'),
    SurahMeta(number: 58, name: 'المجادلة', englishName: 'Al-Mujadilah', englishNameTranslation: 'The Pleading Woman', ayahCount: 22, revelationPlace: 'Medinan'),
    SurahMeta(number: 59, name: 'الحشر', englishName: 'Al-Hashr', englishNameTranslation: 'The Exile', ayahCount: 24, revelationPlace: 'Medinan'),
    SurahMeta(number: 60, name: 'الممتحنة', englishName: 'Al-Mumtahanah', englishNameTranslation: 'She That Is Examined', ayahCount: 13, revelationPlace: 'Medinan'),
    SurahMeta(number: 61, name: 'الصف', englishName: 'As-Saff', englishNameTranslation: 'The Ranks', ayahCount: 14, revelationPlace: 'Medinan'),
    SurahMeta(number: 62, name: 'الجمعة', englishName: 'Al-Jumuah', englishNameTranslation: 'The Congregation', ayahCount: 11, revelationPlace: 'Medinan'),
    SurahMeta(number: 63, name: 'المنافقون', englishName: 'Al-Munafiqun', englishNameTranslation: 'The Hypocrites', ayahCount: 11, revelationPlace: 'Medinan'),
    SurahMeta(number: 64, name: 'التغابن', englishName: 'At-Taghabun', englishNameTranslation: 'The Mutual Disillusion', ayahCount: 18, revelationPlace: 'Medinan'),
    SurahMeta(number: 65, name: 'الطلاق', englishName: 'At-Talaq', englishNameTranslation: 'The Divorce', ayahCount: 12, revelationPlace: 'Medinan'),
    SurahMeta(number: 66, name: 'التحريم', englishName: 'At-Tahrim', englishNameTranslation: 'The Prohibition', ayahCount: 12, revelationPlace: 'Medinan'),
    SurahMeta(number: 67, name: 'الملك', englishName: 'Al-Mulk', englishNameTranslation: 'The Sovereignty', ayahCount: 30, revelationPlace: 'Meccan'),
    SurahMeta(number: 68, name: 'القلم', englishName: 'Al-Qalam', englishNameTranslation: 'The Pen', ayahCount: 52, revelationPlace: 'Meccan'),
    SurahMeta(number: 69, name: 'الحاقة', englishName: 'Al-Haqqah', englishNameTranslation: 'The Reality', ayahCount: 52, revelationPlace: 'Meccan'),
    SurahMeta(number: 70, name: 'المعارج', englishName: 'Al-Maarij', englishNameTranslation: 'The Ascending Stairways', ayahCount: 44, revelationPlace: 'Meccan'),
    SurahMeta(number: 71, name: 'نوح', englishName: 'Nuh', englishNameTranslation: 'Noah', ayahCount: 28, revelationPlace: 'Meccan'),
    SurahMeta(number: 72, name: 'الجن', englishName: 'Al-Jinn', englishNameTranslation: 'The Jinn', ayahCount: 28, revelationPlace: 'Meccan'),
    SurahMeta(number: 73, name: 'المزمل', englishName: 'Al-Muzzammil', englishNameTranslation: 'The Enshrouded One', ayahCount: 20, revelationPlace: 'Meccan'),
    SurahMeta(number: 74, name: 'المدثر', englishName: 'Al-Muddathir', englishNameTranslation: 'The Cloaked One', ayahCount: 56, revelationPlace: 'Meccan'),
    SurahMeta(number: 75, name: 'القيامة', englishName: 'Al-Qiyamah', englishNameTranslation: 'The Resurrection', ayahCount: 40, revelationPlace: 'Meccan'),
    SurahMeta(number: 76, name: 'الإنسان', englishName: 'Al-Insan', englishNameTranslation: 'The Human', ayahCount: 31, revelationPlace: 'Medinan'),
    SurahMeta(number: 77, name: 'المرسلات', englishName: 'Al-Mursalat', englishNameTranslation: 'The Emissaries', ayahCount: 50, revelationPlace: 'Meccan'),
    SurahMeta(number: 78, name: 'النبأ', englishName: 'An-Naba', englishNameTranslation: 'The Tidings', ayahCount: 40, revelationPlace: 'Meccan'),
    SurahMeta(number: 79, name: 'النازعات', englishName: 'An-Naziat', englishNameTranslation: 'Those Who Drag Forth', ayahCount: 46, revelationPlace: 'Meccan'),
    SurahMeta(number: 80, name: 'عبس', englishName: 'Abasa', englishNameTranslation: 'He Frowned', ayahCount: 42, revelationPlace: 'Meccan'),
    SurahMeta(number: 81, name: 'التكوير', englishName: 'At-Takwir', englishNameTranslation: 'The Overthrowing', ayahCount: 29, revelationPlace: 'Meccan'),
    SurahMeta(number: 82, name: 'الانفطار', englishName: 'Al-Infitar', englishNameTranslation: 'The Cleaving', ayahCount: 19, revelationPlace: 'Meccan'),
    SurahMeta(number: 83, name: 'المطففين', englishName: 'Al-Mutaffifin', englishNameTranslation: 'The Defrauding', ayahCount: 36, revelationPlace: 'Meccan'),
    SurahMeta(number: 84, name: 'الانشقاق', englishName: 'Al-Inshiqaq', englishNameTranslation: 'The Sundering', ayahCount: 25, revelationPlace: 'Meccan'),
    SurahMeta(number: 85, name: 'البروج', englishName: 'Al-Buruj', englishNameTranslation: 'The Mansions of the Stars', ayahCount: 22, revelationPlace: 'Meccan'),
    SurahMeta(number: 86, name: 'الطارق', englishName: 'At-Tariq', englishNameTranslation: 'The Night Comer', ayahCount: 17, revelationPlace: 'Meccan'),
    SurahMeta(number: 87, name: 'الأعلى', englishName: 'Al-Ala', englishNameTranslation: 'The Most High', ayahCount: 19, revelationPlace: 'Meccan'),
    SurahMeta(number: 88, name: 'الغاشية', englishName: 'Al-Ghashiyah', englishNameTranslation: 'The Overwhelming', ayahCount: 26, revelationPlace: 'Meccan'),
    SurahMeta(number: 89, name: 'الفجر', englishName: 'Al-Fajr', englishNameTranslation: 'The Dawn', ayahCount: 30, revelationPlace: 'Meccan'),
    SurahMeta(number: 90, name: 'البلد', englishName: 'Al-Balad', englishNameTranslation: 'The City', ayahCount: 20, revelationPlace: 'Meccan'),
    SurahMeta(number: 91, name: 'الشمس', englishName: 'Ash-Shams', englishNameTranslation: 'The Sun', ayahCount: 15, revelationPlace: 'Meccan'),
    SurahMeta(number: 92, name: 'الليل', englishName: 'Al-Layl', englishNameTranslation: 'The Night', ayahCount: 21, revelationPlace: 'Meccan'),
    SurahMeta(number: 93, name: 'الضحى', englishName: 'Ad-Duha', englishNameTranslation: 'The Morning Hours', ayahCount: 11, revelationPlace: 'Meccan'),
    SurahMeta(number: 94, name: 'الشرح', englishName: 'Ash-Sharh', englishNameTranslation: 'The Relief', ayahCount: 8, revelationPlace: 'Meccan'),
    SurahMeta(number: 95, name: 'التين', englishName: 'At-Tin', englishNameTranslation: 'The Fig', ayahCount: 8, revelationPlace: 'Meccan'),
    SurahMeta(number: 96, name: 'العلق', englishName: 'Al-Alaq', englishNameTranslation: 'The Clot', ayahCount: 19, revelationPlace: 'Meccan'),
    SurahMeta(number: 97, name: 'القدر', englishName: 'Al-Qadr', englishNameTranslation: 'The Power', ayahCount: 5, revelationPlace: 'Meccan'),
    SurahMeta(number: 98, name: 'البينة', englishName: 'Al-Bayyinah', englishNameTranslation: 'The Clear Proof', ayahCount: 8, revelationPlace: 'Medinan'),
    SurahMeta(number: 99, name: 'الزلزلة', englishName: 'Az-Zalzalah', englishNameTranslation: 'The Earthquake', ayahCount: 8, revelationPlace: 'Medinan'),
    SurahMeta(number: 100, name: 'العاديات', englishName: 'Al-Adiyat', englishNameTranslation: 'The Courser', ayahCount: 11, revelationPlace: 'Meccan'),
    SurahMeta(number: 101, name: 'القارعة', englishName: 'Al-Qariah', englishNameTranslation: 'The Calamity', ayahCount: 11, revelationPlace: 'Meccan'),
    SurahMeta(number: 102, name: 'التكاثر', englishName: 'At-Takathur', englishNameTranslation: 'The Rivalry in Worldly Increase', ayahCount: 8, revelationPlace: 'Meccan'),
    SurahMeta(number: 103, name: 'العصر', englishName: 'Al-Asr', englishNameTranslation: 'The Declining Day', ayahCount: 3, revelationPlace: 'Meccan'),
    SurahMeta(number: 104, name: 'الهمزة', englishName: 'Al-Humazah', englishNameTranslation: 'The Traducer', ayahCount: 9, revelationPlace: 'Meccan'),
    SurahMeta(number: 105, name: 'الفيل', englishName: 'Al-Fil', englishNameTranslation: 'The Elephant', ayahCount: 5, revelationPlace: 'Meccan'),
    SurahMeta(number: 106, name: 'قريش', englishName: 'Quraysh', englishNameTranslation: 'Quraysh', ayahCount: 4, revelationPlace: 'Meccan'),
    SurahMeta(number: 107, name: 'الماعون', englishName: 'Al-Maun', englishNameTranslation: 'The Small Kindnesses', ayahCount: 7, revelationPlace: 'Meccan'),
    SurahMeta(number: 108, name: 'الكوثر', englishName: 'Al-Kawthar', englishNameTranslation: 'The Abundance', ayahCount: 3, revelationPlace: 'Meccan'),
    SurahMeta(number: 109, name: 'الكافرون', englishName: 'Al-Kafirun', englishNameTranslation: 'The Disbelievers', ayahCount: 6, revelationPlace: 'Meccan'),
    SurahMeta(number: 110, name: 'النصر', englishName: 'An-Nasr', englishNameTranslation: 'The Divine Support', ayahCount: 3, revelationPlace: 'Medinan'),
    SurahMeta(number: 111, name: 'المسد', englishName: 'Al-Masad', englishNameTranslation: 'The Palm Fiber', ayahCount: 5, revelationPlace: 'Meccan'),
    SurahMeta(number: 112, name: 'الإخلاص', englishName: 'Al-Ikhlas', englishNameTranslation: 'The Sincerity', ayahCount: 4, revelationPlace: 'Meccan'),
    SurahMeta(number: 113, name: 'الفلق', englishName: 'Al-Falaq', englishNameTranslation: 'The Daybreak', ayahCount: 5, revelationPlace: 'Meccan'),
    SurahMeta(number: 114, name: 'الناس', englishName: 'An-Nas', englishNameTranslation: 'Mankind', ayahCount: 6, revelationPlace: 'Meccan'),
  ];

  static SurahMeta? byNumber(int n) {
    for (final s in allSurahs) {
      if (s.number == n) return s;
    }
    return null;
  }

  static List<SurahMeta> get shortSurahs => allSurahs.where((s) => s.ayahCount <= 7).toList();

  static List<SurahMeta> get juzList {
    // Approximate juz division points (surah number).
    return allSurahs.where((s) => [1, 2, 3, 4, 5, 7, 9, 12, 15, 18, 21, 23, 25, 27, 30, 33, 37, 39, 41, 46, 49, 51, 53, 56, 58, 61, 64, 67, 70, 73, 76, 78, 80, 83, 85, 87, 89, 93, 96, 98, 100, 103, 106, 109, 111, 114].contains(s.number)).toList();
  }
}
