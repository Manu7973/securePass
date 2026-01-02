abstract class SettingsEvent {}

class LoadSettings extends SettingsEvent {}

class ChangePasscodeEvent extends SettingsEvent {
  final String passcode;
  ChangePasscodeEvent(this.passcode);
}

class ToggleFaceIdEvent extends SettingsEvent {
  final bool enabled;
  ToggleFaceIdEvent(this.enabled);
}

class DeleteAllDataEvent extends SettingsEvent {}
