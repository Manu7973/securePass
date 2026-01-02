abstract class SettingsLocalDataSource {
  Future<void> changePasscode(String passcode);
  Future<void> setFaceId(bool enabled);
  Future<bool> isFaceIdEnabled();
  Future<void> deleteAllData();
}
