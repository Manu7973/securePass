import 'hive_storage_passcode.dart';

abstract class PasswordLocalDataSource{
  Future<List<PasswordModel>> getPasswords();
  Future<void> addPassword(PasswordModel model);
}