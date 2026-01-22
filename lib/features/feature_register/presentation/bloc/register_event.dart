import 'package:equatable/equatable.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object?> get props => [];
}

class DigitEntered extends RegisterEvent {
  final String digit;
  const DigitEntered(this.digit);

  @override
  List<Object?> get props => [digit];
}

class DigitRemoved extends RegisterEvent {}

class FaceIdToggled extends RegisterEvent {
  final bool enabled;
  const FaceIdToggled(this.enabled);

  @override
  List<Object?> get props => [enabled];
}

class RegisterSubmitted extends RegisterEvent {}

