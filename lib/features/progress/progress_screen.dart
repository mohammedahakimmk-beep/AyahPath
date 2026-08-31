import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_widgets.dart';
import '../../data/models/learner_profile.dart';
import '../../data/models/skill_type.dart';
import '../../services/app_state.dart';

/// Detailed but understandable progress overview.
class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);
    final p = app.profile;
    return Scaffold(
      appBar: AppBar(title: const Text('Progress')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            _overallCard(context, p.overallProgress),
            const SizedBox(height: 20),
            const SectionHeader(title: 'Skills'),
            const SizedBox(height: 12),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final skill in SkillType.values)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: SkillBar(
                        label: skill.label,
                        percent: p.stateOf(skill).confidence,
                        color: _colorFor(skill),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const SectionHeader(title: 'Learning activity'),
            const SizedBox(height: 12),
            AppCard(
              child: Row(
                children: [
                  _stat(context, '${p.lessonsCompleted}', 'Lessons'),
                  _divider(context),
                  _stat(context, _minutes(p.totalPracticeMinutes), 'Practice'),
                  _divider(context),
                  _stat(context, '${p.currentStreak}', 'Streak'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const SectionHeader(title: 'Memorization'),
            const SizedBox(height: 12),
            _memorizationCard(context, p),
            const SizedBox(height: 20),
            _masteryCard(context, p),
          ],
        ),
      ),
    );
  }

  Widget _overallCard(BuildContext context, double progress) {
    final scheme = Theme.of(context).colorScheme;
    final pct = (progress * 100).round();
    return AppCard(
      color: scheme.primary,
      child: Row(
        children: [
          _ring(progress, 64, Colors.white),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Overall learning',
                  style: TextStyle(color: scheme.onPrimary, fontSize: 13, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  '$pct%',
                  style: TextStyle(color: scheme.onPrimary, fontSize: 34, fontWeight: FontWeight.w800),
                ),
                Text(
                  'A steady, personal journey — not a competition.',
                  style: TextStyle(color: scheme.onPrimary.withValues(alpha: 0.8), fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _ring(double value, double size, Color color) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircularProgressIndicator(
            value: value.clamp(0.0, 1.0),
            strokeWidth: 6,
            backgroundColor: color.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation(color),
          ),
          Center(
            child: Text(
              '${(value * 100).round()}%',
              style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat(BuildContext context, String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: Theme.of(context).textTheme.titleLarge),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }

  Widget _divider(BuildContext context) {
    return Container(width: 1, height: 36, color: Theme.of(context).dividerColor);
  }

  Widget _memorizationCard(BuildContext context, LearnerProfile p) {
    final entries = p.memorization.values.toList();
    if (entries.isEmpty) {
      return const AppCard(
        child: Text('No memorized surahs tracked yet. Mark ayahs in the Qur’an reader to begin.'),
      );
    }
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final e in entries)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: SkillBar(
                label: '${e.surahName} (${e.memorizedAyahs}/${e.totalAyahs})',
                percent: e.progress,
                color: SkillColors.memorization,
              ),
            ),
        ],
      ),
    );
  }

  Widget _masteryCard(BuildContext context, LearnerProfile p) {
    final mastered = p.skills.entries.where((e) => e.value.mastered).map((e) => e.key).toList();
    final developing = p.skills.entries.where((e) => !e.value.mastered).map((e) => e.key).toList();
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Mastered', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            mastered.isEmpty
                ? 'Still developing — every steady session counts.'
                : mastered.map((s) => s.label).join(', '),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 14),
          Text('Developing', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            developing.map((s) => s.label).join(', '),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  String _minutes(int min) {
    if (min < 60) return '$min min';
    final h = min ~/ 60;
    final m = min % 60;
    return '${h}h ${m}m';
  }

  Color _colorFor(SkillType s) {
    switch (s) {
      case SkillType.reading:
        return SkillColors.reading;
      case SkillType.tajweed:
        return SkillColors.tajweed;
      case SkillType.memorization:
        return SkillColors.memorization;
      case SkillType.revision:
        return SkillColors.revision;
      case SkillType.comprehension:
        return SkillColors.comprehension;
      case SkillType.fluency:
        return SkillColors.reading;
    }
  }
}
