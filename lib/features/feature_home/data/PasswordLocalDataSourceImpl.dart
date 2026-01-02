import 'package:SecurePass/features/feature_home/data/hive_storage_passcode.dart';
import 'package:hive/hive.dart';

import 'PasswordLocalDataSource.dart';

class PasswordLocalDataSourceImpl implements PasswordLocalDataSource {
  final Box<PasswordModel> box;

  PasswordLocalDataSourceImpl(this.box);

  @override
  Future<List<PasswordModel>> getPasswords() async {
    return box.values.toList();
  }

  @override
  Future<void> addPassword(PasswordModel model) async {
    await box.add(model);
  }

  @override
  Future<void> deletePassword(int id) async {
    await box.delete(id);
  }

  @override
  Future<void> updatePassword(int id, PasswordModel model) async {
    final existing = box.get(id);

    if (existing != null) {
      existing
        ..siteName = model.siteName
        ..username = model.username
        ..password = model.password;

      await existing.save(); // 🔥 THIS updates Hive
    }
  }
}
