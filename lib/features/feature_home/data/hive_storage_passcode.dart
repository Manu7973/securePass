import 'package:hive/hive.dart';
part  'hive_storage_passcode.g.dart';

@HiveType(typeId: 1)
class PasswordModel extends HiveObject {
  @HiveField(0)
   String siteName;

  @HiveField(1)
   String username;

  @HiveField(2)
  String password;

  PasswordModel({
    required this.siteName,
    required this.username,
    required this.password,
  });

  factory PasswordModel.fromJson(Map<String, dynamic> json) {
    return PasswordModel(
      siteName: json['siteName'] ?? '',
      username: json['username'] ?? '',
      password: json['password'] ?? '',
    );
  }
}
