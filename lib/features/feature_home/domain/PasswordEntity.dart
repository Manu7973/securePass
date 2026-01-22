import 'SiteCategory.dart';

class PasswordEntity {
  final int? id;
  final String site;
  final String username;
  final String password;
  final SiteCategory category;
  final bool isfav;

  PasswordEntity({
    required this.id,
    required this.site,
    required this.username,
    required this.password,
    required this.category,
    required this.isfav,
  });
}
