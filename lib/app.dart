import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'core/theme/app_theme.dart';
import 'l10n/app_localizations.dart';
import 'l10n/ext.dart';
import 'features/auth/login_screen.dart';
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
  // Context below the MaterialApp so update dialogs/screens have access to
  // both the Navigator and Localizations (the app-level context does not).
  BuildContext? _uiContext;

  @override
  void initState() {
    super.initState();
    _update = widget.updateInfo;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _checkForUpdates();
    });
  }

  Future<void> _openDownload(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _checkForUpdates() async {
    UpdateInfo? update;
    try {
      // Hard timeout so the splash/checking screen can never hang forever.
      update = await UpdateService.checkForUpdate()
          .timeout(const Duration(seconds: 8));
    } catch (_) {
      // Network failure or timeout — proceed without blocking the app.
      update = null;
    }
    if (!mounted) return;

    final uiContext = _uiContext;
    if (update != null && uiContext != null && uiContext.mounted) {
      final shouldUpdate =
          await UpdateService.showUpdateDialog(uiContext, update);
      if (shouldUpdate && update.downloadUrl.isNotEmpty) {
        await _openDownload(update.downloadUrl);
      }
      if (update.isMandatory) {
        // Stay on the blocking download screen (whether or not the user tapped
        // Update Now — they must install the required version).
        if (mounted) {
          setState(() {
            _update = update;
            _updateChecked = true;
          });
        }
        return;
      }
    }

    if (mounted) {
      setState(() => _updateChecked = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);

    return MaterialApp(
      title: 'AyahPath',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: app.themeMode,
      locale: app.locale,
      supportedLocales: const [Locale('en'), Locale('ar')],
      localizationsDelegates: [
        ...AppLocalizations.localizationsDelegates,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routes: {
        '/recite': (_) => const RecitationPracticeScreen(),
        '/home': (_) => const AppShell(),
      },
      // The splash / mandatory-update / app content all live BELOW the
      // MaterialApp (inside a Builder) so they have both Localizations and a
      // Navigator. This avoids the white screen when an update is detected.
      home: Builder(
        builder: (ctx) {
          _uiContext = ctx;
          if (_updateChecked && _update != null && _update!.isMandatory) {
            return _buildMandatoryUpdate(ctx, _update!);
          }
          if (!_updateChecked) {
            return _buildSplash(ctx);
          }
          return Consumer<AppState>(
            builder: (context, app, _) {
              // Gate the whole app behind authentication + ToS/PP consent.
              if (!app.authReady || !app.dataReady) {
                return const _AuthLoadingScreen();
              }
              if (app.authUser == null) {
                return const LoginScreen();
              }
              return app.needsOnboarding
                  ? const OnboardingFlow()
                  : const AppShell();
            },
          );
        },
      ),
    );
  }

  Widget _buildSplash(BuildContext ctx) {
    return Scaffold(
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
            Text(
              ctx.l10n.checkingForUpdates,
              style: const TextStyle(fontSize: 14, color: Color(0xFF666666)),
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(color: Color(0xFF1B5E20)),
          ],
        ),
      ),
    );
  }

  // Non-blocking full-screen mandatory update view.
  Widget _buildMandatoryUpdate(BuildContext ctx, UpdateInfo update) {
    return Scaffold(
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
                Text(
                  ctx.l10n.updateRequired,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E)),
                ),
                const SizedBox(height: 12),
                Text(
                  ctx.l10n.updateVersionLabel(update.latestVersion),
                  style: const TextStyle(fontSize: 16, color: Color(0xFF666666)),
                ),
                const SizedBox(height: 12),
                Text(
                  update.releaseNotes.isEmpty
                      ? ctx.l10n.updateRequiredMessage
                      : update.releaseNotes,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: Color(0xFF444444), height: 1.4),
                ),
                const SizedBox(height: 32),
                if (update.downloadUrl.isNotEmpty)
                  ElevatedButton.icon(
                    onPressed: () => _openDownload(update.downloadUrl),
                    icon: const Icon(Icons.download),
                    label: Text(ctx.l10n.downloadUpdate),
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
    );
  }
}

/// Shown while authentication / data synchronization is being established.
class _AuthLoadingScreen extends StatelessWidget {
  const _AuthLoadingScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Text(
              context.l10n.preparingJourney,
              style: const TextStyle(fontSize: 14, color: Color(0xFF666666)),
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(color: Color(0xFF1B5E20)),
          ],
        ),
      ),
    );
  }
}
