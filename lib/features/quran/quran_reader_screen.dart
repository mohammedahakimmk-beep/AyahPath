import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_widgets.dart';
import '../../data/quran/quran_data.dart';
import '../../data/quran/quran_models.dart';
import '../../services/app_state.dart';
import '../learn/recitation_practice_screen.dart';

/// Ayah-by-ayah Qur’an reader with translation, transliteration, bookmarks,
/// notes, memorization tracking and recitation practice.
class QuranReaderScreen extends StatefulWidget {
  const QuranReaderScreen({super.key, required this.surahNumber, this.resume = false});

  final int surahNumber;
  final bool resume;

  @override
  State<QuranReaderScreen> createState() => _QuranReaderScreenState();
}

class _QuranReaderScreenState extends State<QuranReaderScreen> {
  late final Surah _surah;
  bool _showTranslation = false;
  bool _showTranslit = false;
  final Set<int> _bookmarked = {};
  final Map<int, String> _notes = {};

  @override
  void initState() {
    super.initState();
    _surah = QuranDataset.byNumber(widget.surahNumber)!;
  }

  void _toggleBookmark(int ayah) {
    setState(() {
      _bookmarked.contains(ayah) ? _bookmarked.remove(ayah) : _bookmarked.add(ayah);
    });
  }

  Future<void> _addNote(int ayah) async {
    final controller = TextEditingController(text: _notes[ayah] ?? '');
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Note'),
        content: TextField(
          controller: controller,
          maxLines: 4,
          decoration: const InputDecoration(hintText: 'Reflection, reference or reminder…'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (result != null) {
      setState(() => result.isEmpty ? _notes.remove(ayah) : _notes[ayah] = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(
        title: Text(_surah.englishName),
        actions: [
          IconButton(
            tooltip: 'Recitation practice',
            icon: const Icon(Icons.mic),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => _recitationScreen(),
              ),
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (v) {
              if (v == 'translation') setState(() => _showTranslation = !_showTranslation);
              if (v == 'translit') setState(() => _showTranslit = !_showTranslit);
            },
            itemBuilder: (context) => [
              CheckedPopupMenuItem(value: 'translation', checked: _showTranslation, child: const Text('Translation')),
              CheckedPopupMenuItem(value: 'translit', checked: _showTranslit, child: const Text('Transliteration')),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Scrollbar(
          thumbVisibility: true,
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
            itemCount: _surah.ayahs.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) return _header(app);
              final ayah = _surah.ayahs[index - 1];
              return _ayahCard(ayah, ayahNumber: ayah.ayahNumber);
            },
          ),
        ),
      ),
    );
  }

  Widget _header(AppState app) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 8),
        Text(AppConstants.bismillah, textAlign: TextAlign.center, style: const TextStyle(fontFamily: 'AmiriQuran', fontSize: 28, height: 2)),
        const SizedBox(height: 12),
        Pill(label: '${_surah.revelationPlace} · ${_surah.ayahCount} ayahs'),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _ayahCard(Ayah ayah, {required int ayahNumber}) {
    final app = context.read<AppState>();
    final isBookmarked = _bookmarked.contains(ayahNumber);
    final note = _notes[ayahNumber];
    final memorized = app.profile.memorization[_surah.number]?.memorizedAyahs ?? 0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                '﴾$ayahNumber﴿',
                style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w800),
              ),
              const Spacer(),
              IconButton(
                tooltip: 'Bookmark',
                visualDensity: VisualDensity.compact,
                icon: Icon(
                  isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: isBookmarked ? AppColors.gold : null,
                  size: 20,
                ),
                onPressed: () => _toggleBookmark(ayahNumber),
              ),
              IconButton(
                tooltip: 'Add note',
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.note_add_outlined, size: 20),
                onPressed: () => _addNote(ayahNumber),
              ),
              IconButton(
                tooltip: memorized >= ayahNumber ? 'Memorized' : 'Mark as memorized',
                visualDensity: VisualDensity.compact,
                icon: Icon(
                  memorized >= ayahNumber ? Icons.star_rounded : Icons.star_border_rounded,
                  color: memorized >= ayahNumber ? AppColors.gold : null,
                  size: 20,
                ),
                onPressed: memorized >= ayahNumber
                    ? null
                    : () {
                        app.markAyahMemorized(_surah.number, ayahNumber);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Marked ayah $ayahNumber as memorized')));
                      },
              ),
            ],
          ),
          Text(
            ayah.arabic,
            textAlign: TextAlign.center,
            style: const TextStyle(fontFamily: 'AmiriQuran', fontSize: 26, height: 2.1),
          ),
          if (_showTranslation && ayah.translationEng != null) ...[
            const SizedBox(height: 10),
            Text(
              ayah.translationEng!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.inkSoft),
            ),
          ],
          if (_showTranslit && ayah.transliteration != null) ...[
            const SizedBox(height: 6),
            Text(
              ayah.transliteration!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
            ),
          ],
          if (note != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.goldSoft.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.note_alt_outlined, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      note,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ],
          const Divider(height: 28),
        ],
      ),
    );
  }

  Widget _recitationScreen() {
    return RecitationPracticeScreen(
      surahNumber: _surah.number,
      startAyah: 1,
    );
  }
}
