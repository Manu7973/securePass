import '../../../core/storage/secureStorage/login_passcode_secure.dart';
import '../domain/AuthRepositery.dart';
import '../domain/Passcode.dart';

class AuthRepositoryImpl implements AuthRepository {
  final LoginPasscodeSecure dataSource;

  AuthRepositoryImpl(this.dataSource);

  @override
  Future<void> savePasscode(Passcode passcode) async {
    await dataSource.savePasscode(passcode.code, passcode.faceIdEnabled);
  }
}