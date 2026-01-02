import 'package:SecurePass/features/feature_login/domain/AuthRepository.dart';

class AuthenticateWithFaceIdUseCase {
  final AuthRepository repository;
  AuthenticateWithFaceIdUseCase(this.repository);

  Future<bool> call() => repository.authenticateWithFaceId();
}
