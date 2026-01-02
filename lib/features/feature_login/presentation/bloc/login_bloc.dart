import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/AuthRepository.dart';
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

  Future<void> _onStarted(
      LoginStarted event,
      Emitter<LoginState> emit,
      ) async {
    emit(LoginLoading());

    final isFaceEnabled = await checkFaceId();

    if (!isFaceEnabled) {
      emit(LoginPasscode());
      return;
    }

    // Show Face ID UI
    emit(LoginFaceId());

    try {
      final success = await authenticateFaceId()
          .timeout(const Duration(seconds: 8));

      if (success) {
        emit(LoginSuccess());
      } else {
        emit(LoginPasscode());
      }
    } catch (e) {
      // 🔥 THIS prevents infinite loading on real device
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


