import 'SettingsRepository.dart';

class ToggleFaceId {
  final SettingsRepository repo;
  ToggleFaceId(this.repo);

  Future<void> call(bool enabled) {
    return repo.toggleFaceId(enabled);
  }
}
