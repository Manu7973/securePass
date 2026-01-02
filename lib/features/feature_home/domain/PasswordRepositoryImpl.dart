import '../data/PasswordLocalDataSource.dart';
import '../data/hive_storage_passcode.dart';
import 'PasswordEntity.dart';
import 'PasswordRepository.dart';

class PasswordRepositoryImpl implements PasswordRepository {
  final PasswordLocalDataSource local;

  PasswordRepositoryImpl(this.local);

  @override
  Future<List<PasswordEntity>> getPasswords() async {
    final models = await local.getPasswords();
    return models
        .map(
          (e) => PasswordEntity(
        id: e.key as int,
        site: e.siteName,
        username: e.username,
        password: e.password,
      ),
    )
        .toList();
  }

  @override
  Future<void> addPassword(PasswordEntity entity) async {
    await local.addPassword(
      PasswordModel(
        siteName: entity.site,
        username: entity.username,
        password: entity.password,
      ),
    );
  }

  @override
  Future<void> deletePassword(int id) async {
    await local.deletePassword(id);
  }

  @override
  Future<void> updatePassword(PasswordEntity entity) async {
    await local.updatePassword(
      entity.id!,
      PasswordModel(
        siteName: entity.site,
        username: entity.username,
        password: entity.password,
      ),
    );
  }
}
