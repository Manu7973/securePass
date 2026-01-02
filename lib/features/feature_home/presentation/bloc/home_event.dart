import '../../domain/PasswordEntity.dart';

abstract class PasswordEvent {}

class LoadPasswords extends PasswordEvent {}

class AddPassword extends PasswordEvent {
  final PasswordEntity entity;
  AddPassword(this.entity);
}
