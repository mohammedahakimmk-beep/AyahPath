import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/widgets/app_widgets.dart';
import '../../services/app_state.dart';
import 'ai_tutor_screen.dart';
import 'model_manager_screen.dart';
import 'privacy_screen.dart';
import 'settings_screen.dart';

/// Profile & settings hub.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            const _ProfileCard(),
            const SizedBox(height: 20),
            _navTile(context, Icons.smart_toy_outlined, 'AI Tutor', 'Ask about Tajweed, vocabulary or today’s lesson', () => push(context, const AiTutorScreen())),
            _navTile(context, Icons.memory_outlined, 'Model Manager', 'Download & manage on-device voice models', () => push(context, const ModelManagerScreen())),
            _navTile(context, Icons.shield_outlined, 'Privacy', 'See how your data is handled', () => push(context, const PrivacyScreen())),
            _navTile(context, Icons.settings_outlined, 'Settings', 'Theme, notifications, language', () => push(context, const SettingsScreen())),
            const SizedBox(height: 20),
            const _AccountCard(),
          ],
        ),
      ),
    );
  }

  Widget _navTile(BuildContext context, IconData icon, String title, String subtitle, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AppCard(
        onTap: onTap,
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.outline),
          ],
        ),
      ),
    );
  }

  void push(BuildContext context, Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard();

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);
    final p = app.profile;
    final goals = p.onboarding?.goals ?? const [];
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  'A',
                  style: TextStyle(fontFamily: 'AmiriQuran', fontSize: 28, color: Theme.of(context).colorScheme.primary),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Your learning journey', style: Theme.of(context).textTheme.titleMedium),
                    Text(
                      '${(p.overallProgress * 100).round()}% overall · ${p.currentStreak}-day streak',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final g in goals) Pill(label: g.label),
            ],
          ),
        ],
      ),
    );
  }
}

/// Shows the signed-in account and lets the user sign out.
class _AccountCard extends StatelessWidget {
  const _AccountCard();

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final email = app.authUser?.email ?? 'Signed in';
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.account_circle_outlined, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Account', style: Theme.of(context).textTheme.titleMedium),
                    Text(
                      email,
                      style: Theme.of(context).textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.logout),
              label: const Text('Sign out'),
              onPressed: () async {
                await app.signOut();
              },
            ),
          ),
        ],
      ),
    );
  }
}
