import 'PasswordEntity.dart';
import 'PasswordRepository.dart';

class UpdatePasswordUseCase {
  final PasswordRepository repository;

  UpdatePasswordUseCase(this.repository);

  Future<void> call(PasswordEntity entity) async {
    await repository.updatePassword(entity);
  }
}
