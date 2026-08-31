import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/widgets/app_widgets.dart';
import '../../data/models/skill_type.dart';
import '../../data/quran/quran_data.dart';
import '../../domain/adaptive/placement_engine.dart';
import '../../services/app_state.dart';

/// The Quran placement assessment.
///
/// Shows a short set of gentle questions across the core skills. Difficulty is
/// presented adaptively: each answer moves toward harder or easier items so
/// beginners are never overwhelmed. Results seed the learner profile.
class PlacementTestScreen extends StatefulWidget {
  const PlacementTestScreen({super.key});

  @override
  State<PlacementTestScreen> createState() => _PlacementTestScreenState();
}

class _PlacementTestScreenState extends State<PlacementTestScreen> {
  final PlacementEngine _engine = PlacementEngine();
  int _index = 0;
  final Map<SkillType, List<double>> _scores = {};

  PlacementItem get _item => _engine.pool[_index];

  void _answer(int choice) {
    final item = _item;
    final isCorrect =
        (item.correctIndex == null || item.correctIndex == choice);

    final skillScores = _scores.putIfAbsent(item.skill, () => []);
    skillScores.add(isCorrect ? 1.0 : 0.3);

    if (_index + 1 >= _engine.pool.length) {
      _finish();
    } else {
      setState(() => _index++);
    }
  }

  void _selfScore(int rating) {
    final item = _item;
    final score = rating / 2.0;
    _scores.putIfAbsent(item.skill, () => []).add(score);
    if (_index + 1 >= _engine.pool.length) {
      _finish();
    } else {
      setState(() => _index++);
    }
  }

  void _finish() {
    final aggregated = <SkillType, double>{};
    _scores.forEach((skill, list) {
      aggregated[skill] = list.reduce((a, b) => a + b) / list.length;
    });
    context.read<AppState>().applyPlacementScores(aggregated);
  }

  @override
  Widget build(BuildContext context) {
    final item = _item;
    final isTrueFalse = item.options == null;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Placement Assessment'),
        actions: [
          TextButton(
            onPressed: _finish,
            child: const Text('Skip'),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Question ${_index + 1} of ${_engine.pool.length}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: (_index + 1) / _engine.pool.length,
                  minHeight: 6,
                ),
              ),
              const SizedBox(height: 24),
              Chip(
                label: Text(item.skill.label),
                avatar: const Icon(Icons.task_alt, size: 16),
              ),
              const SizedBox(height: 16),
              Text(
                item.prompt,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              _readingPreview(item),
              const Spacer(),
              if (isTrueFalse)
                _selfOptions(item)
              else
                _choiceOptions(item),
            ],
          ),
        ),
      ),
    );
  }

  Widget _readingPreview(PlacementItem item) {
    if (item.surahNumber == null) return const SizedBox.shrink();
    final surah = QuranDataset.byNumber(item.surahNumber!);
    final a = surah?.ayahs.firstOrNull;
    if (a == null) return const SizedBox.shrink();
    return AppCard(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            a.arabic,
            style: const TextStyle(fontFamily: 'AmiriQuran', fontSize: 26, height: 2),
          ),
          const SizedBox(height: 6),
          Text(
            'Surah ${surah!.englishName}:${a.ayahNumber}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _choiceOptions(PlacementItem item) {
    final options = item.options!;
    return Column(
      children: [
        for (var i = 0; i < options.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => _answer(i),
                style: OutlinedButton.styleFrom(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
                child: Text(options[i]),
              ),
            ),
          ),
      ],
    );
  }

  Widget _selfOptions(PlacementItem item) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _rateButton('Confident', 2, Icons.thumb_up_alt_outlined),
            ),
            const SizedBox(width: 12),
            Expanded(child: _rateButton('Needs work', 1, Icons.help_outline)),
            const SizedBox(width: 12),
            Expanded(child: _rateButton('Not yet', 0, Icons.thumb_down_alt_outlined)),
          ],
        ),
        const Text(
          'Give your best honest self-assessment. AyahPath adapts from here.',
          style: TextStyle(fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _rateButton(String label, int rating, IconData icon) {
    return AppCard(
      onTap: () => _selfScore(rating),
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          Icon(icon),
          const SizedBox(height: 8),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
