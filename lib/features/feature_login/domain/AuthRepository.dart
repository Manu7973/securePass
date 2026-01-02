abstract class AuthRepository {
  Future<String?> getPasscode();
  Future<bool> isFaceIdEnabled();
  Future<bool> authenticateWithFaceId();
  Future<void> clearAll();
}