class SettingsState {
  final bool loading;
  final bool faceIdEnabled;
  final String passcode;
  final bool deleted;

  const SettingsState({
    this.loading = false,
    this.faceIdEnabled = false,
    this.passcode = "",
    this.deleted = false,
  });

  SettingsState copyWith({
    bool? loading,
    bool? faceIdEnabled,
    String? passcode,
    bool? deleted,
  }) {
    return SettingsState(
      loading: loading ?? this.loading,
      faceIdEnabled: faceIdEnabled ?? this.faceIdEnabled,
      passcode: passcode ?? this.passcode,
      deleted: deleted ?? this.deleted,
    );
  }

  /// (optional but recommended)
  factory SettingsState.initial() {
    return const SettingsState();
  }
}
