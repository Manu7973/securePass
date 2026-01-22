abstract class LoginEvent {}

class LoginStarted extends LoginEvent {
  final bool fromButton;

  LoginStarted({this.fromButton = false});
}

class PasscodeEntered extends LoginEvent {
  final String passcode;

  PasscodeEntered(this.passcode);
}

class FaceIdFailed extends LoginEvent {}
