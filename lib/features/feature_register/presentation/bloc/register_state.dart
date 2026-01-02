class RegisterState {
  final String enteredDigits;
  final String confirmDigits;
  final bool isConfirmStep;
  final bool faceIdEnabled;
  final bool success;
  final String? error;

  const RegisterState({
    this.enteredDigits = '',
    this.confirmDigits = '',
    this.isConfirmStep = false,
    this.faceIdEnabled = false,
    this.success = false,
    this.error,
  });

  bool get canSubmit => isConfirmStep && confirmDigits.length == 4;

  RegisterState copyWith({
    String? enteredDigits,
    String? confirmDigits,
    bool? isConfirmStep,
    bool? faceIdEnabled,
    bool? success,
    String? error,
  }) {
    return RegisterState(
      enteredDigits: enteredDigits ?? this.enteredDigits,
      confirmDigits: confirmDigits ?? this.confirmDigits,
      isConfirmStep: isConfirmStep ?? this.isConfirmStep,
      faceIdEnabled: faceIdEnabled ?? this.faceIdEnabled,
      success: success ?? this.success,
      error: error,
    );
  }
}