import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../l10n/ext.dart';
import '../../data/models/surah_lesson.dart';
import '../../data/quran/quran_metadata.dart';
import '../../domain/adaptive/surah_lesson_generator.dart';
import '../../services/app_state.dart';
import 'surah_lesson_player_screen.dart';

class LearnScreen extends StatefulWidget {
  const LearnScreen({super.key});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  String _selectedFilter = 'all';

  List<SurahMeta> get _filteredSurahs {
    var surahs = List<SurahMeta>.from(QuranMetadata.allSurahs);

    if (_selectedFilter == 'short') {
      surahs = surahs.where((s) => s.ayahCount <= 7).toList();
    } else if (_selectedFilter == 'medium') {
      surahs = surahs.where((s) => s.ayahCount > 7 && s.ayahCount <= 30).toList();
    } else if (_selectedFilter == 'long') {
      surahs = surahs.where((s) => s.ayahCount > 30).toList();
    }

    return surahs;
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final stats = appState.lessonStats;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(stats),
            _buildNextLessonCard(appState),
            _buildFilterBar(),
            Expanded(child: _buildSurahList(appState)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(LessonStats stats) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.learnTitle, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 4),
          Text(
            context.l10n.learnStatsSummary(
              stats.completedLessons.toString(),
              stats.totalLessons.toString(),
              stats.surahsStarted.toString(),
            ),
            style: TextStyle(
              fontSize: 13,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: stats.completionPercent / 100,
            backgroundColor: Theme.of(context).colorScheme.outlineVariant,
            color: Theme.of(context).colorScheme.primary,
            minHeight: 4,
            borderRadius: BorderRadius.circular(2),
          ),
        ],
      ),
    );
  }

  Widget _buildNextLessonCard(AppState appState) {
    final next = appState.nextSurahLesson;
    if (next == null) return const SizedBox.shrink();
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Card(
        elevation: 0,
        color: scheme.primary.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: scheme.primary.withValues(alpha: 0.3)),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => _startLesson(next),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: scheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.play_arrow, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.learnNextLesson(next.displayTitle),
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        context.l10n.learnLessonDetail(
                          next.ayahRange.fromAyah.toString(),
                          next.ayahRange.toAyah.toString(),
                          next.ayahRange.ayahCount.toString(),
                          next.phases.length.toString(),
                        ),
                        style: TextStyle(
                          fontSize: 12,
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: scheme.primary),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          _filterChip(context.l10n.learnFilterAll, 'all'),
          const SizedBox(width: 8),
          _filterChip(context.l10n.learnFilterShort, 'short'),
          const SizedBox(width: 8),
          _filterChip(context.l10n.learnFilterMedium, 'medium'),
          const SizedBox(width: 8),
          _filterChip(context.l10n.learnFilterLong, 'long'),
        ],
      ),
    );
  }

  Widget _filterChip(String label, String value) {
    final isSelected = _selectedFilter == value;
    return FilterChip(
      label: Text(label, style: const TextStyle(fontSize: 12)),
      selected: isSelected,
      onSelected: (selected) {
        setState(() => _selectedFilter = value);
      },
      selectedColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
      checkmarkColor: Theme.of(context).colorScheme.primary,
      side: BorderSide(
        color: isSelected
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.outlineVariant,
      ),
    );
  }

  Widget _buildSurahList(AppState appState) {
    final surahs = _filteredSurahs;

    if (surahs.isEmpty) {
      return Center(
        child: Text(
          context.l10n.learnNoResults,
          style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      itemCount: surahs.length,
      itemBuilder: (context, index) {
        final surah = surahs[index];
        return _buildSurahCard(surah, appState);
      },
    );
  }

  Widget _buildSurahCard(SurahMeta surah, AppState appState) {
    final lessons = appState.surahLessons(surah.number);
    final completedParts = lessons.where((l) => l.isCompleted).length;
    final totalParts = lessons.length;
    final isFullyCompleted = completedParts == totalParts && totalParts > 0;
    final hasStarted = completedParts > 0;
    final scheme = Theme.of(context).colorScheme;

    Color? cardColor;
    if (isFullyCompleted) {
      cardColor = AppColors.teal.withValues(alpha: 0.08);
    } else if (hasStarted) {
      cardColor = scheme.primary.withValues(alpha: 0.08);
    }

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isFullyCompleted
              ? AppColors.teal
              : hasStarted
                  ? scheme.primary.withValues(alpha: 0.3)
                  : scheme.outlineVariant,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showSurahDetail(surah, appState),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isFullyCompleted
                      ? AppColors.teal.withValues(alpha: 0.15)
                      : scheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: isFullyCompleted
                      ? const Icon(Icons.check, color: AppColors.teal, size: 20)
                      : Text(
                          '${surah.number}',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: hasStarted ? scheme.primary : scheme.onSurfaceVariant,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      surah.englishName,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          context.l10n.learnAyahCount(surah.ayahCount.toString()),
                          style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
                        ),
                        if (totalParts > 1)
                          Text(
                            ' • ${context.l10n.learnPartsCount(totalParts.toString())}',
                            style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
                          ),
                        if (surah.revelationPlace.isNotEmpty)
                          Text(
                            ' • ${surah.revelationPlace}',
                            style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
                          ),
                      ],
                    ),
                    if (hasStarted && !isFullyCompleted) ...[
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: completedParts / totalParts,
                        backgroundColor: scheme.outlineVariant,
                        color: scheme.primary,
                        minHeight: 3,
                        borderRadius: BorderRadius.circular(1.5),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        context.l10n.learnPartsComplete(
                          completedParts.toString(),
                          totalParts.toString(),
                        ),
                        style: TextStyle(fontSize: 11, color: scheme.primary),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                surah.name,
                style: const TextStyle(
                  fontFamily: 'AmiriQuran',
                  fontSize: 20,
                  color: Color(0xFF1A1A2E),
                ),
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(width: 4),
              Icon(Icons.chevron_right, color: scheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }

  void _showSurahDetail(SurahMeta surah, AppState appState) {
    final lessons = appState.surahLessons(surah.number);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        expand: false,
        builder: (context, scrollController) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            surah.englishName,
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${surah.name} • ${context.l10n.learnAyahCount(surah.ayahCount.toString())} • ${surah.revelationPlace}',
                            style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      surah.name,
                      style: const TextStyle(
                        fontFamily: 'AmiriQuran',
                        fontSize: 32,
                        color: Color(0xFF1A1A2E),
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  context.l10n.learnLessonParts,
                  style: TextStyle(fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: lessons.length,
                    itemBuilder: (context, index) {
                      final lesson = lessons[index];
                      return _buildPartCard(lesson, appState);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPartCard(SurahLesson lesson, AppState appState) {
    final isCompleted = lesson.isCompleted;
    final mastery = lesson.masteryScore;
    final scheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      color: isCompleted ? AppColors.teal.withValues(alpha: 0.08) : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: isCompleted ? AppColors.teal : scheme.outlineVariant),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isCompleted
              ? AppColors.teal.withValues(alpha: 0.15)
              : scheme.primary.withValues(alpha: 0.1),
          child: isCompleted
              ? const Icon(Icons.check, color: AppColors.teal, size: 18)
              : Icon(Icons.play_arrow, color: scheme.primary, size: 18),
        ),
        title: Text(
          lesson.isSinglePart
              ? context.l10n.learnFullSurah(lesson.ayahRange.ayahCount.toString())
              : context.l10n.learnPartOf(
                  lesson.partNumber.toString(),
                  lesson.totalParts.toString(),
                  lesson.ayahRange.fromAyah.toString(),
                  lesson.ayahRange.toAyah.toString(),
                ),
          style: const TextStyle(fontSize: 14),
        ),
        subtitle: Text(
          isCompleted && mastery != null
              ? context.l10n.learnCompleteScore((mastery * 100).round().toString())
              : isCompleted
                  ? context.l10n.learnComplete
                  : lesson.phases.map((p) => p.label).join(' → '),
          style: TextStyle(
            fontSize: 12,
            color: isCompleted ? AppColors.teal : scheme.onSurfaceVariant,
          ),
        ),
        trailing: isCompleted
            ? null
            : ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _startLesson(lesson);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: scheme.primary,
                  foregroundColor: scheme.onPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(context.l10n.learnStart, style: const TextStyle(fontSize: 12)),
              ),
      ),
    );
  }

  void _startLesson(SurahLesson lesson) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SurahLessonPlayerScreen(lesson: lesson)),
    );
  }
}
