import '../../data/quran/quran_models.dart';

/// Outcome of analyzing a recitation attempt.
class RecitationFeedback {
  const RecitationFeedback({
    required this.overallScore,
    required this.fluency,
    required this.pauses,
    this.missedWords = const [],
    this.possibleSubstitutions = const [],
    this.repeatedWords = const [],
    this.notes = const [],
  });

  /// 0..1 overall quality.
  final double overallScore;

  /// 0..1 fluency rating.
  final double fluency;

  /// Number of detected pauses.
  final int pauses;

  final List<String> missedWords;
  final List<String> possibleSubstitutions;
  final List<String> repeatedWords;
  final List<String> notes;

  bool get isEmpty =>
      missedWords.isEmpty &&
      possibleSubstitutions.isEmpty &&
      repeatedWords.isEmpty;

  String get bestMatchWord =>
      possibleSubstitutions.isNotEmpty ? possibleSubstitutions.first : '';
}

/// Abstract on-device voice analysis contract.
///
/// AyahPath keeps recitation analysis on-device whenever possible. Concrete
/// implementations can wrap ONNX Runtime / TFLite / MediaPipe Arabic speech
/// models. The app never presents AI analysis as a definitive religious ruling.
abstract class VoiceAnalysisService {
  /// True when analysis runs fully on-device.
  bool get isLocal;

  /// Whether the required voice model has been downloaded.
  bool get isModelReady;

  /// Download (or prepare) the on-device voice model.
  Future<bool> prepareModel();

  /// Analyze an audio clip of the learner reciting [target] ayahs.
  ///
  /// This is the plug point where a real speech-to-text + alignment model is
  /// wired in. The current [SimulatedVoiceAnalysisService] returns structured,
  /// clearly-assistive feedback without a real model.
  Future<RecitationFeedback> analyze({
    required List<Ayah> target,
    Duration? duration,
  });
}
