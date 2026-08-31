import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_widgets.dart';
import '../../data/models/skill_type.dart';
import '../../services/app_state.dart';
import '../learn/surah_lesson_player_screen.dart';
import '../practice/practice_screen.dart';
import '../quran/quran_reader_screen.dart';

/// Clean, welcoming, Quran-centered dashboard.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<AppState>(
          builder: (context, app, _) {
            final p = app.profile;
            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              children: [
                _Header(streak: p.currentStreak),
                const SizedBox(height: 8),
                Text('Continue your learning', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 4),
                Text(
                  '${p.journeySurahName ?? 'Al-Mulk'} · ${p.lessonsCompleted} lessons completed',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 18),
                _TodayLessonCard(
                  onTap: () => _openNextLesson(context),
                ),
                const SizedBox(height: 22),
                const SectionHeader(title: 'Your skills'),
                const SizedBox(height: 12),
                _SkillsOverview(),
                const SizedBox(height: 22),
                const SectionHeader(title: 'Recommended practice'),
                const SizedBox(height: 12),
                _Recommended(),
                const SizedBox(height: 22),
                const SectionHeader(title: 'Current Journey'),
                const SizedBox(height: 12),
                _JourneyCard(),
              ],
            );
          },
        ),
      ),
    );
  }

  void _openNextLesson(BuildContext context) {
    final app = Provider.of<AppState>(context, listen: false);
    final next = app.nextSurahLesson;
    if (next == null) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const PracticeScreen()),
      );
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => SurahLessonPlayerScreen(lesson: next)),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.streak});
  final int streak;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'AYAHPath',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontFamily: 'AmiriQuran',
                      fontWeight: FontWeight.w800,
                      color: scheme.primary,
                    ),
              ),
              const Text(
                'Peaceful daily guidance',
                style: TextStyle(fontSize: 13),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: scheme.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Icon(Icons.local_fire_department, color: AppColors.gold, size: 18),
              const SizedBox(width: 6),
              Text('$streak day streak', style: const TextStyle(fontWeight: FontWeight.w800)),
            ],
          ),
        ),
      ],
    );
  }
}

class _TodayLessonCard extends StatelessWidget {
  const _TodayLessonCard({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);
    final next = app.nextSurahLesson;
    final lesson = app.currentLesson;
    final minutes = lesson?.estimatedMinutes ?? 15;
    final scheme = Theme.of(context).colorScheme;
    final title = next != null
        ? next.displayTitle
        : (lesson?.title ?? 'Today’s Lesson');
    final subtitle = next != null
        ? 'Ayahs ${next.ayahRange.fromAyah}-${next.ayahRange.toAyah} • ${next.ayahRange.ayahCount} ayahs'
        : '${lesson?.steps.length ?? 5} steps · $minutes minutes';
    return AppCard(
      onTap: onTap,
      color: scheme.primary,
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Today’s Lesson',
            style: TextStyle(color: scheme.onPrimary, fontSize: 13, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: TextStyle(color: scheme.onPrimary.withValues(alpha: 0.95), fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(color: scheme.onPrimary.withValues(alpha: 0.85), fontSize: 14),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: scheme.onPrimary.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Text(
                    'Start Lesson',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SkillsOverview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);
    final p = app.profile;
    final items = [
      ('Reading', p.stateOf(SkillType.reading).confidence, SkillColors.reading),
      ('Tajweed', p.stateOf(SkillType.tajweed).confidence, SkillColors.tajweed),
      ('Memorization', p.stateOf(SkillType.memorization).confidence, SkillColors.memorization),
    ];
    return Column(
      children: [
        for (final (label, conf, color) in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: SkillBar(label: label, percent: conf, color: color),
          ),
      ],
    );
  }
}

class _Recommended extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);
    final p = app.profile;
    final weak = p.skillsNeedingPractice();
    final review = p.surahsNeedingReview();
    final items = <Widget>[];

    if (weak.isNotEmpty) {
      items.add(_RecoItem(
        icon: Icons.hearing_rounded,
        title: 'Practice ${weak.first.label}',
        subtitle: 'A short focused session will help most.',
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const PracticeScreen()),
        ),
      ));
    }
    if (review.isNotEmpty) {
      items.add(_RecoItem(
        icon: Icons.refresh_rounded,
        title: 'Review ${review.first.surahName}',
        subtitle: 'Due for spaced revision today.',
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => QuranReaderScreen(surahNumber: review.first.surahNumber),
          ),
        ),
      ));
    }
    if (items.isEmpty) {
      items.add(const _RecoItem(
        icon: Icons.auto_stories,
        title: 'Continue your reading',
        subtitle: 'Pick up where you left off at a gentle pace.',
      ));
    }
    return Column(
      children: [
        for (final item in items) ...[
          item,
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _RecoItem extends StatelessWidget {
  const _RecoItem({required this.icon, required this.title, required this.subtitle, this.onTap});
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 2),
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          if (onTap != null)
            Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.outline),
        ],
      ),
    );
  }
}

class _JourneyCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);
    final p = app.profile;
    final progress = p.journeyProgress;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.menu_book, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 10),
              Text(
                p.journeySurahName ?? 'Al-Mulk',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 14),
          SkillBar(label: 'Journey progress', percent: progress, color: SkillColors.reading),
          const SizedBox(height: 6),
          Text(
            'Moved ${(progress * 100).round()}% of the way through your current surah.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
