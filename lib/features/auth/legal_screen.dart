import 'package:flutter/material.dart';

import '../../data/legal/legal_content.dart';

/// Renders a [LegalDocument] (Terms of Service or Privacy Policy) with
/// sections and inline-bold highlights derived from the content model.
class LegalScreen extends StatelessWidget {
  const LegalScreen({super.key, required this.document});

  final LegalDocument document;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final base = TextStyle(
      color: theme.colorScheme.onSurface,
      fontSize: 14.5,
      height: 1.5,
    );
    final bold = base.copyWith(fontWeight: FontWeight.w700);
    return Scaffold(
      appBar: AppBar(title: Text(document.title)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
          children: [
            Text(
              '${document.title} · ${document.version}',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Effective: ${document.effectiveDate}',
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline),
            ),
            const SizedBox(height: 16),
            Text(document.intro, style: theme.textTheme.bodyMedium?.copyWith(height: 1.5)),
            const SizedBox(height: 20),
            for (final section in document.sections) ...[
              Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      section.title,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 6),
                    for (final paragraph in section.paragraphs) ...[
                      RichText(
                        text: TextSpan(
                          children: [
                            for (final run in paragraph.runs)
                              TextSpan(
                                text: run.text,
                                style: run.bold ? bold : base,
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ],
                ),
              ),
              const Divider(height: 8),
            ],
          ],
        ),
      ),
    );
  }
}
