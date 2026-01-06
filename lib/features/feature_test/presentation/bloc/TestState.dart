abstract class PasscodeState {}

class PasscodeInitial extends PasscodeState {}

class PasscodeLoading extends PasscodeState {}

class PasscodeLoaded extends PasscodeState {
  final String? passcode;
  PasscodeLoaded(this.passcode);
}

class PasscodeError extends PasscodeState {
  final String message;
  PasscodeError(this.message);
}
