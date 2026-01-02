import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/AddPasswordUseCase.dart';
import '../../domain/DeletePasswordUseCase.dart';
import '../../domain/GetPasswordsUseCase.dart';
import '../../domain/UpdatePasswordUseCase.dart';
import 'home_event.dart';
import 'home_state.dart';


class PasswordBloc extends Bloc<PasswordEvent, PasswordState> {
  final GetPasswordsUseCase getPasswords;
  final AddPasswordUseCase addPassword;
  final DeletePasswordUseCase deletePassword;
  final UpdatePasswordUseCase updatePassword;

  PasswordBloc({
    required this.getPasswords,
    required this.addPassword,
    required this.deletePassword,
    required this.updatePassword,
  }) : super(PasswordInitial()) {
    on<LoadPasswords>(_onLoad);
    on<AddPassword>(_onAdd);
    on<DeletePassword>(_onDelete);
    on<UpdatePassword>(_onUpdate);
  }

  Future<void> _onLoad(LoadPasswords event, Emitter<PasswordState> emit) async {
    emit(PasswordLoading());
    final passwords = await getPasswords();
    if (passwords.isEmpty) {
      emit(PasswordEmpty());
    } else {
      emit(PasswordLoaded(passwords));
    }
  }

  Future<void> _onDelete(
      DeletePassword event,
      Emitter<PasswordState> emit,
      ) async {
    await deletePassword(event.id);
    add(LoadPasswords()); // refresh list
  }

  Future<void> _onAdd(AddPassword event, Emitter<PasswordState> emit) async {
    await addPassword(event.entity);
    add(LoadPasswords()); // reload after add
  }

  Future<void> _onUpdate(
      UpdatePassword event,
      Emitter<PasswordState> emit,
      ) async {
    await updatePassword(event.entity);
    add(LoadPasswords()); // refresh list
  }

}

