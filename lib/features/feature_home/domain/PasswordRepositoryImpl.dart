import '../data/PasswordLocalDataSource.dart';
import '../data/hive_storage_passcode.dart';
import 'PasswordEntity.dart';
import 'PasswordRepository.dart';
import 'SiteCategory.dart';

class PasswordRepositoryImpl implements PasswordRepository {
  final PasswordLocalDataSource local;

  PasswordRepositoryImpl(this.local);

  @override
  Future<List<PasswordEntity>> getPasswords() async {
    final models = await local.getPasswords();

    return models.map((model) {
      return PasswordEntity(
        id: model.key as int,
        site: model.siteName,
        username: model.username,
        password: model.password,
        category: SiteCategory.values.firstWhere(
              (category) => category.name == model.category,
          orElse: () => SiteCategory.other,
        ),
        isfav: model.isFav
      );
    }).toList();
  }


  @override
  Future<void> addPassword(PasswordEntity entity) async {
    await local.addPassword(
      PasswordModel(
        siteName: entity.site,
        username: entity.username,
        password: entity.password,
        category: entity.category.name,
        isFav: entity.isfav
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
        category: entity.category.name,
        isFav: entity.isfav
      ),
    );
  }
}
