import 'package:SecurePass/features/feature_test/presentation/bloc/TestEvent.dart';
import 'package:SecurePass/features/feature_test/presentation/bloc/TestState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/storage/secureStorage/login_passcode_secure.dart';

// class FetchBloc extends Bloc<FetchState, FetchEvent> {
//   final LoginPasscodeSecure secureStorage;
//
//   FetchBloc(this.secureStorage) : super(FetchInitial()) {
//     on<FetchPasscode>((event, emit) async {
//       emit(FetchLoading());
//
//       try {
//         final passcode = await secureStorage.getPasscode();
//         emit(FetchLoaded(passcode));
//       } catch (e) {
//         emit(FetchError("Failed to load passcode"));
//       }
//     });
//   }
// }

class PasscodeBloc extends Bloc<FetchEvent, PasscodeState> {
  final LoginPasscodeSecure secureStorage;

  PasscodeBloc(this.secureStorage) : super(PasscodeInitial()) {

    on<FetchPasscode>((event, emit) async {
      emit(PasscodeLoading());

      try {
        final passcode = await secureStorage.getPasscode();
        emit(PasscodeLoaded(passcode));
      } catch (e) {
        emit(PasscodeError("Failed to load passcode"));
      }
    });

  }
}


