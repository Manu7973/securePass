import 'package:SecurePass/features/feature_home/domain/SiteCategoryClassifier.dart';
import 'package:hive/hive.dart';

import '../domain/SiteCategory.dart';

part 'hive_storage_passcode.g.dart';

@HiveType(typeId: 1)
class PasswordModel extends HiveObject {
  @HiveField(0)
  String siteName;

  @HiveField(1)
  String username;

  @HiveField(2)
  String password;

  @HiveField(3)
  String category;

  PasswordModel({
    required this.siteName,
    required this.username,
    required this.password,
    required this.category,
  });

  factory PasswordModel.fromJson(Map<String, dynamic> json) {
    return PasswordModel(
      siteName: json['siteName'] ?? '',
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      category: json['category'] ?? '',
    );
  }
}
