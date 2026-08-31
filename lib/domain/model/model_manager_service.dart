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

/// Describes the real on-device Whisper recitation model.
///
/// The actual model is a multilingual Whisper (whisper.cpp) binary downloaded
/// once from HuggingFace and cached on-device. Its ~461 MB size reflects the
/// real bundled model; it is fetched by [WhisperVoiceAnalysisService]. Nothing
/// about learner data depends on model size.
class ModelManagerService {
  static const List<ModelOption> availableModels = [
    ModelOption(
      id: 'whisper-small',
      name: 'Whisper — Arabic (multilingual small)',
      sizeMb: 461,
      modelSizeLabel: 'small',
      description:
          'On-device Whisper model used for Arabic recitation recognition. '
          'Runs fully locally; downloaded once from Hugging Face.',
      isRecommended: true,
    ),
  ];

  double get totalMediaMb => availableModels.fold<int>(0, (s, m) => s + m.sizeMb).toDouble();
}
