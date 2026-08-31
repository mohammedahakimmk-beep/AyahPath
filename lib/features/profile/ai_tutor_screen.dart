import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/tutor/ai_tutor_service.dart';
import '../../services/app_state.dart';

/// Optional AI tutor with trusted-education-first answers.
class AiTutorScreen extends StatefulWidget {
  const AiTutorScreen({super.key});

  @override
  State<AiTutorScreen> createState() => _AiTutorScreenState();
}

class _AiTutorScreenState extends State<AiTutorScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<_ChatEntry> _messages = [];
  final AiTutorService _tutor = AiTutorService();

  void _send([String? preset]) {
    final text = (preset ?? _controller.text).trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_ChatEntry(question: text));
      _controller.clear();
    });
    final response = _tutor.respond(text, context.read<AppState>().profile);
    final entry = _ChatEntry(
      question: text,
      answer: response.answer,
      linksToTeacher: response.linksToTeacher,
    );
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _messages.add(entry));
    });
  }

  static const _suggestions = [
    'What should I revise today?',
    'Explain madd',
    'What is ghunnah?',
    'Help me understand today’s lesson',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Tutor')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _messages.isEmpty
                  ? _emptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: _messages.length,
                      itemBuilder: (context, i) => _bubble(_messages[i]),
                    ),
            ),
            if (_messages.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                child: Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (final s in _suggestions)
                      ActionChip(label: Text(s), onPressed: () => _send(s)),
                  ],
                ),
              ),
            Container(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _send(),
                      decoration: const InputDecoration(
                        hintText: 'Ask about Tajweed, vocabulary, revision…',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: () => _send(),
                    icon: const Icon(Icons.send_rounded),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.smart_toy_outlined, size: 72, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 20),
          Text('A learning companion, not a scholar', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            'Ask about Tajweed concepts, vocabulary, or what to revise today. '
            'AyahPath answers from trusted educational material and will point you '
            'to a qualified teacher for anything that needs scholarly authority.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              for (final s in _suggestions)
                ActionChip(label: Text(s), onPressed: () => _send(s)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bubble(_ChatEntry entry) {
    final isUser = entry.answer == null;
    final scheme = Theme.of(context).colorScheme;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.82),
        decoration: BoxDecoration(
          color: isUser ? scheme.primary : scheme.surface,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isUser ? 18 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 18),
          ),
        ),
        child: Text(
          isUser ? entry.question : entry.answer!,
          style: TextStyle(
            color: isUser ? scheme.onPrimary : scheme.onSurface,
            height: 1.4,
          ),
        ),
      ),
    );
  }
}

class _ChatEntry {
  const _ChatEntry({required this.question, this.answer, this.linksToTeacher = false});
  final String question;
  final String? answer;
  final bool linksToTeacher;
}
