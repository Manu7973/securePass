abstract class RegisterEvent {}

class DigitEntered extends RegisterEvent {
  final String digit;
  DigitEntered(this.digit);
}

class DigitRemoved extends RegisterEvent {}

class FaceIdToggled extends RegisterEvent {
  final bool enabled;
  FaceIdToggled(this.enabled);
}

class RegisterSubmitted extends RegisterEvent {}