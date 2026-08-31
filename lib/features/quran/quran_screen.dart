import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/widgets/app_widgets.dart';
import '../../data/quran/quran_data.dart';
import '../../l10n/ext.dart';
import '../../services/app_state.dart';
import 'quran_reader_screen.dart';

/// Qur’an tab: surah list and the reader entry point.
class QuranTab extends StatelessWidget {
  const QuranTab({super.key});

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.quranTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            if (app.profile.journeySurahNumber != 0)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _ContinueCard(),
              ),
            for (final s in QuranDataset.all)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: AppCard(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => QuranReaderScreen(surahNumber: s.number),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                  child: Row(
                    children: [
                      _AyahBadge(number: s.number),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(s.englishName, style: Theme.of(context).textTheme.titleMedium),
                            Text(
                              context.l10n.quranAyahCount(s.revelationPlace, s.ayahCount),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        s.name,
                        style: const TextStyle(fontFamily: 'AmiriQuran', fontSize: 22, color: Color(0xFF7A8A84)),
                      ),
                      const SizedBox(width: 6),
                      Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.outline),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.verified_rounded, size: 18),
                      const SizedBox(width: 8),
                      Text(context.l10n.quranTrustedTextTitle, style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.l10n.quranTrustedTextBody,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AyahBadge extends StatelessWidget {
  const _AyahBadge({required this.number});
  final int number;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      child: Text('$number', style: const TextStyle(fontWeight: FontWeight.w800)),
    );
  }
}

class _ContinueCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);
    final sn = app.profile.journeySurahNumber;
    final s = QuranDataset.byNumber(sn);
    if (s == null) return const SizedBox.shrink();
    return AppCard(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => QuranReaderScreen(surahNumber: s.number, resume: true)),
      ),
      color: Theme.of(context).colorScheme.primary,
      child: Row(
        children: [
          const Icon(Icons.play_circle_outline, color: Colors.white, size: 34),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              context.l10n.quranContinueReading(s.englishName),
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15),
            ),
          ),
          Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.onPrimary),
        ],
      ),
    );
  }
}
