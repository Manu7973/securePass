import 'SettingsRepository.dart';

class ChangePasscode {
  final SettingsRepository repo;
  ChangePasscode(this.repo);

  Future<void> call(String passcode) {
    return repo.changePasscode(passcode);
  }
}
