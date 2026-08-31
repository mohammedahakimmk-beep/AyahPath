import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/widgets/app_widgets.dart';
import '../../data/models/skill_type.dart';
import '../../l10n/ext.dart';
import '../../data/quran/quran_data.dart';
import '../../services/app_state.dart';
import '../learn/recitation_practice_screen.dart';

/// Practice hub: recitation, assessment, and Hifz revision.
class PracticeScreen extends StatelessWidget {
  const PracticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.practiceTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            _primeAction(context),
            const SizedBox(height: 20),
            SectionHeader(title: context.l10n.practiceQuickAssessment),
            const SizedBox(height: 12),
            _assessmentCard(context),
            const SizedBox(height: 20),
            SectionHeader(title: context.l10n.practiceHifzRevision),
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
                  context.l10n.practiceStartRecitation,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  app.voice.isLocal ? context.l10n.practiceAnalyzedOnDevice : context.l10n.practiceCloudAnalysis,
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
          Text(context.l10n.practiceAssessSkill, style: Theme.of(context).textTheme.titleMedium),
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
    final labels = [context.l10n.practiceTough, context.l10n.practiceOkay, context.l10n.practiceGood, context.l10n.practiceEasy];
    return Row(
      children: [
        Expanded(
          child: Text(skill.localizedLabel(context.l10n), style: Theme.of(context).textTheme.bodyMedium),
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
                  SnackBar(content: Text(context.l10n.practiceAssessmentRecorded(skill.localizedLabel(context.l10n), labels[r - 1]))),
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
      return AppCard(
        child: Text(context.l10n.practiceNoSurahsDue),
      );
    }
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.practiceDueForRevision, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 10),
          for (final entry in due)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.refresh_rounded, color: Color(0xFF8A5BB0)),
              title: Text(entry.surahName),
              subtitle: Text(context.l10n.practiceDayInterval(entry.reviewIntervalDays)),
              trailing: FilledButton.tonal(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => _ReciteSurahScreen(surahNumber: entry.surahNumber),
                    ),
                  );
                },
                child: Text(context.l10n.practiceReview),
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
      appBar: AppBar(title: Text(surah?.englishName ?? context.l10n.practiceRevise)),
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
                    Text(context.l10n.practiceReciteFromMemory(surah?.englishName ?? ''), textAlign: TextAlign.center),
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
                      child: Text(context.l10n.practiceNeedsMoreWork),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () async {
                        context.read<AppState>().reviewMemorized(surahNumber, strong: true);
                        if (context.mounted) Navigator.pop(context);
                      },
                      child: Text(context.l10n.practiceRecitedWell),
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
