import 'AuthRepositery.dart';
import 'Passcode.dart';

class SavePasscodeUseCase {
  final AuthRepository repository;

  SavePasscodeUseCase(this.repository);

  Future<void> call(Passcode passcode) async {
    await repository.savePasscode(passcode);
  }
}