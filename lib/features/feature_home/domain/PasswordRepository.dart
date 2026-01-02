import 'PasswordEntity.dart';

abstract class PasswordRepository {
  Future<List<PasswordEntity>> getPasswords();
  Future<void> addPassword(PasswordEntity entity);
}