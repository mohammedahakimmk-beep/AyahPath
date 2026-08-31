import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'core/theme/app_theme.dart';
import 'features/learn/recitation_practice_screen.dart';
import 'features/onboarding/onboarding_flow.dart';
import 'navigation/app_shell.dart';
import 'services/app_state.dart';
import 'services/update_service.dart';

/// Root widget: chooses onboarding or main shell, wires routes & theming.
/// Also checks for updates on launch and forces mandatory updates.
class AyahPathApp extends StatefulWidget {
  const AyahPathApp({super.key, this.updateInfo});

  final UpdateInfo? updateInfo;

  @override
  State<AyahPathApp> createState() => _AyahPathAppState();
}

class _AyahPathAppState extends State<AyahPathApp> {
  UpdateInfo? _update;
  bool _updateChecked = false;

  @override
  void initState() {
    super.initState();
    _update = widget.updateInfo;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkForUpdates();
    });
  }

  Future<void> _openDownload(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _checkForUpdates() async {
    final update = await UpdateService.checkForUpdate();
    if (!mounted) return;

    if (update != null) {
      final shouldUpdate = await UpdateService.showUpdateDialog(context, update);
      if (shouldUpdate && update.downloadUrl.isNotEmpty) {
        await _openDownload(update.downloadUrl);
      }
      if (update.isMandatory && !shouldUpdate) {
        // Keep the update blocking screen on so user cannot continue.
        if (mounted) {
          setState(() {
            _update = update;
            _updateChecked = true;
          });
        }
        return;
      }
      if (update.isMandatory) {
        // User tapped Update Now on a mandatory update. Stay on screen to
        // encourage installation, but let them proceed after download starts.
        if (mounted) {
          setState(() {
            _update = update;
            _updateChecked = true;
          });
        }
      }
    }

    if (mounted) {
      setState(() => _updateChecked = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);

    // Mandatory update block screen.
    final mandatory = _updateChecked && _update != null && _update!.isMandatory;
    if (mandatory) {
      return _buildMandatoryUpdate(_update!);
    }

    // Show loading while checking for updates.
    if (!_updateChecked) {
      return _buildSplash();
    }

    return MaterialApp(
      title: 'AyahPath',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: app.themeMode,
      routes: {
        '/recite': (_) => const RecitationPracticeScreen(),
        '/home': (_) => const AppShell(),
      },
      home: Consumer<AppState>(
        builder: (context, app, _) =>
            app.needsOnboarding ? const OnboardingFlow() : const AppShell(),
      ),
    );
  }

  Widget _buildSplash() {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFFF0F4F8),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFF1B5E20).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.menu_book, size: 40, color: Color(0xFF1B5E20)),
              ),
              const SizedBox(height: 24),
              const Text(
                'AyahPath',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E)),
              ),
              const SizedBox(height: 8),
              const Text(
                'Checking for updates...',
                style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
              ),
              const SizedBox(height: 24),
              const CircularProgressIndicator(color: Color(0xFF1B5E20)),
            ],
          ),
        ),
      ),
    );
  }

  // Non-blocking full-screen mandatory update view.
  Widget _buildMandatoryUpdate(UpdateInfo update) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFFF0F4F8),
        body: PopScope(
          canPop: false,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.system_update, size: 72, color: Color(0xFFB04A3A)),
                  const SizedBox(height: 24),
                  const Text(
                    'Update Required',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E)),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Version ${update.latestVersion}',
                    style: const TextStyle(fontSize: 16, color: Color(0xFF666666)),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    update.releaseNotes.isEmpty
                        ? 'An important update is available. Please download and install the latest version to continue using AyahPath.'
                        : update.releaseNotes,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14, color: Color(0xFF444444), height: 1.4),
                  ),
                  const SizedBox(height: 32),
                  if (update.downloadUrl.isNotEmpty)
                    ElevatedButton.icon(
                      onPressed: () => _openDownload(update.downloadUrl),
                      icon: const Icon(Icons.download),
                      label: const Text('Download Update'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B5E20),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
