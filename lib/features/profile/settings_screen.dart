import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/widgets/app_widgets.dart';
import '../../services/app_state.dart';

/// App settings: theme, notifications, language path.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.palette_outlined),
                      const SizedBox(width: 12),
                      Text('Appearance', style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SegmentedButton<ThemeMode>(
                    segments: const [
                      ButtonSegment(value: ThemeMode.light, label: Text('Light'), icon: Icon(Icons.light_mode)),
                      ButtonSegment(value: ThemeMode.system, label: Text('System'), icon: Icon(Icons.brightness_auto)),
                      ButtonSegment(value: ThemeMode.dark, label: Text('Dark'), icon: Icon(Icons.dark_mode)),
                    ],
                    selected: {app.themeMode},
                    onSelectionChanged: (s) => app.setThemeMode(s.first),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Notifications'),
                    subtitle: const Text(
                      'Gentle reminders like "Your Qur’an lesson is ready." '
                      'You can turn these off completely.',
                    ),
                    value: app.notificationsEnabled,
                    onChanged: app.setNotificationsEnabled,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            AppCard(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.translate),
                title: const Text('Interface language'),
                subtitle: const Text('English (العربية coming soon)'),
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
            const SizedBox(height: 16),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline),
                  const SizedBox(height: 8),
                  Text(
                    'AyahPath syncs your learning data to your account so it stays '
                    'in sync across reinstalls. Your recitation audio is analyzed '
                    'on-device and is never uploaded. You can review and delete '
                    'your data at any time from the Privacy screen.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'AyahPath v1.1.0 · Online-first',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}