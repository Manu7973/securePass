import '../../../core/storage/secureStorage/login_passcode_secure.dart';

abstract class SettingsRepository {
  Future<void> changePasscode(String passcode);
  Future<void> toggleFaceId(bool enabled);
  Future<bool> isFaceIdEnabled();
  Future<void> deleteAllData();
  Future<String> getPasscode();
}
