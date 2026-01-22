import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/AuthenticateWithFaceIdUseCase.dart';
import '../../domain/CheckFaceIdUseCase.dart';
import '../../domain/GetPasscodeUseCase.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final GetPasscodeUseCase getPasscode;
  final CheckFaceIdUseCase checkFaceId;
  final AuthenticateWithFaceIdUseCase authenticateFaceId;

  LoginBloc({
    required this.getPasscode,
    required this.checkFaceId,
    required this.authenticateFaceId,
  }) : super(LoginInitial()) {
    on<LoginStarted>(_onStarted);
    on<PasscodeEntered>(_onPasscodeEntered);
    on<FaceIdFailed>((_, emit) => emit(LoginPasscode()));
  }

  Future<void> _onStarted(LoginStarted event, Emitter<LoginState> emit) async {
    emit(LoginLoading());

    final isBiometricAvailable = await checkFaceId();

    if (!isBiometricAvailable) {
      if (event.fromButton) {
        emit(
          LoginFailure(
            Platform.isIOS
                ? 'Please log in and enable Face ID from Settings.'
                : 'Biometric authentication is not available on this device.',
          ),
        );
      }
      emit(LoginPasscode());
      return;
    }

    emit(LoginFaceId());

    try {
      final success = await authenticateFaceId();
      print('Biometric result: $success');
      if (success) {
        emit(LoginSuccess());
      } else {
        emit(LoginPasscode());
      }
    } catch (_) {
      emit(LoginPasscode());
    }
  }

  Future<void> _onPasscodeEntered(
    PasscodeEntered event,
    Emitter<LoginState> emit,
  ) async {
    final stored = await getPasscode();
    if (event.passcode == stored) {
      emit(LoginSuccess());
    } else {
      emit(LoginFailure('Incorrect passcode'));
      emit(LoginPasscode());
    }
  }
}
