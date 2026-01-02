import 'Passcode.dart';

abstract class AuthRepository {
  Future<void> savePasscode(Passcode passcode);
}