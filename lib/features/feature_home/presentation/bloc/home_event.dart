import '../../domain/PasswordEntity.dart';

abstract class PasswordEvent {}

class LoadPasswords extends PasswordEvent {}

class AddPassword extends PasswordEvent {
  final PasswordEntity entity;
  AddPassword(this.entity);
}

class DeletePassword extends PasswordEvent {
  final int id;
  DeletePassword(this.id);
}

class UpdatePassword extends PasswordEvent {
  final PasswordEntity entity;
  UpdatePassword(this.entity);
}