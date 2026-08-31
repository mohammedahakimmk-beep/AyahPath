import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_whisper/flutter_whisper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../data/quran/quran_models.dart';
import 'arabic_matcher.dart';
import 'voice_analysis_service.dart';

/// On-device recitation recognition using the Tarteel AI Quran model.
///
/// Pipeline:
///   1. The Tarteel AI model (a Whisper-architecture speech model fine-tuned
///      on Quran recitation) is bundled with the app and runs locally via the
///      whisper.cpp engine — no cloud, no account, fully on this phone.
///   2. A Tarteel-style ayah matcher aligns the transcript against the trusted
///      target ayah text (diacritics normalized) and scores it.
class WhisperVoiceAnalysisService implements VoiceAnalysisService {
  WhisperVoiceAnalysisService({Whisper? whisper}) : _whisper = whisper ?? Whisper();

  /// Bundled Tarteel AI model asset path (Q8_0 quantized, ~78 MB).
  static const String modelAssetPath = 'assets/models/tarteel-q8.bin';

  final Whisper _whisper;

  bool _preparing = false;
  bool _ready = false;
  bool _recording = false;
  String? _lastError;

  @override
  bool get isLocal => true;

  @override
  bool get isModelReady => _ready;

  /// Whether the microphone is currently capturing.
  bool get isRecording => _recording;

  /// Last failure message from model preparation (for the UI).
  String? get lastError => _lastError;

  /// Copies the bundled Tarteel model into app support storage (once) and
  /// loads it, so whisper.cpp can read it from a real file path.
  @override
  Future<bool> prepareModel() async {
    if (_ready) return true;
    if (_preparing) {
      while (_preparing) {
        await Future<void>.delayed(const Duration(milliseconds: 100));
      }
      return _ready;
    }
    _preparing = true;
    try {
      final dir = await getApplicationSupportDirectory();
      final target = File('${dir.path}/models/tarteel-q8.bin');
      final modelFile = await _provisionModel(target);
      await _whisper.initializeFromFile(
        modelPath: modelFile.path,
        options: const WhisperOptions(
          language: 'ar', // transcribe Arabic recitation
          vad: true,
        ),
      );
      _ready = true;
      _lastError = null;
      return true;
    } catch (e) {
      _lastError = e.toString();
      _ready = false;
      return false;
    } finally {
      _preparing = false;
    }
  }

  Future<File> _provisionModel(File target) async {
    if (target.existsSync() && target.lengthSync() > 1024 * 1024) {
      return target;
    }
    target.parent.createSync(recursive: true);
    final data = await rootBundle.load(modelAssetPath);
    target.writeAsBytesSync(
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
      flush: true,
    );
    return target;
  }

  /// Release the loaded engine and remove the copied model file to reclaim
  /// storage (the bundled asset remains in the APK for re-provisioning).
  @override
  Future<void> deleteModel() async {
    try {
      _recording = false;
      await _whisper.dispose();
    } catch (_) {}
    _ready = false;
    _lastError = null;
    try {
      final dir = await getApplicationSupportDirectory();
      final modelFile = File('${dir.path}/models/tarteel-q8.bin');
      if (modelFile.existsSync()) modelFile.deleteSync();
    } catch (_) {}
  }

  /// Start capturing the microphone. Call [stopAndAnalyze] when done.
  ///
  /// Returns false and records a note if the mic could not be started.
  /// [onMicError] receives a user-facing message when recording cannot begin
  /// (e.g. permission denied or the device has no microphone).
  @override
  Future<bool> startRecording({void Function(String)? onMicError}) async {
    if (!_ready) {
      onMicError?.call(
        'The on-device model is not ready yet. Install it in Settings first '
        'so recitation runs locally.',
      );
      return false;
    }
    if (_recording) return true;

    final granted = await Permission.microphone.request().isGranted;
    if (!granted) {
      onMicError?.call('Microphone permission was not granted.');
      return false;
    }

    try {
      await _whisper.startRecording();
      _recording = true;
      return true;
    } catch (e) {
      onMicError?.call('Could not start the microphone: $e');
      return false;
    }
  }

  /// Stop recording, transcribe, and return scored feedback for [target].
  @override
  Future<RecitationFeedback> stopAndAnalyze({required List<Ayah> target}) async {
    final stopwatch = Stopwatch()..start();
    String? wavPath;
    try {
      wavPath = await _whisper.stopRecording();
      _recording = false;
    } catch (e) {
      _recording = false;
      return RecitationFeedback(
        overallScore: 0.0,
        fluency: 0.0,
        pauses: 0,
        notes: ['Could not stop recording: $e'],
      );
    }
    stopwatch.stop();
    final recordedDuration = stopwatch.elapsed;

    TranscriptionResult result;
    try {
      result = await _whisper.transcribeFile(
        wavPath,
        options: const WhisperOptions(
          language: 'ar',
          vad: true,
          wordTimestamps: true,
        ),
      );
    } catch (e) {
      return RecitationFeedback(
        overallScore: 0.0,
        fluency: 0.0,
        pauses: 0,
        notes: ['Transcription failed: $e'],
      );
    }

    return _score(
      target: target,
      transcript: result.text,
      segments: result.segments,
      recordedDuration: recordedDuration,
    );
  }

  /// Convenience: record for [duration], then analyze. Prefer the explicit
  /// [startRecording]/[stopAndAnalyze] pair in the live UI so the wait does
  /// not double up.
  @override
  Future<RecitationFeedback> analyze({
    required List<Ayah> target,
    Duration? duration,
  }) async {
    final started = await startRecording();
    if (!started) {
      return RecitationFeedback(
        overallScore: 0.0,
        fluency: 0.0,
        pauses: 0,
        notes: ['Could not start recording; on-device analysis was not run.'],
      );
    }
    await Future<void>.delayed(duration ?? const Duration(seconds: 12));
    return stopAndAnalyze(target: target);
  }

  RecitationFeedback _score({
    required List<Ayah> target,
    required String transcript,
    required List<TranscriptionSegment> segments,
    required Duration recordedDuration,
  }) {
    final spokenNorm = ArabicMatcher.normalize(transcript);
    final spokenWords = ArabicMatcher.words(spokenNorm);

    final expectedNorm = target.map((a) => ArabicMatcher.normalize(a.arabic)).join(' ');
    final expectedWords = ArabicMatcher.words(expectedNorm);

    final alignment = ArabicMatcher.align(
      expectedWords: expectedWords,
      spokenWords: spokenWords,
    );

    var pauses = 0;
    for (var i = 1; i < segments.length; i++) {
      final gap = segments[i].start - segments[i - 1].end;
      if (gap > 0.6) pauses++;
    }

    final secs = recordedDuration.inMilliseconds / 1000.0;
    final rate = expectedWords.isEmpty ? 0.0 : expectedWords.length / (secs == 0 ? 1 : secs);
    const expectedRate = 1.6;
    final rawRateScore = (rate / expectedRate).clamp(0.0, 1.4);
    final rateScore = rawRateScore > 1.0 ? 1.0 : rawRateScore;
    final completeness =
        expectedWords.isEmpty ? 0.0 : (alignment.matches.length / expectedWords.length);
    final fluency = (rateScore * 0.55 + completeness * 0.45).clamp(0.0, 1.0);

    final notes = <String>[];
    notes.add('Analyzed locally on this device by a Whisper model — your '
        'recitation never leaves your phone.');

    if (alignment.overallScore >= 0.8) {
      notes.add('MashaAllah — strong recitation. Good coverage and clear words.');
    } else if (alignment.overallScore >= 0.55) {
      notes.add('Good progress. A few words differed from the ayah — review them below.');
    } else {
      notes.add('Keep practicing. Try reciting a little slower and pause '
          'between ayahs so each word is detected clearly.');
    }
    if (alignment.missedWords.isNotEmpty) {
      notes.add('Likely missed or unclear: ${alignment.missedWords.take(4).join('، ')}.');
    }
    if (alignment.substitutions.isNotEmpty) {
      notes.add('Possible substitutions/extra words: '
          '${alignment.substitutions.take(4).join('، ')}.');
    }

    return RecitationFeedback(
      overallScore: alignment.overallScore,
      fluency: fluency,
      pauses: pauses,
      missedWords: alignment.missedWords,
      possibleSubstitutions: alignment.substitutions,
      repeatedWords: const [],
      notes: notes,
    );
  }
}
