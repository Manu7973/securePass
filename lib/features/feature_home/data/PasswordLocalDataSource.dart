import 'hive_storage_passcode.dart';

// abstract class PasswordLocalDataSource{
//   Future<List<PasswordModel>> getPasswords();
//   Future<void> addPassword(PasswordModel model);
// }

abstract class PasswordLocalDataSource {
  Future<List<PasswordModel>> getPasswords();
  Future<void> addPassword(PasswordModel model);
  Future<void> updatePassword(int id, PasswordModel model);
  Future<void> deletePassword(int id);
}