import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/widgets/app_widgets.dart';
import '../../l10n/ext.dart';
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
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.modelTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              l.modelOnDeviceModel,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              l.modelOnDeviceBody,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            _installedCard(),
            const SizedBox(height: 24),
            Text(
              l.modelStorage,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkillBar(
                    label: l.modelRecitationModel,
                    percent: app.voiceStorageUsedMb / app.models.totalMediaMb,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l.modelBundledSize(app.voiceStorageUsedMb.toStringAsFixed(0), app.models.totalMediaMb.toStringAsFixed(0)),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l.modelIncludedSpace,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l.modelHowItWorks,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _info(l.modelMicrophone, l.modelCapturedLocally),
                  _info(l.modelTarteelModel, l.modelSpeechToText),
                  _info(l.modelAyahMatcher, l.modelCompareRecitation),
                  _info(l.modelAnalysis, l.modelAssistiveFeedback),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                l.modelCredits,
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
    final l = context.l10n;
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
                  l.modelInstalledTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(l.modelBundledReady),
          Text(l.modelFullyOffline),
          Text(l.modelPrivacyFirst),
        ],
      ),
    );
  }
}
