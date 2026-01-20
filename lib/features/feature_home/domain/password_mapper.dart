import '../data/hive_storage_passcode.dart';
import 'PasswordEntity.dart';
import 'SiteCategory.dart';

extension PasswordModelMapper on PasswordModel {
  PasswordEntity toEntity() => PasswordEntity(
    id: key as int,
    site: siteName,
    username: username,
    password: password,
    category: SiteCategory.values.firstWhere(
          (e) => e.name == category,
      orElse: () => SiteCategory.unknown,
    ),
  );
}

extension PasswordEntityMapper on PasswordEntity {
  PasswordModel toModel() => PasswordModel(
    siteName: site,
    username: username,
    password: password,
    category: category.name,
  );
}
