import 'package:SecurePass/features/feature_home/domain/UpdatePasswordUseCase.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/blocs/AppLockEvent.dart';
import 'core/observers/AppLifecycleObserver.dart';
import 'core/routes/appRoutes.dart';
import 'core/storage/secureStorage/login_passcode_secure.dart';
import 'core/storage/sharedPref/shared_Pref.dart';
import 'features/feature_home/data/PasswordLocalDataSourceImpl.dart';
import 'features/feature_home/data/hive_storage_passcode.dart';
import 'features/feature_home/domain/AddPasswordUseCase.dart';
import 'features/feature_home/domain/DeletePasswordUseCase.dart';
import 'features/feature_home/domain/GetPasswordsUseCase.dart';
import 'features/feature_home/domain/PasswordRepositoryImpl.dart';
import 'features/feature_login/data/BiometricAuthService.dart';
import 'features/feature_login/domain/AuthenticateWithFaceIdUseCase.dart';
import 'features/feature_login/domain/CheckFaceIdUseCase.dart';
import 'features/feature_login/domain/GetPasscodeUseCase.dart';
import 'features/feature_login/domain/HasPasscodeUseCase.dart';
import 'features/feature_register/data/AuthRepositoryImpl.dart';
import 'features/feature_login/data/login_authRepositoryImpl.dart';
import 'features/feature_register/domain/SavePasscodeUseCase.dart';
import 'features/feature_settings/domain/ChangePasscode.dart';
import 'features/feature_settings/domain/DeleteAllData.dart';
import 'features/feature_settings/domain/SettingsRepository.dart';
import 'features/feature_settings/domain/SettingsRepositoryImpl.dart';
import 'features/feature_settings/domain/ToggleFaceId.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Init Shared Preferences (if needed)
  await SharedPref.init();

  //Status bar - Ios
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
  );

  // Initialize your data sources & repository
  final secureStorageDS = LoginPasscodeSecure();
  // await secureStorageDS.clearAll();

  // 🔐 Init Hive
  await Hive.initFlutter();
  // await Hive.deleteBoxFromDisk('passwords');
  Hive.registerAdapter(PasswordModelAdapter());

  final registerAuthRepo = AuthRepositoryImpl(secureStorageDS);
  final faceIdService = FaceIdAuthService();
  final loginAuthRepo = LoginAuthRepositoryImpl(secureStorageDS, faceIdService);

  // Initialize Use Cases
  final savePasscodeUseCase = SavePasscodeUseCase(registerAuthRepo);
  final getPasscodeUseCase = GetPasscodeUseCase(loginAuthRepo);
  final checkFaceIdUseCase = CheckFaceIdUseCase(loginAuthRepo);
  final authenticateFaceIdUseCase = AuthenticateWithFaceIdUseCase(
    loginAuthRepo,
  );

  final hasPasscodeUseCase = HasPasscodeUseCase(loginAuthRepo);
  final hasPasscode = await hasPasscodeUseCase();

  // 🏠 HOME (Vault) setup
  final passwordBox = await Hive.openBox<PasswordModel>('passwords');
  final passwordLocalDS = PasswordLocalDataSourceImpl(passwordBox);
  final passwordRepository = PasswordRepositoryImpl(passwordLocalDS);

  final getPasswordsUseCase = GetPasswordsUseCase(passwordRepository);
  final addPasswordUseCase = AddPasswordUseCase(passwordRepository);
  final deletePasswordUseCase = DeletePasswordUseCase(passwordRepository);
  final updatePasswordUseCase = UpdatePasswordUseCase(passwordRepository);

  final settingsRepository = SettingsRepositoryImpl(secureStorageDS);
  final changePasscodeUseCase = ChangePasscode(settingsRepository);
  final toggleFaceIdUseCase = ToggleFaceId(settingsRepository);
  final deleteAllDataUseCase = DeleteAllData(settingsRepository);

  // final appLockBloc = AppLockBloc();
  // WidgetsBinding.instance.addObserver(
  //   AppLifecycleObserver(appLockBloc),
  // );

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: registerAuthRepo),
        RepositoryProvider.value(value: savePasscodeUseCase),
        RepositoryProvider.value(value: getPasscodeUseCase),
        RepositoryProvider.value(value: checkFaceIdUseCase),
        RepositoryProvider.value(value: authenticateFaceIdUseCase),

        // Home (Vault)
        RepositoryProvider.value(value: getPasswordsUseCase),
        RepositoryProvider.value(value: addPasswordUseCase),
        RepositoryProvider.value(value: deletePasswordUseCase),
        RepositoryProvider.value(value: updatePasswordUseCase),

        // Settings
        RepositoryProvider<SettingsRepository>(
          create: (_) => settingsRepository,
        ),
        RepositoryProvider<ChangePasscode>(
          create: (_) => changePasscodeUseCase,
        ),
        RepositoryProvider<ToggleFaceId>(create: (_) => toggleFaceIdUseCase),
        RepositoryProvider<DeleteAllData>(create: (_) => deleteAllDataUseCase),

        // BlocProvider.value(value: appLockBloc),
      ],
      child: MyApp(hc: hasPasscode),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool hc;

  const MyApp({super.key, required this.hc});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: hc ? AppRoutes.login : AppRoutes.register,
      // home: hc ? const LoginScreen() : const RegisterScreen(),
      routes: AppRoutes.routes,
    );
  }
}

// class MyApp extends StatelessWidget {
//   final bool hc;
//
//   const MyApp({super.key, required this.hc});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<AppLockBloc, AppLockState>(
//       listener: (context, state) {
//         if (state.isLocked) {
//           Navigator.pushNamedAndRemoveUntil(
//             context,
//             AppRoutes.login,
//                 (_) => false,
//           );
//         }
//       },
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         initialRoute: hc ? AppRoutes.login : AppRoutes.register,
//         routes: AppRoutes.routes,
//       ),
//     );
//
//   }
// }
