import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/widgets/app_widgets.dart';
import '../../services/app_state.dart';

/// Transparent privacy: what is local, what leaves the device, and control.
class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            AppCard(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.shield_outlined, size: 40),
                  const SizedBox(height: 8),
                  Text('Privacy first', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    'AyahPath is designed to keep your learning private. Your '
                    'recitation, progress and profile are stored on your device.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const SectionHeader(title: 'What runs locally'),
            const SizedBox(height: 12),
            _statusRow(context, true, 'Qur’an text & reading', 'Stored on-device'),
            _statusRow(context, true, 'Recitation voice analysis', app.voice.isLocal ? 'On-device model' : 'Cloud'),
            _statusRow(context, true, 'Progress, lessons & memorization', 'On-device'),
            _statusRow(context, true, 'Learner profile', 'On-device'),
            const SizedBox(height: 20),
            const SectionHeader(title: 'What may use the internet'),
            const SizedBox(height: 12),
            _statusRow(context, false, 'AI tutor (advanced cloud)', 'Optional / planned'),
            _statusRow(context, false, 'Account sync & backup', 'Requires your consent'),
            _statusRow(context, false, 'Model updates', 'Only when you update'),
            _statusRow(context, false, 'Additional content', 'On demand'),
            const SizedBox(height: 20),
            const SectionHeader(title: 'Your control'),
            const SizedBox(height: 12),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AyahPath avoids collecting unnecessary personal information. '
                    'Everything you see here can be reviewed and, if you choose, wiped.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.delete_forever_outlined),
                      label: const Text('Delete all learning data'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.error,
                        side: BorderSide(color: Theme.of(context).colorScheme.error.withValues(alpha: 0.5)),
                      ),
                      onPressed: () async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Delete all data?'),
                            content: const Text('This permanently removes your profile, progress, lessons and memorization from this device.'),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                              FilledButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );
                        if (confirmed == true) {
                          await app.resetAllData();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('All learning data deleted.')),
                            );
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusRow(BuildContext context, bool local, String title, String detail) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(
            local ? Icons.lock_rounded : Icons.public_rounded,
            color: local ? Colors.green : Theme.of(context).colorScheme.secondary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.bodyMedium),
                Text(detail, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
