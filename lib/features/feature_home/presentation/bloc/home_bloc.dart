import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/AddPasswordUseCase.dart';
import '../../domain/GetPasswordsUseCase.dart';
import 'home_event.dart';
import 'home_state.dart';


class PasswordBloc extends Bloc<PasswordEvent, PasswordState> {
  final GetPasswordsUseCase getPasswords;
  final AddPasswordUseCase addPassword;

  PasswordBloc({
    required this.getPasswords,
    required this.addPassword,
  }) : super(PasswordInitial()) {
    on<LoadPasswords>(_onLoad);
    on<AddPassword>(_onAdd);
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

  Future<void> _onAdd(AddPassword event, Emitter<PasswordState> emit) async {
    await addPassword(event.entity);
    add(LoadPasswords()); // reload after add
  }
}

