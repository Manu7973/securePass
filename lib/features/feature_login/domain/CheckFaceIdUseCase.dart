import 'dart:io';

import 'package:SecurePass/features/feature_login/domain/AuthRepository.dart';

class CheckFaceIdUseCase {
  final AuthRepository repository;
  CheckFaceIdUseCase(this.repository);
  Future<bool> call() async => repository.isFaceIdEnabled();
}
