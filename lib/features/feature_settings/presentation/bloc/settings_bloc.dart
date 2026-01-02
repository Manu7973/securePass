import 'package:SecurePass/features/feature_settings/presentation/bloc/settings_event.dart';
import 'package:SecurePass/features/feature_settings/presentation/bloc/settings_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/ChangePasscode.dart';
import '../../domain/DeleteAllData.dart';
import '../../domain/SettingsRepository.dart';
import '../../domain/ToggleFaceId.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final ChangePasscode changePasscode;
  final ToggleFaceId toggleFaceId;
  final DeleteAllData deleteAllData;
  final SettingsRepository repo;

  SettingsBloc({
    required this.changePasscode,
    required this.toggleFaceId,
    required this.deleteAllData,
    required this.repo,
  }) : super(SettingsState.initial()) {
    on<LoadSettings>(_onLoad);
    on<ChangePasscodeEvent>(_onChangePasscode);
    on<ToggleFaceIdEvent>(_onToggleFaceId);
    on<DeleteAllDataEvent>(_onDeleteAll);
  }

  // Future<void> _onLoad(LoadSettings event,
  //     Emitter<SettingsState> emit,) async {
  //   final faceId = await repo.isFaceIdEnabled();
  //   emit(state.copyWith(faceIdEnabled: faceId));
  // }

  Future<void> _onLoad(LoadSettings event, Emitter<SettingsState> emit) async {
    final faceId = await repo.isFaceIdEnabled();
    final savedPasscode = await repo.getPasscode();
    emit(state.copyWith(
      faceIdEnabled: faceId,
      passcode: savedPasscode,
    ));
  }

  // Future<void> _onChangePasscode(ChangePasscodeEvent event,
  //     Emitter<SettingsState> emit,) async {
  //   await changePasscode(event.passcode);
  // }

  Future<void> _onChangePasscode(
      ChangePasscodeEvent event,
      Emitter<SettingsState> emit,
      ) async {
    await changePasscode(event.passcode); // save in storage
    emit(state.copyWith(passcode: event.passcode)); // update state
  }


  Future<void> _onToggleFaceId(ToggleFaceIdEvent event,
      Emitter<SettingsState> emit,) async {
    await toggleFaceId(event.enabled);
    emit(state.copyWith(faceIdEnabled: event.enabled));
  }

  Future<void> _onDeleteAll(DeleteAllDataEvent event,
      Emitter<SettingsState> emit,) async {
    emit(state.copyWith(loading: true));

    await deleteAllData();

    emit(
      state.copyWith(
        loading: false,
        deleted: true,
      ),
    );
  }

}
