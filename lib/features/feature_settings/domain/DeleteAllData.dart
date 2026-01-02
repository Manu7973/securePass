import 'SettingsRepository.dart';

class DeleteAllData {
  final SettingsRepository repo;
  DeleteAllData(this.repo);

  Future<void> call() {
    return repo.deleteAllData();
  }
}
