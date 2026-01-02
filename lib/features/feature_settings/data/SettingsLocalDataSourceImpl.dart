
import 'package:hive/hive.dart';

import '../../../core/storage/secureStorage/login_passcode_secure.dart';
import '../../feature_home/data/hive_storage_passcode.dart';
import 'SettingsLocalDataSource.dart';

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final LoginPasscodeSecure secureStorage;
  final Box<PasswordModel> passwordBox;

  SettingsLocalDataSourceImpl({
    required this.secureStorage,
    required this.passwordBox,
  });

  @override
  Future<void> changePasscode(String passcode) async {
    final faceId = await secureStorage.isFaceIdEnabled();
    await secureStorage.savePasscode(passcode, faceId);
  }

  @override
  Future<void> setFaceId(bool enabled) async {
    final passcode = await secureStorage.getPasscode();
    if (passcode != null) {
      await secureStorage.savePasscode(passcode, enabled);
    }
  }

  @override
  Future<bool> isFaceIdEnabled() {
    return secureStorage.isFaceIdEnabled();
  }

  @override
  Future<void> deleteAllData() async {
    await passwordBox.clear();
    await secureStorage.clearAll();
  }
}
