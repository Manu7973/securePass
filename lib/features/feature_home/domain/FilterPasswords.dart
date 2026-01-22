import '../presentation/bloc/home_event.dart';

class FilterPasswords extends PasswordEvent {
  final bool showFavoritesOnly;
  FilterPasswords(this.showFavoritesOnly);
}
