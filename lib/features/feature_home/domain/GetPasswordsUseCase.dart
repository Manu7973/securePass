import 'PasswordEntity.dart';
import 'PasswordRepository.dart';

class GetPasswordsUseCase {
  final PasswordRepository repository;
  GetPasswordsUseCase(this.repository);

  Future<List<PasswordEntity>> call() {
    return repository.getPasswords();
  }
}