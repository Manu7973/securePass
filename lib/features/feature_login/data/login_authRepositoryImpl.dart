import 'package:SecurePass/features/feature_login/domain/AuthRepository.dart';
import '../../../core/storage/secureStorage/login_passcode_secure.dart';
import 'BiometricAuthService.dart';

class LoginAuthRepositoryImpl implements AuthRepository {
  final LoginPasscodeSecure secureStorage;
  final FaceIdAuthService faceIdService;

  LoginAuthRepositoryImpl(this.secureStorage, this.faceIdService);

  @override
  Future<String?> getPasscode() => secureStorage.getPasscode();

  @override
  Future<bool> isFaceIdEnabled() => secureStorage.isFaceIdEnabled();

  @override
  Future<bool> authenticateWithFaceId() => faceIdService.authenticate();

  @override
  Future<void> clearAll() => secureStorage.clearAll();
}
