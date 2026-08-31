import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/widgets/app_widgets.dart';
import '../../domain/model/model_manager_service.dart';
import '../../services/app_state.dart';

/// Download and manage on-device voice models.
class ModelManagerScreen extends StatefulWidget {
  const ModelManagerScreen({super.key});

  @override
  State<ModelManagerScreen> createState() => _ModelManagerScreenState();
}

class _ModelManagerScreenState extends State<ModelManagerScreen> {
  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final models = app.models;
    return Scaffold(
      appBar: AppBar(title: const Text('Model Manager')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'On-device voice model',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'Installing a local model lets AyahPath analyze your recitation '
              'fully on-device — your voice never leaves the phone.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            if (models.isInstalled)
              _installedCard(app)
            else
              _downloadSection(app, models),
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
                    label: 'Voice models',
                    percent: models.storageUsedMb / models.totalMediaMb,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${models.storageUsedMb.toStringAsFixed(0)} MB of ~${models.totalMediaMb.toStringAsFixed(0)} MB',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'The app itself stays lean — models are optional downloads.',
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
                  _info('Preprocessing', '→ noise & format'),
                  _info('Local model', '→ speech to text on-device'),
                  _info('Alignment', '→ compare with the ayah'),
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

  Widget _installedCard(AppState app) {
    final m = app.models.installed!;
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
                  m.name,
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
                    await app.removeModel();
                  },
                  child: const Text('Delete'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    final update = await app.models.checkForUpdate();
                    messenger.showSnackBar(
                      SnackBar(content: Text(update ? 'A model update is available.' : 'Your model is up to date.')),
                    );
                  },
                  child: const Text('Check for update'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _downloadSection(AppState app, ModelManagerService models) {
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
                  if (models.isDownloading && models.installed?.id == option.id)
                    _progress(app, models)
                  else
                    Align(
                      alignment: Alignment.centerRight,
                      child: FilledButton.tonal(
                        onPressed: () async {
                          await app.downloadModel(option);
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

  Widget _progress(AppState app, ModelManagerService models) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: models.progress,
            minHeight: 8,
            color: scheme.primary,
            backgroundColor: scheme.primary.withValues(alpha: 0.15),
          ),
        ),
        const SizedBox(height: 6),
        Text('Downloading ${(models.progress * 100).round()}%', style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
