import 'dart:math';

/// Installation status of the on-device voice model.
enum ModelStatus { notInstalled, downloading, installed, error }

/// A downloadable on-device model option.
class ModelOption {
  const ModelOption({
    required this.id,
    required this.name,
    required this.sizeMb,
    required this.description,
    required this.isRecommended,
  });

  final String id;
  final String name;
  final int sizeMb;
  final String description;
  final bool isRecommended;
}

/// Manages on-device model download/delete/update and storage usage.
///
/// This core ships without an actual model binary; the interface models the
/// real flow (state, storage accounting) so a genuine model can be attached.
/// Nothing about learner data ever depends on model size, keeping the APK lean.
class ModelManagerService {
  ModelManagerService();

  static const List<ModelOption> availableModels = [
    ModelOption(
      id: 'voice-pocket',
      name: 'Voice — Pocket',
      sizeMb: 42,
      description: 'Compact Arabic voice model. Fast, small download.',
      isRecommended: false,
    ),
    ModelOption(
      id: 'voice-standard',
      name: 'Voice — Standard',
      sizeMb: 96,
      description: 'Recommended balance of accuracy and size for reading practice.',
      isRecommended: true,
    ),
    ModelOption(
      id: 'voice-enhanced',
      name: 'Voice — Enhanced',
      sizeMb: 210,
      description: 'Highest-accuracy on-device analysis. Larger download.',
      isRecommended: false,
    ),
  ];

  ModelStatus status = ModelStatus.notInstalled;
  ModelOption? installed;
  double progress = 0;

  bool get isDownloading => status == ModelStatus.downloading;
  bool get isInstalled => status == ModelStatus.installed;

  /// Approximate current local model storage usage in MB.
  double get storageUsedMb =>
      isInstalled ? (installed?.sizeMb ?? 0).toDouble() : 0;

  /// Total app-relevant storage (model only here).
  double get totalMediaMb => availableModels.fold<int>(0, (s, m) => s + m.sizeMb).toDouble();

  ModelOption? byId(String id) {
    for (final m in availableModels) {
      if (m.id == id) return m;
    }
    return null;
  }

  /// Simulated download with progress.
  Future<void> download(ModelOption option, {void Function(double)? onProgress}) async {
    status = ModelStatus.downloading;
    installed = option;
    progress = 0;
    final steps = 20;
    for (var i = 1; i <= steps; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 120));
      progress = i / steps;
      onProgress?.call(progress);
    }
    status = ModelStatus.installed;
  }

  Future<void> delete() async {
    status = ModelStatus.notInstalled;
    installed = null;
    progress = 0;
  }

  bool needsSync() => isInstalled;
  /// Simulated "check for updates".
  Future<bool> checkForUpdate() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return Random().nextBool();
  }
}
