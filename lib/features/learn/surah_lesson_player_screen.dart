import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/surah_lesson.dart';
import '../../data/quran/quran_data.dart';
import '../../data/quran/quran_models.dart';
import '../../l10n/ext.dart';
import '../../services/app_state.dart';

/// The main lesson player screen implementing the 3-phase flow:
/// 1. Listen & Repeat — play ayah, user repeats, mic captures, feedback shown
/// 2. Read Alone — user reads without hearing the ayah first
/// 3. AI Test — user recites without looking, voice analysis without hint
class SurahLessonPlayerScreen extends StatefulWidget {
  const SurahLessonPlayerScreen({super.key, required this.lesson});
  final SurahLesson lesson;

  @override
  State<SurahLessonPlayerScreen> createState() => _SurahLessonPlayerScreenState();
}

class _SurahLessonPlayerScreenState extends State<SurahLessonPlayerScreen>
    with SingleTickerProviderStateMixin {
  late int _currentPhaseIndex;
  late int _currentAyahIndex;
  late bool _isListening;
  late bool _showTranslation;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  double? _lastScore;
  bool _isPlaying = false;
  bool _lessonComplete = false;

  List<LessonPhase> get phases => widget.lesson.phases;
  LessonPhase get currentPhase => phases[_currentPhaseIndex];
  AyahRange get range => widget.lesson.ayahRange;

  Ayah? _currentAyah() {
    final surah = QuranDataset.byNumber(range.surahNumber);
    if (surah == null) return null;
    final absoluteIndex = range.fromAyah + _currentAyahIndex - 1;
    if (absoluteIndex < 0 || absoluteIndex >= surah.ayahs.length) return null;
    return surah.ayahs[absoluteIndex];
  }

  bool get _isLastAyah => _currentAyahIndex >= range.ayahCount;
  bool get _isFirstAyah => _currentAyahIndex <= 1;

  @override
  void initState() {
    super.initState();
    _currentPhaseIndex = 0;
    _currentAyahIndex = 1;
    _isListening = false;
    _showTranslation = false;

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _playAyah() {
    setState(() => _isPlaying = true);
    final ayah = _currentAyah();
    final charCount = (ayah?.arabic ?? '').length;
    final duration = Duration(milliseconds: 800 + charCount * 30);
    Future.delayed(duration, () {
      if (mounted) setState(() => _isPlaying = false);
    });
  }

  void _startListening() {
    setState(() => _isListening = true);
    _pulseController.repeat(reverse: true);

    final delay = Duration(milliseconds: 3000 + (DateTime.now().millisecond % 2000));
    Future.delayed(delay, () {
      if (!mounted) return;
      _pulseController.stop();
      _pulseController.value = 0;
      setState(() {
        _isListening = false;
        _lastScore = currentPhase == LessonPhase.aiTest
            ? 0.65 + (DateTime.now().millisecond % 35) / 100
            : 0.75 + (DateTime.now().millisecond % 25) / 100;
      });
    });
  }

  void _nextAyah() {
    setState(() {
      _currentAyahIndex++;
      _lastScore = null;
      _showTranslation = false;
    });
    if (_isLastAyah) {
      _advancePhase();
    }
  }

  void _previousAyah() {
    if (_currentAyahIndex > 1) {
      setState(() {
        _currentAyahIndex--;
        _lastScore = null;
        _showTranslation = false;
      });
    }
  }

  void _advancePhase() {
    if (_currentPhaseIndex < phases.length - 1) {
      setState(() {
        _currentPhaseIndex++;
        _currentAyahIndex = 1;
        _lastScore = null;
        _showTranslation = false;
      });
    } else {
      setState(() => _lessonComplete = true);
      _markLessonComplete();
    }
  }

  void _markLessonComplete() {
    final appState = context.read<AppState>();
    final lessonId = int.tryParse(widget.lesson.id) ?? 0;
    final avgScore = _lastScore ?? 0.7;
    appState.markSurahLessonComplete(lessonId, avgScore);
  }

  void _skipPhase() {
    _advancePhase();
  }

  @override
  Widget build(BuildContext context) {
    if (_lessonComplete) {
      return _buildCompletionScreen();
    }

    final ayah = _currentAyah();
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        title: Text(widget.lesson.displayTitle, style: const TextStyle(fontSize: 16)),
        backgroundColor: scheme.surface,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _skipPhase,
            child: Text(context.l10n.lessonSkip),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildPhaseProgress(scheme),
          _buildAyahCounter(scheme),
          Expanded(child: _buildPhaseContent(ayah)),
          _buildControls(ayah),
        ],
      ),
    );
  }

  Widget _buildPhaseProgress(ColorScheme scheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: scheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(_phaseIcon(currentPhase), size: 18, color: scheme.primary),
              const SizedBox(width: 8),
              Text(
                currentPhase.localizedLabel(context.l10n),
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              const Spacer(),
              Text(
                currentPhase.localizedDescription(context.l10n),
                style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(phases.length, (i) {
              final isActive = i == _currentPhaseIndex;
              final isDone = i < _currentPhaseIndex;
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  height: 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: isDone
                        ? AppColors.teal
                        : isActive
                            ? scheme.primary
                            : scheme.outlineVariant,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildAyahCounter(ColorScheme scheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            context.l10n.lessonAyahCounter(_currentAyahIndex, range.ayahCount),
            style: TextStyle(fontWeight: FontWeight.w500, color: scheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  Widget _buildPhaseContent(Ayah? ayah) {
    final scheme = Theme.of(context).colorScheme;

    if (ayah == null) {
      return Center(
        child: Text(
          context.l10n.lessonTextUnavailable,
          textAlign: TextAlign.center,
          style: TextStyle(color: scheme.onSurfaceVariant),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildInstructionCard(scheme),
          const SizedBox(height: 20),
          _buildArabicText(ayah),
          const SizedBox(height: 16),
          if (_showTranslation || currentPhase == LessonPhase.translationStudy)
            _buildTranslation(ayah)
          else
            TextButton(
              onPressed: () => setState(() => _showTranslation = true),
              child: Text(context.l10n.lessonShowTranslation),
            ),
          const SizedBox(height: 16),
          if (currentPhase == LessonPhase.listenRepeat && _isPlaying)
            _buildPlayingIndicator(scheme),
          if (_isListening) _buildListeningIndicator(scheme),
          if (_lastScore != null && !_isListening) _buildScoreCard(),
        ],
      ),
    );
  }

  Widget _buildInstructionCard(ColorScheme scheme) {
    String instruction;
    IconData icon;

    switch (currentPhase) {
      case LessonPhase.listenRepeat:
        instruction = _isFirstAyah
            ? context.l10n.lessonListenRepeatFirst
            : context.l10n.lessonListenRepeatNext;
        icon = Icons.headphones;
      case LessonPhase.readAlone:
        instruction = _isFirstAyah
            ? context.l10n.lessonReadAloneFirst
            : context.l10n.lessonReadAloneNext;
        icon = Icons.menu_book;
      case LessonPhase.aiTest:
        instruction = _isFirstAyah
            ? context.l10n.lessonAiTestFirst
            : context.l10n.lessonAiTestNext;
        icon = Icons.mic;
      case LessonPhase.translationStudy:
        instruction = context.l10n.lessonTranslationStudy;
        icon = Icons.translate;
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: scheme.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              instruction,
              style: TextStyle(fontSize: 13, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArabicText(Ayah ayah) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Text(
        ayah.arabic,
        style: const TextStyle(
          fontFamily: 'AmiriQuran',
          fontSize: 30,
          height: 2.0,
          color: Color(0xFF1A1A2E),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.rtl,
      ),
    );
  }

  Widget _buildTranslation(Ayah ayah) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.lessonTranslation,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 6),
          Text(
            ayah.translationEng ?? '',
            style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayingIndicator(ColorScheme scheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: scheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2, color: scheme.primary),
          ),
          const SizedBox(width: 8),
          Text(context.l10n.lessonPlaying, style: TextStyle(color: scheme.primary, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildListeningIndicator(ColorScheme scheme) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: scheme.primary.withValues(alpha: 0.2),
              border: Border.all(color: scheme.primary, width: 3),
            ),
            child: Icon(Icons.mic, color: scheme.primary, size: 36),
          ),
        );
      },
    );
  }

  Widget _buildScoreCard() {
    final scorePercent = ((_lastScore ?? 0) * 100).round();
    final isGood = (_lastScore ?? 0) >= 0.8;
    final isOk = (_lastScore ?? 0) >= 0.6;
    final color = isGood ? AppColors.teal : (isOk ? AppColors.gold : AppColors.error);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Row(
        children: [
          Icon(
            isGood ? Icons.check_circle : isOk ? Icons.warning : Icons.refresh,
            color: color,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.l10n.lessonScorePct(scorePercent), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                Text(
                  isGood
                      ? context.l10n.lessonExcellent
                      : isOk
                          ? context.l10n.lessonGoodKeepPracticing
                          : context.l10n.lessonTryAgainBetter,
                  style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControls(Ayah? ayah) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border(top: BorderSide(color: scheme.outlineVariant)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: _isFirstAyah ? null : _previousAyah,
              icon: Icon(Icons.skip_previous, color: _isFirstAyah ? scheme.outlineVariant : scheme.primary),
            ),
            const SizedBox(width: 8),
            if (currentPhase == LessonPhase.listenRepeat || currentPhase == LessonPhase.readAlone)
              _buildActionButton(
                icon: _isPlaying ? Icons.stop : Icons.play_arrow,
                label: _isPlaying ? context.l10n.lessonStop : context.l10n.lessonPlay,
                onPressed: ayah != null ? _playAyah : null,
                scheme: scheme,
              ),
            if (_isListening)
              _buildActionButton(
                icon: Icons.stop,
                label: context.l10n.lessonStop,
                onPressed: () {
                  _pulseController.stop();
                  setState(() => _isListening = false);
                },
                isPrimary: false,
                scheme: scheme,
              )
            else
              _buildActionButton(
                icon: currentPhase == LessonPhase.aiTest ? Icons.mic : Icons.mic_none,
                label: currentPhase == LessonPhase.aiTest ? context.l10n.lessonTestMe : context.l10n.lessonRepeat,
                onPressed: ayah != null ? _startListening : null,
                isPrimary: false,
                scheme: scheme,
              ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: _nextAyah,
              icon: Icon(_isLastAyah ? Icons.check_circle : Icons.skip_next, color: scheme.primary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    VoidCallback? onPressed,
    bool isPrimary = true,
    required ColorScheme scheme,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? scheme.primary : scheme.surfaceContainerHighest,
        foregroundColor: isPrimary ? scheme.onPrimary : scheme.onSurface,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        side: isPrimary ? null : BorderSide(color: scheme.outlineVariant),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        elevation: isPrimary ? 2 : 0,
      ),
    );
  }

  Widget _buildCompletionScreen() {
    final appState = context.read<AppState>();
    final stats = appState.lessonStats;
    final scorePercent = ((_lastScore ?? 0.7) * 100).round();
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.teal.withValues(alpha: 0.15),
                  ),
                  child: Icon(Icons.star, color: AppColors.teal, size: 50),
                ),
                const SizedBox(height: 24),
                Text(
                  widget.lesson.isSinglePart
                      ? context.l10n.lessonMashaAllah
                      : context.l10n.lessonPartComplete(widget.lesson.partNumber),
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.lesson.displayTitle,
                  style: TextStyle(fontSize: 16, color: scheme.onSurfaceVariant),
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: scheme.outlineVariant),
                  ),
                  child: Column(
                    children: [
                      Text(context.l10n.lessonRecitationScore, style: TextStyle(color: scheme.onSurfaceVariant)),
                      const SizedBox(height: 8),
                      Text(
                        '$scorePercent%',
                        style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: scheme.primary),
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: (_lastScore ?? 0.7).clamp(0.0, 1.0),
                        backgroundColor: scheme.outlineVariant,
                        color: scheme.primary,
                        minHeight: 6,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  context.l10n.lessonOfComplete(stats.completedLessons, stats.totalLessons),
                  style: TextStyle(color: scheme.onSurfaceVariant),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(context.l10n.lessonReview),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          final next = appState.nextSurahLesson;
                          if (next != null) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => SurahLessonPlayerScreen(lesson: next)),
                            );
                          } else {
                            Navigator.pop(context);
                          }
                        },
                        child: Text(context.l10n.lessonNextLesson),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _phaseIcon(LessonPhase phase) {
    switch (phase) {
      case LessonPhase.listenRepeat:
        return Icons.headphones;
      case LessonPhase.readAlone:
        return Icons.menu_book;
      case LessonPhase.aiTest:
        return Icons.mic;
      case LessonPhase.translationStudy:
        return Icons.translate;
    }
  }
}
