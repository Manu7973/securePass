import 'package:SecurePass/features/feature_register/presentation/bloc/register_event.dart';
import 'package:SecurePass/features/feature_register/presentation/bloc/register_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/Passcode.dart';
import '../../domain/SavePasscodeUseCase.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final SavePasscodeUseCase savePasscodeUseCase;

  RegisterBloc(this.savePasscodeUseCase) : super(const RegisterState()) {
    on<DigitEntered>(_onDigitEntered);
    on<DigitRemoved>(_onDigitRemoved);
    on<FaceIdToggled>(_onFaceIdToggled);
    on<RegisterSubmitted>(_onRegisterSubmitted);
  }

  void _onDigitEntered(DigitEntered event, Emitter<RegisterState> emit) {
    if (!state.isConfirmStep) {
      if (state.enteredDigits.length < 4) {
        final updated = state.enteredDigits + event.digit;
        emit(state.copyWith(enteredDigits: updated));

        if (updated.length == 4) {
          emit(state.copyWith(isConfirmStep: true));
        }
      }
    } else {
      if (state.confirmDigits.length < 4) {
        emit(state.copyWith(
          confirmDigits: state.confirmDigits + event.digit,
        ));
      }
    }
  }

  void _onDigitRemoved(DigitRemoved event, Emitter<RegisterState> emit) {
    if (!state.isConfirmStep && state.enteredDigits.isNotEmpty) {
      emit(state.copyWith(
        enteredDigits:
        state.enteredDigits.substring(0, state.enteredDigits.length - 1),
      ));
    } else if (state.isConfirmStep && state.confirmDigits.isNotEmpty) {
      emit(state.copyWith(
        confirmDigits:
        state.confirmDigits.substring(0, state.confirmDigits.length - 1),
      ));
    }
  }

  void _onFaceIdToggled(
      FaceIdToggled event,
      Emitter<RegisterState> emit,
      ) {
    emit(state.copyWith(faceIdEnabled: event.enabled));
  }

  Future<void> _onRegisterSubmitted(
      RegisterSubmitted event,
      Emitter<RegisterState> emit,
      ) async {
    if (state.enteredDigits != state.confirmDigits) {
      emit(state.copyWith(
        error: 'Passcodes do not match',
        success: false,
      ));
      return;
    }

    try {
      await savePasscodeUseCase(
        Passcode(
          code: state.enteredDigits,
          faceIdEnabled: state.faceIdEnabled,
        ),
      );
      emit(state.copyWith(success: true, error: null));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), success: false));
    }
  }
}


