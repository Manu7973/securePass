import 'dart:io';
import 'package:SecurePass/features/feature_home/domain/UpdatePasswordUseCase.dart';
import 'package:SecurePass/features/feature_settings/presentation/screens/settings_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/feature_home/domain/AddPasswordUseCase.dart';
import '../../features/feature_home/domain/DeletePasswordUseCase.dart';
import '../../features/feature_home/domain/GetPasswordsUseCase.dart';
import '../../features/feature_home/presentation/bloc/home_bloc.dart';
import '../../features/feature_home/presentation/bloc/home_event.dart';
import '../../features/feature_home/presentation/screens/home_screen.dart';
import '../../features/feature_login/domain/AuthenticateWithFaceIdUseCase.dart';
import '../../features/feature_login/domain/CheckFaceIdUseCase.dart';
import '../../features/feature_login/domain/GetPasscodeUseCase.dart';
import '../../features/feature_login/presentation/bloc/login_bloc.dart';
import '../../features/feature_login/presentation/bloc/login_event.dart';
import '../../features/feature_login/presentation/screens/login_screen_android.dart';
import '../../features/feature_login/presentation/screens/login_screen_ios.dart';
import '../../features/feature_register/domain/SavePasscodeUseCase.dart';
import '../../features/feature_register/presentation/bloc/register_bloc.dart';
import '../../features/feature_register/presentation/screens/register_screen_ios.dart';
import '../../features/feature_register/presentation/screens/register_screen_android.dart';
import '../../features/feature_settings/domain/ChangePasscode.dart';
import '../../features/feature_settings/domain/DeleteAllData.dart';
import '../../features/feature_settings/domain/SettingsRepository.dart';
import '../../features/feature_settings/domain/ToggleFaceId.dart';
import '../../features/feature_settings/presentation/bloc/settings_bloc.dart';
import '../../features/feature_settings/presentation/bloc/settings_event.dart';

class AppRoutes {
  static const splash = '/splash';
  static const register = '/register';
  static const login = '/login';
  static const home = '/home';
  static const settings = '/settings';
  static const testing = '/testing';

  static Map<String, WidgetBuilder> routes = {
    register: (context) => BlocProvider(
      create: (_) => RegisterBloc(context.read<SavePasscodeUseCase>()),
      child: Platform.isIOS
          ? const RegisterScreeniOS()
          : const RegisterScreenAndroid(),
    ),

    login: (context) => BlocProvider(
      create: (_) => LoginBloc(
        getPasscode: context.read<GetPasscodeUseCase>(),
        checkFaceId: context.read<CheckFaceIdUseCase>(),
        authenticateFaceId: context.read<AuthenticateWithFaceIdUseCase>(),
      )..add(LoginStarted(fromButton: false)),
      child: Platform.isIOS
          ? const LoginScreenIOS()
          : const LoginScreenAndroid(),
    ),

    home: (context) => BlocProvider(
      create: (_) => PasswordBloc(
        getPasswords: context.read<GetPasswordsUseCase>(),
        addPassword: context.read<AddPasswordUseCase>(),
        updatePassword: context.read<UpdatePasswordUseCase>(),
        deletePassword: context.read<DeletePasswordUseCase>(),
      )..add(LoadPasswords()),
      child:  HomeScreen(),
    ),

    settings: (context) => BlocProvider(
      create: (_) => SettingsBloc(
        changePasscode: context.read<ChangePasscode>(),
        toggleFaceId: context.read<ToggleFaceId>(),
        deleteAllData: context.read<DeleteAllData>(),
        repo: context.read<SettingsRepository>(),
      )..add(LoadSettings()),
      child: const SettingsScreen(),
    ),
  };
}
