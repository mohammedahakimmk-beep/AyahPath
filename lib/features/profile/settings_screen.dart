import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/widgets/app_widgets.dart';
import '../../l10n/ext.dart';
import '../../services/app_state.dart';

/// App settings: theme, notifications, language path.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.setTitle)),
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
                      Text(l.setAppearance, style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SegmentedButton<ThemeMode>(
                    segments: [
                      ButtonSegment(value: ThemeMode.light, label: Text(l.setLight), icon: const Icon(Icons.light_mode)),
                      ButtonSegment(value: ThemeMode.system, label: Text(l.setSystem), icon: const Icon(Icons.brightness_auto)),
                      ButtonSegment(value: ThemeMode.dark, label: Text(l.setDark), icon: const Icon(Icons.dark_mode)),
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
                    title: Text(l.setNotifications),
                    subtitle: Text(l.setNotificationsSubtitle),
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
                title: Text(l.setInterfaceLanguage),
                subtitle: Text(l.setInterfaceLanguageSubtitle),
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
                    l.setSyncInfo,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l.setVersion,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}