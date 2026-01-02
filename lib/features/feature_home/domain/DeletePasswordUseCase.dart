import 'PasswordRepository.dart';

class DeletePasswordUseCase {
  final PasswordRepository repository;

  DeletePasswordUseCase(this.repository);

  Future<void> call(int id) async {
    await repository.deletePassword(id);
  }
}
