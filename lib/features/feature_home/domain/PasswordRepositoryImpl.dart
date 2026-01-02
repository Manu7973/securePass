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
        .map((e) => PasswordEntity(
      site: e.siteName,
      username: e.username,
      password: e.password,
    ))
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
}
