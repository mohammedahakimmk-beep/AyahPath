import 'dart:ui' show Locale;

import '../../data/models/learner_profile.dart';
import '../../l10n/app_localizations.dart';

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
  TutorResponse respond(String question, LearnerProfile profile, [AppLocalizations? l]) {
    final loc = l ?? lookupAppLocalizations(const Locale('en'));
    final q = question.toLowerCase();

    if (q.contains('revis') || q.contains('review') || q.contains('today') || q.contains('revise')) {
      return _revisionAdvice(profile, loc);
    }
    if (q.contains('madd')) {
      return TutorResponse(
        answer: loc.tutorMadd,
        supportsRevision: true,
      );
    }
    if (q.contains('ghunnah')) {
      return TutorResponse(
        answer: loc.tutorGhunnah,
        supportsRevision: true,
      );
    }
    if (q.contains('qalqalah')) {
      return TutorResponse(
        answer: loc.tutorQalqalah,
        supportsRevision: true,
      );
    }
    if (q.contains('ikhfa')) {
      return TutorResponse(
        answer: loc.tutorIkhfa,
        supportsRevision: true,
      );
    }
    if (q.contains('tajweed')) {
      return TutorResponse(
        answer: loc.tutorTajweed,
        supportsRevision: true,
        linksToTeacher: true,
      );
    }
    if (q.contains('meaning') || q.contains('word') || q.contains('vocabulary')) {
      return TutorResponse(
        answer: loc.tutorVocabulary,
        supportsRevision: true,
      );
    }
    if (q.contains('test') || q.contains('quiz')) {
      return TutorResponse(
        answer: loc.tutorTest,
        supportsRevision: true,
      );
    }
    if (q.contains('surah')) {
      return TutorResponse(
        answer: loc.tutorSurah,
        supportsRevision: false,
      );
    }
    if (q.contains('ruling') || q.contains('fatwa') || q.contains('is it permissible')) {
      return TutorResponse(
        answer: loc.tutorRuling,
        supportsRevision: true,
        linksToTeacher: true,
      );
    }

    final weak = profile.skillsNeedingPractice();
    if (weak.isNotEmpty) {
      final names = weak.take(2).map((s) => s.localizedLabel(loc)).join(loc.tutorAnd);
      return TutorResponse(
        answer: loc.tutorWeakSkills(names),
        supportsRevision: true,
      );
    }

    return TutorResponse(
      answer: loc.tutorGeneric,
      supportsRevision: false,
      linksToTeacher: true,
    );
  }

  TutorResponse _revisionAdvice(LearnerProfile profile, AppLocalizations loc) {
    final due = profile.surahsNeedingReview();
    final weak = profile.skillsNeedingPractice();
    final dueNames = due.map((m) => m.surahName).join(', ');
    final weakNames = weak.take(2).map((s) => s.localizedLabel(loc)).join(loc.tutorAnd);

    if (due.isNotEmpty && weak.isNotEmpty) {
      final shown = dueNames.length > 18 ? '${dueNames.substring(0, 16)}…' : dueNames;
      return TutorResponse(
        answer: loc.tutorRevisionDueAndWeak(shown, weakNames),
        supportsRevision: true,
      );
    }
    if (due.isNotEmpty) {
      return TutorResponse(
        answer: loc.tutorRevisionDue(due.length, dueNames),
        supportsRevision: true,
      );
    }
    if (weak.isNotEmpty) {
      return TutorResponse(
        answer: loc.tutorRevisionWeak(weakNames),
        supportsRevision: true,
      );
    }
    return TutorResponse(
      answer: loc.tutorRevisionGood,
      supportsRevision: true,
    );
  }
}
