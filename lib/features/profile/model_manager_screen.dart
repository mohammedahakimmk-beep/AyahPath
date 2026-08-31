import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/widgets/app_widgets.dart';
import '../../services/app_state.dart';

/// Manage the on-device Tarteel AI recitation model.
///
/// The Tarteel AI Quran model (Q8_0, ~78 MB) is bundled inside the APK, so
/// recitation analysis runs fully on-device with no download and no connection.
class ModelManagerScreen extends StatefulWidget {
  const ModelManagerScreen({super.key});

  @override
  State<ModelManagerScreen> createState() => _ModelManagerScreenState();
}

class _ModelManagerScreenState extends State<ModelManagerScreen> {
  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: const Text('Model Manager')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'On-device recitation model',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'AyahPath uses the Tarteel AI model — a speech model fine-tuned '
              'on Quran recitation — bundled inside the app. It runs fully '
              'on-device: your voice never leaves the phone, and no download '
              'is required.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            _installedCard(),
            const SizedBox(height: 24),
            Text(
              'Storage',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkillBar(
                    label: 'Recitation model',
                    percent: app.voiceStorageUsedMb / app.models.totalMediaMb,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${app.voiceStorageUsedMb.toStringAsFixed(0)} of ~${app.models.totalMediaMb.toStringAsFixed(0)} MB bundled',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Included in the app — no extra space is downloaded at runtime.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'How it works',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _info('Microphone', '→ captured locally'),
                  _info('Tarteel AI model', '→ speech-to-text on-device'),
                  _info('Ayah matcher', '→ compare with the recitation'),
                  _info('Analysis', '→ assistive feedback'),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                'Credits: The Tarteel AI model is an Apache-2.0 checkpoint '
                'distributed by tarteel-ai on Hugging Face, fine-tuned from '
                'OpenAI Whisper on Quran recitation. It is run locally by the '
                'whisper.cpp engine (MIT).',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _info(String left, String right) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(left, style: Theme.of(context).textTheme.bodyMedium)),
          Text(right, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }

  Widget _installedCard() {
    return AppCard(
      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Tarteel AI — Quran recitation (Q8_0)',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text('✓ Bundled & ready'),
          const Text('✓ Fully offline'),
          const Text('✓ Privacy-first (no upload)'),
        ],
      ),
    );
  }
}
