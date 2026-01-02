import 'package:SecurePass/features/feature_login/domain/AuthRepository.dart';

class GetPasscodeUseCase {
  final AuthRepository repository;
  GetPasscodeUseCase(this.repository);

  Future<String?> call() async => repository.getPasscode();
}
