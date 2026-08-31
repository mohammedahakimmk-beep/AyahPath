import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/widgets/app_widgets.dart';
import '../../l10n/ext.dart';
import '../../services/app_state.dart';
import '../auth/legal_screen.dart';
import '../../data/legal/legal_content.dart';

/// Transparent privacy: what is local, what is stored online, and control.
class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.privTitle)),
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
                  Text(l.privPrivacyFirst, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    l.privIntro,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SectionHeader(title: l.privOnYourDevice),
            const SizedBox(height: 12),
            _statusRow(context, true, l.privQuranText, l.privBundledLocally),
            _statusRow(context, true, l.privVoiceAnalysis, app.voice.isLocal ? l.privOnDeviceModel : l.privCloud),
            _statusRow(context, true, l.privLoginSession, l.privLocal),
            const SizedBox(height: 20),
            SectionHeader(title: l.privStoredOnline),
            const SizedBox(height: 12),
            _statusRow(context, false, l.privProgress, l.privSyncedToAccount),
            _statusRow(context, false, l.privLearnerProfile, l.privSyncedToAccount),
            _statusRow(context, false, l.privAiTutorAdvanced, l.privOptionalPlanned),
            _statusRow(context, false, l.privAdditionalContent, l.privOnDemand),
            const SizedBox(height: 20),
            SectionHeader(title: l.privYourControl),
            const SizedBox(height: 12),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.privControlBody,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.description_outlined),
                    title: Text(l.privTermsOfService),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const LegalScreen(document: termsOfService)),
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.privacy_tip_outlined),
                    title: Text(l.privPrivacyPolicy),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const LegalScreen(document: privacyPolicy)),
                    ),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.delete_forever_outlined),
                      label: Text(l.privDeleteAllData),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.error,
                        side: BorderSide(color: Theme.of(context).colorScheme.error.withValues(alpha: 0.5)),
                      ),
                      onPressed: () async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (dialogContext) {
                            final dl = dialogContext.l10n;
                            return AlertDialog(
                              title: Text(dl.privDeleteDialogTitle),
                              content: Text(dl.privDeleteDialogBody),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: Text(dl.privCancel)),
                                FilledButton(
                                  onPressed: () => Navigator.pop(dialogContext, true),
                                  child: Text(dl.privDelete),
                                ),
                              ],
                            );
                          },
                        );
                        if (confirmed == true) {
                          await app.resetAllData();
                          if (context.mounted) {
                            final sl = context.l10n;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(sl.privDeletedSnackbar)),
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
