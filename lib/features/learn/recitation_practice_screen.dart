import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_widgets.dart';
import '../../data/models/skill_type.dart';
import '../../data/quran/quran_data.dart';
import '../../data/quran/quran_models.dart';
import '../../domain/voice/voice_analysis_service.dart';
import '../../services/app_state.dart';

/// Dedicated recitation practice mode.
///
/// The learner picks an ayah/passage, taps "Start Recitation", and receives
/// assistive feedback. All analysis runs on-device when the model is prepared.
/// AI feedback is clearly presented as *assistive*, never as a definitive
/// religious judgment of Tajweed correctness.
class RecitationPracticeScreen extends StatefulWidget {
  const RecitationPracticeScreen({super.key, this.surahNumber, this.startAyah = 1});

  final int? surahNumber;
  final int startAyah;

  @override
  State<RecitationPracticeScreen> createState() => _RecitationPracticeScreenState();
}

enum _Phase { ready, listening, analyzing, feedback }

class _RecitationPracticeScreenState extends State<RecitationPracticeScreen> {
  _Phase _phase = _Phase.ready;
  RecitationFeedback? _feedback;
  Timer? _timer;
  Duration _elapsed = Duration.zero;
  int _surahNumber = 67;
  int _ayahCount = 5;

  @override
  void initState() {
    super.initState();
    _surahNumber = widget.surahNumber ?? 67;
    _ayahCount = _maxAyahs(_surahNumber);
  }

  int _maxAyahs(int surahNumber) {
    final s = QuranDataset.byNumber(surahNumber);
    return s == null ? 5 : s.ayahCount;
  }

  void _start() {
    final app = context.read<AppState>();
    setState(() {
      _phase = _Phase.listening;
      _elapsed = Duration.zero;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() => _elapsed += const Duration(seconds: 1));
    });
    // Begin on-device capture immediately; show an error if the mic fails.
    if (!app.voice.isModelReady) {
      // Model not ready yet: still enter listening so the flow stays obvious,
      // but analysis will report that the model is not installed.
      return;
    }
    app.voice.startRecording(onMicError: (msg) {
      if (!mounted) return;
      setState(() {
        _phase = _Phase.ready;
        _feedback = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    });
  }

  Future<void> _stop() async {
    _timer?.cancel();
    setState(() => _phase = _Phase.analyzing);
    final app = context.read<AppState>();
    final target = QuranDataset.byNumber(_surahNumber)?.ayahs.take(_ayahCount).toList() ??
        [];
    final result = await app.voice.stopAndAnalyze(target: target);

    // Feed the adaptive engine with the reading outcome.
    await app.recordPractice(
      skill: SkillType.reading,
      score: result.overallScore,
      durationMinutes: _elapsed.inSeconds >= 60 ? _elapsed.inSeconds ~/ 60 : 1,
      detail: 'Recitation of surah $_surahNumber',
      best: result.bestMatchWord,
    );

    if (!mounted) return;
    setState(() {
      _phase = _Phase.feedback;
      _feedback = result;
    });
  }

  void _reset() {
    setState(() {
      _phase = _Phase.ready;
      _feedback = null;
      _elapsed = Duration.zero;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final surah = QuranDataset.byNumber(_surahNumber);
    final passage = surah?.ayahs.take(_ayahCount).toList() ?? [];
    final local = app.voice.isLocal;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recitation Practice'),
        actions: [
          Pill(
            label: local ? 'On-device' : 'Cloud',
            icon: local ? Icons.lock_outline : Icons.cloud_outlined,
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    initialValue: _surahNumber,
                    decoration: const InputDecoration(labelText: 'Surah'),
                    items: QuranDataset.all
                        .map((s) => DropdownMenuItem(
                              value: s.number,
                              child: Text('${s.englishName} (${s.number})'),
                            ))
                        .toList(),
                    onChanged: (v) {
                      if (v == null) return;
                      setState(() {
                        _surahNumber = v;
                        _ayahCount = _maxAyahs(v);
                        _reset();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ayahCountSelector(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _passageCard(passage),
            const SizedBox(height: 20),
            _phaseCard(app),
          ],
        ),
      ),
    );
  }

  Widget _ayahCountSelector() {
    return DropdownButtonFormField<int>(
      initialValue: _ayahCount,
      decoration: const InputDecoration(labelText: 'Ayahs'),
      items: [for (var i = 1; i <= _maxAyahs(_surahNumber); i++) DropdownMenuItem(value: i, child: Text('$i'))],
      onChanged: (v) {
        if (v != null) setState(() => _ayahCount = v);
      },
    );
  }

  Widget _passageCard(List<Ayah> passage) {
    return AppCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            QuranDataset.byNumber(_surahNumber)?.englishName ?? '',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          for (final a in passage.take(3))
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    a.arabic,
                    style: const TextStyle(fontFamily: 'AmiriQuran', fontSize: 24, height: 1.9),
                  ),
                  Text('${a.ayahNumber}', style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _phaseCard(AppState app) {
    switch (_phase) {
      case _Phase.ready:
        return Column(
          children: [
            AppCard(
              color: Theme.of(context).colorScheme.primary,
              child: Column(
                children: [
                  Icon(Icons.mic_none_rounded, size: 64, color: Theme.of(context).colorScheme.onPrimary),
                  const SizedBox(height: 12),
                  Text(
                    'Recite the passage above, then stop when finished.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (!app.voice.isModelReady)
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.goldSoft.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: AppColors.gold),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Voice model not installed — you’ll get an assistive preview. '
                        'Install it in Profile → Model Manager for fuller analysis.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _start,
                icon: const Icon(Icons.mic),
                label: const Text('Start Recitation'),
              ),
            ),
          ],
        );
      case _Phase.listening:
        return Column(
          children: [
            _pulseMic(),
            const SizedBox(height: 16),
            Text(
              'Listening… ${_elapsed.inSeconds}s',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text('Processing locally on your device', style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _stop,
                child: const Text('I’ve finished reciting'),
              ),
            ),
          ],
        );
      case _Phase.analyzing:
        return Column(
          children: [
            const SizedBox(height: 40),
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text('Analyzing your recitation on-device…', style: Theme.of(context).textTheme.bodyMedium),
          ],
        );
      case _Phase.feedback:
        return _feedbackCard();
    }
  }

  Widget _pulseMic() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 900),
      builder: (context, value, child) {
        final scheme = Theme.of(context).colorScheme;
        return Container(
          width: 110 + value * 30,
          height: 110 + value * 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: scheme.primary.withValues(alpha: 0.15),
            border: Border.all(color: scheme.primary.withValues(alpha: 0.4), width: 2),
          ),
          child: Icon(Icons.mic_rounded, size: 40, color: scheme.primary),
        );
      },
    );
  }

  Widget _feedbackCard() {
    final f = _feedback!;
    final scheme = Theme.of(context).colorScheme;
    final pct = (f.overallScore * 100).round();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('Reading feedback', style: Theme.of(context).textTheme.titleLarge),
                  const Spacer(),
                  Text('$pct%', style: TextStyle(color: scheme.primary, fontWeight: FontWeight.w800, fontSize: 20)),
                ],
              ),
              const SizedBox(height: 12),
              SkillBar(label: 'Fluency', percent: f.fluency, color: SkillColors.reading),
              const SizedBox(height: 10),
              Text('Pauses detected: ${f.pauses}', style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (f.missedWords.isNotEmpty)
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Words that may have been missed', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 6),
                Wrap(spacing: 6, runSpacing: 6, children: f.missedWords.map((w) => Chip(label: Text(w))).toList()),
              ],
            ),
          ),
        const SizedBox(height: 12),
        if (f.possibleSubstitutions.isNotEmpty)
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Possible substitutions', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: f.possibleSubstitutions
                      .map((w) => Chip(label: Text(w, style: const TextStyle(fontFamily: 'AmiriQuran', fontSize: 20))))
                      .toList(),
                ),
              ],
            ),
          ),
        const SizedBox(height: 12),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final note in f.notes)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.check_circle_outline, size: 18),
                      const SizedBox(width: 8),
                      Expanded(child: Text(note, style: Theme.of(context).textTheme.bodyMedium)),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.goldSoft.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            'AI feedback is assistive. For Tajweed and pronunciation accuracy, '
            'please consult a qualified Quran teacher when appropriate.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(onPressed: _reset, child: const Text('Try again')),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Done'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
