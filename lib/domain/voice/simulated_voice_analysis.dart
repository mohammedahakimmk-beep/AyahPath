import 'dart:math';

import '../../data/quran/quran_models.dart';
import 'voice_analysis_service.dart';

/// A local, privacy-first voice analysis implementation.
///
/// In this functioning core, analysis adapts to the recitation duration and
/// produces structured, clearly *assistive* feedback. When a real on-device
/// Arabic speech model is plugged in, only this class changes — the rest of
/// the app consumes the same [VoiceAnalysisService] interface.
///
/// Two modes:
///  - Model not installed: minimal guidance, clearly flags "assistive preview".
///  - Model installed: richer simulated metrics plus a privacy notice that
///    everything runs locally.
class SimulatedVoiceAnalysisService implements VoiceAnalysisService {
  SimulatedVoiceAnalysisService({this.modelPrepared = false});

  bool modelPrepared;

  @override
  bool get isLocal => true;

  @override
  bool get isModelReady => modelPrepared;

  @override
  Future<bool> prepareModel() async {
    // Simulate a local model download/load.
    await Future<void>.delayed(const Duration(milliseconds: 900));
    modelPrepared = true;
    return true;
  }

  @override
  Future<RecitationFeedback> analyze({
    required List<Ayah> target,
    Duration? duration,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    final rng = Random(42);
    final timeBased =
        duration == null ? 0.5 : ((duration.inSeconds / 30).clamp(0.2, 1.0));

    final overall = modelPrepared
        ? (timeBased * 0.7 + rng.nextDouble() * 0.3).clamp(0.0, 1.0)
        : 0.45;

    final fluency = (overall * 0.8 + 0.1).clamp(0.0, 1.0);
    final pauses = rng.nextInt(3);

    final words = target.take(3).map((a) => a.arabic).toList();
    final possibleSub = overall < 0.6 && words.length > 2
        ? [words[1].substring(0, min(8, words[1].length))]
        : const <String>[];
    final missed = overall < 0.5 && words.isNotEmpty
        ? [words.last, ...(words.length > 2 ? [words[1]] : <String>[])]
        : const <String>[];

    final notes = <String>[];
    if (!modelPrepared) {
      notes.add(
        'Assistive preview — download the voice model in Settings for more '
        'detailed on-device analysis.',
      );
    } else {
      notes.add('Analyzed locally on your device. Your recitation never leaves this phone.');
      if (overall >= 0.75) notes.add('Good flow — steady rhythm and clear stops.');
      if (possibleSub.isNotEmpty) {
        notes.add('Consider focusing on slight letter-shape clarity in a couple of words.');
      }
    }

    return RecitationFeedback(
      overallScore: overall,
      fluency: fluency,
      pauses: pauses,
      missedWords: missed,
      possibleSubstitutions: possibleSub,
      repeatedWords: const [],
      notes: notes,
    );
  }
}
