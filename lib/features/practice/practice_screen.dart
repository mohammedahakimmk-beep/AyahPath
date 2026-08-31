import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/widgets/app_widgets.dart';
import '../../data/models/skill_type.dart';
import '../../data/quran/quran_data.dart';
import '../../services/app_state.dart';
import '../learn/recitation_practice_screen.dart';

/// Practice hub: recitation, assessment, and Hifz revision.
class PracticeScreen extends StatelessWidget {
  const PracticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Practice')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            _primeAction(context),
            const SizedBox(height: 20),
            const SectionHeader(title: 'Quick assessment'),
            const SizedBox(height: 12),
            _assessmentCard(context),
            const SizedBox(height: 20),
            const SectionHeader(title: 'Hifz & revision'),
            const SizedBox(height: 12),
            _revisionCard(context),
          ],
        ),
      ),
    );
  }

  Widget _primeAction(BuildContext context) {
    final app = Provider.of<AppState>(context);
    return AppCard(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const RecitationPracticeScreen()),
      ),
      color: Theme.of(context).colorScheme.primary,
      child: Row(
        children: [
          Icon(Icons.mic_rounded, color: Theme.of(context).colorScheme.onPrimary, size: 40),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Start Recitation',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  app.voice.isLocal ? 'Analyzed on-device · private' : 'Cloud analysis',
                  style: TextStyle(color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.85), fontSize: 13),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.onPrimary),
        ],
      ),
    );
  }

  Widget _assessmentCard(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Assess a skill', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          for (final skill in SkillType.values.take(4))
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: _assessRow(context, skill),
            ),
        ],
      ),
    );
  }

  Widget _assessRow(BuildContext context, SkillType skill) {
    const labels = ['Tough', 'Okay', 'Good', 'Easy'];
    return Row(
      children: [
        Expanded(
          child: Text(skill.label, style: Theme.of(context).textTheme.bodyMedium),
        ),
        for (var r = 1; r <= 4; r++)
          IconButton(
            visualDensity: VisualDensity.compact,
            tooltip: labels[r - 1],
            icon: Icon(Icons.circle, size: 20, color: Theme.of(context).colorScheme.outlineVariant),
            onPressed: () async {
              await context.read<AppState>().applyAssessment(skill, r);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${skill.label}: ${labels[r - 1]} recorded')),
                );
              }
            },
          ),
      ],
    );
  }

  Widget _revisionCard(BuildContext context) {
    final app = Provider.of<AppState>(context);
    final due = app.profile.surahsNeedingReview();
    if (due.isEmpty) {
      return const AppCard(
        child: Text('No surahs due for revision right now. Keep your steady rhythm going.'),
      );
    }
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Due for revision', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 10),
          for (final entry in due)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.refresh_rounded, color: Color(0xFF8A5BB0)),
              title: Text(entry.surahName),
              subtitle: Text('${entry.reviewIntervalDays} day interval'),
              trailing: FilledButton.tonal(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => _ReciteSurahScreen(surahNumber: entry.surahNumber),
                    ),
                  );
                },
                child: const Text('Review'),
              ),
            ),
        ],
      ),
    );
  }
}

class _ReciteSurahScreen extends StatelessWidget {
  const _ReciteSurahScreen({required this.surahNumber});
  final int surahNumber;

  @override
  Widget build(BuildContext context) {
    final surah = QuranDataset.byNumber(surahNumber);
    return Scaffold(
      appBar: AppBar(title: Text(surah?.englishName ?? 'Revise')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              AppCard(
                child: Column(
                  children: [
                    Icon(Icons.menu_book, size: 64, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(height: 12),
                    Text('Recite ${surah?.englishName ?? ''} from memory, then mark how it went.', textAlign: TextAlign.center),
                  ],
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        context.read<AppState>().reviewMemorized(surahNumber, strong: false);
                        if (context.mounted) Navigator.pop(context);
                      },
                      child: const Text('Needs more work'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () async {
                        context.read<AppState>().reviewMemorized(surahNumber, strong: true);
                        if (context.mounted) Navigator.pop(context);
                      },
                      child: const Text('Recited well'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
