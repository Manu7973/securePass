abstract class LoginEvent {}

class LoginStarted extends LoginEvent {}

class PasscodeEntered extends LoginEvent {
  final String passcode;
  PasscodeEntered(this.passcode);
}

class FaceIdFailed extends LoginEvent {}

