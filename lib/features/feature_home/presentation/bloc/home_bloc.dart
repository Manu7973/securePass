import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/AddPasswordUseCase.dart';
import '../../domain/DeletePasswordUseCase.dart';
import '../../domain/GetPasswordsUseCase.dart';
import '../../domain/PasswordEntity.dart';
import '../../domain/UpdatePasswordUseCase.dart';
import 'home_event.dart';
import 'home_state.dart';


class PasswordBloc extends Bloc<PasswordEvent, PasswordState> {
  final GetPasswordsUseCase getPasswords;
  final AddPasswordUseCase addPassword;
  final DeletePasswordUseCase deletePassword;
  final UpdatePasswordUseCase updatePassword;

  List<PasswordEntity> _allPasswords = [];

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
    on<SearchPasswords>(_onSearch);
  }

  Future<void> _onLoad(LoadPasswords event, Emitter<PasswordState> emit) async {
    emit(PasswordLoading());
    final passwords = await getPasswords();
    _allPasswords = passwords;
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

  void _onSearch(
      SearchPasswords event,
      Emitter<PasswordState> emit,
      ) {
    final query = event.query.trim().toLowerCase();

    if (query.isEmpty) {
      emit(_allPasswords.isEmpty
          ? PasswordEmpty()
          : PasswordLoaded(_allPasswords));
      return;
    }

    final filtered = _allPasswords.where((password) {
      return password.site.toLowerCase().contains(query);
    }).toList();

    emit(filtered.isEmpty
        ? PasswordEmpty()
        : PasswordLoaded(filtered));
  }
}

