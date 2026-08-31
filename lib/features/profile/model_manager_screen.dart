import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/widgets/app_widgets.dart';
import '../../domain/model/model_manager_service.dart';
import '../../services/app_state.dart';

/// Download and manage the on-device recitation (Whisper) model.
///
/// This drives the real local model: downloading the multilingual Whisper
/// binary (~461 MB) once from Hugging Face, then all analysis runs fully
/// on-device.
class ModelManagerScreen extends StatefulWidget {
  const ModelManagerScreen({super.key});

  @override
  State<ModelManagerScreen> createState() => _ModelManagerScreenState();
}

class _ModelManagerScreenState extends State<ModelManagerScreen> {
  bool _downloading = false;

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final installed = app.voiceModelInstalled;
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
              'A multilingual Whisper model powers recognition. It is '
              'downloaded once (~461 MB) from Hugging Face, then recitation '
              'analysis runs fully on-device — your voice never leaves the phone.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            if (installed)
              _installedCard()
            else
              _downloadSection(app),
            if (_downloading)
              const Padding(
                padding: EdgeInsets.only(top: 12),
                child: Center(child: CircularProgressIndicator()),
              ),
            if (app.voiceModelError != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: AppCard(
                  color: Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.4),
                  child: Text(
                    'Model download failed. Check your connection and try again.\n'
                    '${app.voiceModelError}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ),
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
                    '${app.voiceStorageUsedMb.toStringAsFixed(0)} of ~${app.models.totalMediaMb.toStringAsFixed(0)} MB',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'The app itself stays lean — the model is an optional download.',
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
                  _info('Whisper model', '→ speech to text on-device'),
                  _info('Ayah matcher', '→ compare with the recitation'),
                  _info('Analysis', '→ assistive feedback'),
                ],
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
                  'Whisper — Arabic (multilingual small)',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text('✓ Installed'),
          const Text('✓ Ready for offline use'),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    final app = context.read<AppState>();
                    await app.removeModel();
                    messenger.showSnackBar(
                      const SnackBar(content: Text('Model removed. You can re-download it anytime.')),
                    );
                  },
                  child: const Text('Delete'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _downloadSection(AppState app) {
    return Column(
      children: [
        for (final option in ModelManagerService.availableModels)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          option.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      if (option.isRecommended) const Pill(label: 'Recommended'),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(option.description, style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 4),
                  Text('${option.sizeMb} MB', style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FilledButton.tonal(
                      onPressed: _downloading
                          ? null
                          : () async {
                              setState(() => _downloading = true);
                              await app.downloadModel(option);
                              if (mounted) setState(() => _downloading = false);
                            },
                      child: const Text('Download'),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
