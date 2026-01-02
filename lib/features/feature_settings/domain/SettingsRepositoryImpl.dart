import '../../../core/storage/secureStorage/login_passcode_secure.dart';
import '../data/SettingsLocalDataSource.dart';
import 'SettingsRepository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final LoginPasscodeSecure secureStorage;

  SettingsRepositoryImpl(this.secureStorage);

  @override
  Future<void> changePasscode(String passcode) async {
    final faceIdEnabled = await secureStorage.isFaceIdEnabled();
    await secureStorage.savePasscode(passcode, faceIdEnabled);
  }

  @override
  Future<void> toggleFaceId(bool enabled) async {
    final currentPasscode = await secureStorage.getPasscode() ?? '';
    await secureStorage.savePasscode(currentPasscode, enabled);
  }

  @override
  Future<bool> isFaceIdEnabled() {
    return secureStorage.isFaceIdEnabled();
  }

  @override
  Future<void> deleteAllData() {
    return secureStorage.clearAll();
  }

  @override
  Future<String> getPasscode() async {
    return await secureStorage.getPasscode() ?? '';
  }
}
