/// A downloadable on-device model option.
class ModelOption {
  const ModelOption({
    required this.id,
    required this.name,
    required this.sizeMb,
    required this.modelSizeLabel,
    required this.description,
    required this.isRecommended,
  });

  final String id;
  final String name;
  final int sizeMb;
  final String modelSizeLabel;
  final String description;
  final bool isRecommended;
}

/// Describes the on-device Tarteel AI recitation model.
///
/// The model is a Tarteel AI checkpoint — a Whisper-architecture speech model
/// fine-tuned on Quran recitation (Apache-2.0, distributed by Tarteel on
/// Hugging Face) — quantized to Q8_0 (~78 MB) and bundled inside the APK. It
/// runs fully offline via the whisper.cpp engine; no download is needed.
class ModelManagerService {
  static const List<ModelOption> availableModels = [
    ModelOption(
      id: 'tarteel-base',
      name: 'Tarteel AI — Quran recitation (base, Q8_0)',
      sizeMb: 78,
      modelSizeLabel: 'base-q8_0',
      description:
          'Bundled Tarteel AI model fine-tuned on Quran recitation. Runs fully '
          'offline — no download or connection needed.',
      isRecommended: true,
    ),
  ];

  double get totalMediaMb => availableModels.fold<int>(0, (s, m) => s + m.sizeMb).toDouble();
}
