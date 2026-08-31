import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../l10n/app_localizations.dart';

/// Checks for app updates on launch and forces users to update.
///
/// Flow:
/// 1. On app launch, fetch latest version info from a JSON file hosted on
///    Firebase Hosting (or any static URL).
/// 2. Compare with current build version.
/// 3. If update available, show mandatory update dialog.
/// 4. User can download the new APK via a direct link.
/// 5. User must update — old versions are not allowed to continue.
///
/// The version info JSON is hosted at:
///   `https://<your-firebase-project>.web.app/version.json`
///
/// Format:
///   `{ "latestVersion": "1.2.0", "minRequiredVersion": "1.0.0",
///     "downloadUrl": "https://...", "releaseNotes": "..." }`
class UpdateService {
  /// Version endpoint hosted on Firebase Hosting.
  static const String _versionUrl =
      'https://ayahpath.web.app/version.json';

  /// Current app version — should match pubspec.yaml.
  static const String currentVersion = '1.3.1';

  static const String _lastCheckedKey = 'ayahpath.last_update_check';
  static const String _skippedVersionsKey = 'ayahpath.skipped_versions';

  /// Checks for updates. Returns null if no update, or [UpdateInfo] if one exists.
  /// If [force] is true, the user must update (no skip option).
  static Future<UpdateInfo?> checkForUpdate({bool force = false}) async {
    try {
      final response = await http.get(
        Uri.parse(_versionUrl),
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode != 200) return null;

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final latestVersion = data['latestVersion'] as String? ?? currentVersion;
      final minRequired = data['minRequiredVersion'] as String? ?? '0.0.0';
      final downloadUrl = data['downloadUrl'] as String? ?? '';
      final releaseNotes = data['releaseNotes'] as String? ?? '';

      // Check if current version is below minimum required
      final isBelowMinimum = isVersionBelow(currentVersion, minRequired);

      // Check if current version is below latest
      final isBelowLatest = isVersionBelow(currentVersion, latestVersion);

      // Record last check time
      final prefs = await SharedPreferences.getInstance()
          .timeout(const Duration(seconds: 3));
      await prefs.setInt(_lastCheckedKey, DateTime.now().millisecondsSinceEpoch);

      if (isBelowMinimum) {
        // Mandatory update — user cannot skip
        return UpdateInfo(
          latestVersion: latestVersion,
          downloadUrl: downloadUrl,
          releaseNotes: releaseNotes,
          isMandatory: true,
        );
      }

      if (isBelowLatest && !force) {
        // Check if user has skipped this version
        final skipped = await _getSkippedVersions();
        if (!skipped.contains(latestVersion)) {
          return UpdateInfo(
            latestVersion: latestVersion,
            downloadUrl: downloadUrl,
            releaseNotes: releaseNotes,
            isMandatory: false,
          );
        }
      }

      return null;
    } catch (_) {
      // Network error — allow app to continue
      return null;
    }
  }

  /// Shows the update dialog. Returns true if user initiated download.
  static Future<bool> showUpdateDialog(
    BuildContext context,
    UpdateInfo update,
  ) async {
    if (!context.mounted) return false;

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: update.isMandatory,
      builder: (ctx) => PopScope(
        canPop: !update.isMandatory,
        child: Builder(
          builder: (ctx) {
            final l10n = AppLocalizations.of(ctx);
            return AlertDialog(
              icon: Icon(
                update.isMandatory ? Icons.system_update : Icons.update,
                color: update.isMandatory ? Colors.red : Colors.blue,
                size: 48,
              ),
              title: Text(
                update.isMandatory ? l10n.updateRequired : l10n.updateAvailable,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.updateVersionLabel(update.latestVersion),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  if (update.releaseNotes.isNotEmpty) ...[
                    Text(l10n.updateWhatsNew),
                    const SizedBox(height: 4),
                    Text(
                      update.releaseNotes,
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                    const SizedBox(height: 12),
                  ],
                  if (update.isMandatory)
                    Text(
                      l10n.updateRequiredNotice,
                      style: const TextStyle(color: Colors.red, fontSize: 13),
                    ),
                ],
              ),
              actions: [
                if (!update.isMandatory)
                  TextButton(
                    onPressed: () {
                      _skipVersion(update.latestVersion);
                      Navigator.pop(ctx, false);
                    },
                    child: Text(l10n.updateSkip),
                  ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  child: Text(l10n.updateNow),
                ),
              ],
            );
          },
        ),
      ),
    );

    return result ?? false;
  }

  /// Compare two semver strings. Returns true if [a] < [b].
  ///
  /// Public for testability.
  static bool isVersionBelow(String a, String b) {
    final pa = a.split('.').map(int.tryParse).toList();
    final pb = b.split('.').map(int.tryParse).toList();

    for (int i = 0; i < 3; i++) {
      final va = (i < pa.length ? pa[i] : 0) ?? 0;
      final vb = (i < pb.length ? pb[i] : 0) ?? 0;
      if (va < vb) return true;
      if (va > vb) return false;
    }
    return false;
  }

  static Future<Set<String>> _getSkippedVersions() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_skippedVersionsKey);
    return raw?.toSet() ?? {};
  }

  static Future<void> _skipVersion(String version) async {
    final prefs = await SharedPreferences.getInstance();
    final skipped = await _getSkippedVersions();
    skipped.add(version);
    await prefs.setStringList(_skippedVersionsKey, skipped.toList());
  }
}

/// Data class for an available update.
class UpdateInfo {
  const UpdateInfo({
    required this.latestVersion,
    required this.downloadUrl,
    required this.releaseNotes,
    required this.isMandatory,
  });

  final String latestVersion;
  final String downloadUrl;
  final String releaseNotes;
  final bool isMandatory;
}
