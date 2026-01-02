import 'package:SecurePass/features/feature_login/domain/AuthRepository.dart';

class HasPasscodeUseCase {
  final AuthRepository repository;
  HasPasscodeUseCase(this.repository);

  Future<bool> call() async {
    final passcode = await repository.getPasscode();
    return passcode != null && passcode.isNotEmpty;
  }
}
