import 'package:flutter/material.dart';

import '../../../../core/storage/secureStorage/login_passcode_secure.dart';
import '../../../feature_login/data/BiometricAuthService.dart';
import '../../../feature_login/data/login_authRepositoryImpl.dart';
import '../../../feature_login/domain/HasPasscodeUseCase.dart';
import '../../../feature_login/presentation/screens/LoginScreen.dart';
import '../../../feature_register/presentation/screens/register_screen.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});
//
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//
//     Future.delayed(const Duration(seconds: 3), () {
//       if (!mounted) return;
//       // Navigator.pushReplacementNamed(context, AppRoutes.login);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0F172A),
//       body: Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Image.asset(
//               'assets/images/app_icon.png',
//               width: 200,
//             ),
//             const SizedBox(height: 16),
//             const Text(
//               'SecurePass',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 22,
//                 fontWeight: FontWeight.bold,
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});
//
//   @override
//   State<SplashScreen> createState() => _BootstrapScreenState();
// }
//
// class _BootstrapScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     _init();
//   }
//
//   Future<void> _init() async {
//     try {
//       final secureStorageDS = LoginPasscodeSecure();
//       final faceIdService = FaceIdAuthService();
//       final loginAuthRepo =
//       LoginAuthRepositoryImpl(secureStorageDS, faceIdService);
//
//       final hasPasscodeUseCase = HasPasscodeUseCase(loginAuthRepo);
//       final hasPasscode = await hasPasscodeUseCase();
//
//       if (!mounted) return;
//
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (_) =>
//           hasPasscode ? const LoginScreen() : const RegisterScreen(),
//         ),
//       );
//     } catch (e) {
//       debugPrint('Startup error: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Center(child: CircularProgressIndicator()),
//     );
//   }
// }
//
