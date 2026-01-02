import 'PasswordEntity.dart';
import 'PasswordRepository.dart';

class AddPasswordUseCase {
  final PasswordRepository repository;
  AddPasswordUseCase(this.repository);

  Future<void> call(PasswordEntity entity) {
    return repository.addPassword(entity);
  }
}
