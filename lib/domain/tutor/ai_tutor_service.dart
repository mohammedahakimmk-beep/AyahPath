import '../../data/models/learner_profile.dart';

/// A tutor response.
class TutorResponse {
  const TutorResponse({
    required this.answer,
    required this.supportsRevision,
    this.linksToTeacher = false,
    this.isDefine = false,
  });

  final String answer;

  /// Whether this answer reflects trusted educational content (vs. only AI).
  final bool supportsRevision;

  /// When true, the answer explicitly defers religious/authoritative matters
  /// to a qualified teacher or scholar.
  final bool linksToTeacher;

  final bool isDefine;
}

/// Guides learners with trusted educational material.
///
/// AyahPath deliberately does NOT impersonate a scholar. Answers draw on a
/// curated local knowledge base; anything requiring religious authority
/// defers to a qualified teacher. A cloud LLM can be layered on later through
/// the same interface.
class AiTutorService {
  TutorResponse respond(String question, LearnerProfile profile) {
    final q = question.toLowerCase();

    if (q.contains('revis') || q.contains('review') || q.contains('today') || q.contains('revise')) {
      return _revisionAdvice(profile);
    }
    if (q.contains('madd')) {
      return const TutorResponse(
        answer:
            'Madd (مد) means to lengthen a vowel. The letters that extend are '
            'ا ، و ، ي when they follow a fitting harakat. In its "natural" form '
            '(madd tabiʿi) a madd letter is held for roughly two counts. '
            'Practicing slowly with a teacher or audio helps build steady control.',
        supportsRevision: true,
      );
    }
    if (q.contains('ghunnah')) {
      return const TutorResponse(
        answer:
            'Ghunnah (غنة) is the nasal resonance produced through the nose, '
            'lasting about two counts. It is heard in the letters ن and م when '
            'they carry shaddah (e.g. إِنَّ). Holding the nose gently while '
            'practicing can help you feel and hear it.',
        supportsRevision: true,
      );
    }
    if (q.contains('qalqalah')) {
      return const TutorResponse(
        answer:
            'Qalqalah (قلقلة) is a slight, crisp bounce heard when pronouncing '
            'the letters ق ط ب ج د when they carry a sukun. It gives these '
            'letters their distinct clarity.',
        supportsRevision: true,
      );
    }
    if (q.contains('ikhfa')) {
      return const TutorResponse(
        answer:
            'Ikhfa (إخفاء) means to conceal. When the letter ن with sukun (or '
            'tanween) precedes certain letters, it is pronounced with partial '
            'nasalization (ghunnah) without a full clear ن. It is one of the '
            'main rules (ahkam) of noon and tanween.',
        supportsRevision: true,
      );
    }
    if (q.contains('tajweed')) {
      return const TutorResponse(
        answer:
            'Tajweed (تجويد) is the set of rules for correct, beautiful '
            'recitation of the Qur’an: proper letter articulation (makharij), '
            'qualities (sifaat), and the rules of noon, meem, and madd. It is '
            'best learned gradually and with a qualified teacher who can hear '
            'and correct your recitation.',
        supportsRevision: true,
        linksToTeacher: true,
      );
    }
    if (q.contains('meaning') || q.contains('word') || q.contains('vocabulary')) {
      return const TutorResponse(
        answer:
            'Growing Quranic vocabulary is best learned in context. As you read '
            'an ayah, note recurring words and roots — words like "رَبّ" (Lord) '
            'and "نَاس" (people) reappear often. Use the Reader’s translation '
            'and meaning notes to build understanding gradually.',
        supportsRevision: true,
      );
    }
    if (q.contains('test') || q.contains('quiz')) {
      return const TutorResponse(
        answer:
            'I can give you a short practice prompt. Read today’s focus surah '
            'aloud, then explain the meaning of two key words, and recall one '
            'ayah from memory. Your practice screen already offers structured '
            'checks to rebuild after each lesson.',
        supportsRevision: true,
      );
    }
    if (q.contains('surah')) {
      return const TutorResponse(
        answer:
            'Which surah would you like to focus on? I can help you plan '
            'reading, memorization or revision for it. Trusted surah text and '
            'context are available in the Reader.',
        supportsRevision: false,
      );
    }
    if (q.contains('ruling') || q.contains('fatwa') || q.contains('is it permissible')) {
      return const TutorResponse(
        answer:
            'That question involves religious ruling, which requires scholarly '
            'authority. AyahPath is a learning companion and does not issue '
            'religious rulings. Please consult a qualified scholar or a trusted '
            'Islamic reference for authoritative guidance.',
        supportsRevision: true,
        linksToTeacher: true,
      );
    }

    final weak = profile.skillsNeedingPractice();
    if (weak.isNotEmpty) {
      final names = weak.take(2).map((s) => s.label).join(' and ');
      return TutorResponse(
        answer:
            'Based on your recent progress, $names could use gentle, consistent '
            'practice. Your daily lesson already adjusts to include it — keep '
            'short, regular sessions rather than long irregular ones.',
        supportsRevision: true,
      );
    }

    return TutorResponse(
      answer:
          'I can help with Tajweed concepts, vocabulary, revision planning, and '
          'your daily lesson. Ask something like “What should I revise today?” '
          'or “Explain madd.” For rulings that need scholarly authority, I’ll '
          'point you to a qualified teacher.',
      supportsRevision: false,
      linksToTeacher: true,
    );
  }

  TutorResponse _revisionAdvice(LearnerProfile profile) {
    final due = profile.surahsNeedingReview();
    final weak = profile.skillsNeedingPractice();
    final dueNames = due.map((m) => m.surahName).join(', ');
    final weakNames = weak.take(2).map((s) => s.label).join(' and ');

    if (due.isNotEmpty && weak.isNotEmpty) {
      return TutorResponse(
        answer:
            'Today priorities: revise ${dueNames.length > 18 ? '${dueNames.substring(0, 16)}…' : dueNames} '
            '(it’s due for spaced review), and give $weakNames a focused 5-minute '
            'session. Your lesson already builds these in.',
        supportsRevision: true,
      );
    }
    if (due.isNotEmpty) {
      return TutorResponse(
        answer:
            'Your spaced-revision schedule has ${due.length} section(s) due: '
            '$dueNames. Reviewing these now will strengthen long-term memory.',
        supportsRevision: true,
      );
    }
    if (weak.isNotEmpty) {
      return TutorResponse(
        answer:
            'Recommend focusing on $weakNames today — a short targeted practice '
            'will help most. Your daily lesson is adapted to include it.',
        supportsRevision: true,
      );
    }
    return const TutorResponse(
      answer:
          'You’re in good shape across your skills. Today is a good day to '
          'slightly extend your reading and add one small memorization step.',
      supportsRevision: true,
    );
  }
}
