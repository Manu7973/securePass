import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginPasscodeSecure {
  final _loginStorage = const FlutterSecureStorage();

  static const _passcodeKey = 'passcode';
  static const _faceIdKey = 'faceId';

  Future<void> savePasscode(String code, bool faceId) async {
    await _loginStorage.write(key: _passcodeKey, value: code);
    await _loginStorage.write(key: _faceIdKey, value: faceId.toString());
  }

  Future<String?> getPasscode() async {
    return await _loginStorage.read(key: _passcodeKey);
  }

  Future<bool> isFaceIdEnabled() async {
    final value = await _loginStorage.read(key: _faceIdKey);
    return value == 'true';
  }

  Future<void> clearAll() async {
    await _loginStorage.delete(key: _passcodeKey);
    await _loginStorage.delete(key: _faceIdKey);
  }
}
