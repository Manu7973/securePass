// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../../core/routes/appRoutes.dart';
// import '../bloc/login_bloc.dart';
// import '../bloc/login_event.dart';
// import '../bloc/login_state.dart';
//
// class LoginScreenAndroid extends StatelessWidget {
//   const LoginScreenAndroid({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final isSmallHeight = size.height < 700;
//
//     return BlocListener<LoginBloc, LoginState>(
//       listener: (context, state) {
//         if (state is LoginFailure) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(state.error),
//               behavior: SnackBarBehavior.floating,
//               backgroundColor: Colors.red.shade600,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//           );
//         } else if (state is LoginSuccess) {
//           Navigator.pushReplacementNamed(context, AppRoutes.home);
//         }
//       },
//       child: Scaffold(
//         backgroundColor: Colors.grey.shade100,
//         body: SafeArea(
//           child: Column(
//             children: [
//               SizedBox(height: isSmallHeight ? 24 : 40),
//
//               SizedBox(
//                 height: size.height * 0.16,
//                 child: Image.asset(
//                   'assets/images/secure_login.png',
//                   width: 90,
//                   height: 90,
//                   fit: BoxFit.contain,
//                 ),
//               ),
//
//               const SizedBox(height: 12),
//
//               const Text(
//                 'Enter Passcode',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               const SizedBox(height: 6),
//               const Text(
//                 'Enter your passcode to continue',
//                 style: TextStyle(fontSize: 15, color: Colors.grey),
//               ),
//
//               const SizedBox(height: 24),
//
//               // 🔢 Passcode Pad
//               const Expanded(
//                 child: _PasscodePadAndroid(),
//               ),
//
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 24),
//                 child: TextButton.icon(
//                   onPressed: () {
//                     context.read<LoginBloc>().add(
//                       LoginStarted(fromButton: true),
//                     );
//                   },
//                   icon: const Icon(Icons.fingerprint, color: Colors.blue),
//                   label: const Text(
//                     'Use Fingerprint',
//                     style: TextStyle(
//                       color: Colors.blue,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   style: TextButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(
//                       vertical: 14,
//                       horizontal: 24,
//                     ),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(18),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//
// class _PasscodePadAndroid extends StatefulWidget {
//   const _PasscodePadAndroid({super.key});
//
//   @override
//   State<_PasscodePadAndroid> createState() => _PasscodePadAndroidState();
// }
//
// class _PasscodePadAndroidState extends State<_PasscodePadAndroid> {
//   String _enteredPasscode = '';
//
//   void _onDigitPressed(String digit) {
//     if (_enteredPasscode.length < 4) {
//       setState(() => _enteredPasscode += digit);
//       if (_enteredPasscode.length == 4) {
//         context.read<LoginBloc>().add(PasscodeEntered(_enteredPasscode));
//         setState(() => _enteredPasscode = '');
//       }
//     }
//   }
//
//   void _onBackspacePressed() {
//     if (_enteredPasscode.isNotEmpty) {
//       setState(() {
//         _enteredPasscode =
//             _enteredPasscode.substring(0, _enteredPasscode.length - 1);
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final buttonSize = size.width / 5.8;
//
//     return Column(
//       children: [
//         const SizedBox(height: 12),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: List.generate(4, (index) {
//             final filled = index < _enteredPasscode.length;
//             return AnimatedContainer(
//               duration: const Duration(milliseconds: 150),
//               margin: const EdgeInsets.symmetric(horizontal: 10),
//               width: 14,
//               height: 14,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: filled ? Colors.blue : Colors.grey.shade400,
//               ),
//             );
//           }),
//         ),
//
//         const SizedBox(height: 32),
//
//         Column(
//           children: [
//             _row(['1', '2', '3'], buttonSize),
//             const SizedBox(height: 14),
//             _row(['4', '5', '6'], buttonSize),
//             const SizedBox(height: 14),
//             _row(['7', '8', '9'], buttonSize),
//             const SizedBox(height: 14),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 const SizedBox(width: 60),
//                 _button('0', buttonSize),
//                 _backspace(buttonSize),
//               ],
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget _row(List<String> digits, double size) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: digits.map((d) => _button(d, size)).toList(),
//     );
//   }
//
//   Widget _button(String digit, double size) {
//     return InkWell(
//       borderRadius: BorderRadius.circular(size / 2),
//       onTap: () => _onDigitPressed(digit),
//       child: Container(
//         width: size,
//         height: size,
//         alignment: Alignment.center,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           shape: BoxShape.circle,
//           boxShadow: [
//             BoxShadow(
//               blurRadius: 14,
//               offset: const Offset(0, 6),
//               color: Colors.black.withOpacity(0.08),
//             ),
//           ],
//         ),
//         child: Text(
//           digit,
//           style: const TextStyle(
//             fontSize: 22,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _backspace(double size) {
//     return InkWell(
//       borderRadius: BorderRadius.circular(size / 2),
//       onTap: _onBackspacePressed,
//       child: Container(
//         width: size,
//         height: size,
//         alignment: Alignment.center,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           shape: BoxShape.circle,
//           boxShadow: [
//             BoxShadow(
//               blurRadius: 14,
//               offset: const Offset(0, 6),
//               color: Colors.black.withOpacity(0.08),
//             ),
//           ],
//         ),
//         child: const Icon(Icons.backspace_rounded),
//       ),
//     );
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/routes/appRoutes.dart';
import '../bloc/login_bloc.dart';
import '../bloc/login_event.dart';
import '../bloc/login_state.dart';

class LoginScreenAndroid extends StatelessWidget {
  const LoginScreenAndroid({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallHeight = size.height < 700;

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.red.shade600,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        } else if (state is LoginSuccess) {
          Navigator.pushReplacementNamed(context, AppRoutes.home);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(height: isSmallHeight ? 24 : 40),

              // Image
              SizedBox(
                height: size.height * 0.16,
                child: Image.asset(
                  'assets/images/secure_login.png',
                  width: 90,
                  height: 90,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 12),

              // Header
              const Text(
                'Enter Passcode',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Enter your passcode to continue',
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ),
              const SizedBox(height: 24),

              // Passcode pad
              const Expanded(child: _PasscodePadAndroid()),

              // Fingerprint Button
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: TextButton.icon(
                  onPressed: () {
                    context.read<LoginBloc>().add(
                      LoginStarted(fromButton: true),
                    );
                  },
                  icon: const Icon(
                    Icons.fingerprint,
                    color: CupertinoColors.activeBlue,
                  ),
                  label: const Text(
                    'Use Fingerprint',
                    style: TextStyle(
                      color: CupertinoColors.activeBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 24,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                      side: BorderSide(
                        color: CupertinoColors.activeBlue.withOpacity(0.5),
                      ),
                    ),
                    backgroundColor: CupertinoColors.white.withOpacity(0.1),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PasscodePadAndroid extends StatefulWidget {
  const _PasscodePadAndroid({super.key});

  @override
  State<_PasscodePadAndroid> createState() => _PasscodePadAndroidState();
}

class _PasscodePadAndroidState extends State<_PasscodePadAndroid>
    with SingleTickerProviderStateMixin {
  String _enteredPasscode = '';
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  void _onDigitPressed(String digit) {
    if (_enteredPasscode.length < 4) {
      setState(() => _enteredPasscode += digit);
      _controller.forward(from: 0);
      if (_enteredPasscode.length == 4) {
        context.read<LoginBloc>().add(PasscodeEntered(_enteredPasscode));
        setState(() => _enteredPasscode = '');
      }
    }
  }

  void _onBackspacePressed() {
    if (_enteredPasscode.isNotEmpty) {
      setState(() {
        _enteredPasscode = _enteredPasscode.substring(
          0,
          _enteredPasscode.length - 1,
        );
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final buttonSize = size.width / 5.8;

    return Column(
      children: [
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(4, (index) {
            final filled = index < _enteredPasscode.length;
            return ScaleTransition(
              scale: filled
                  ? Tween<double>(begin: 0.7, end: 1.0).animate(
                      CurvedAnimation(
                        parent: _controller,
                        curve: Curves.elasticOut,
                      ),
                    )
                  : const AlwaysStoppedAnimation(1.0),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                margin: const EdgeInsets.symmetric(horizontal: 10),
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: filled
                      ? CupertinoColors.activeBlue
                      : Colors.grey.shade400,
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 32),

        // Number Pad
        Column(
          children: [
            _row(['1', '2', '3'], buttonSize),
            const SizedBox(height: 14),
            _row(['4', '5', '6'], buttonSize),
            const SizedBox(height: 14),
            _row(['7', '8', '9'], buttonSize),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(width: 60),
                _button('0', buttonSize),
                _backspace(buttonSize),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _row(List<String> digits, double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: digits.map((d) => _button(d, size)).toList(),
    );
  }

  Widget _button(String digit, double size) {
    return GestureDetector(
      onTap: () => _onDigitPressed(digit),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              blurRadius: 12,
              offset: const Offset(0, 6),
              color: Colors.black.withOpacity(0.08),
            ),
          ],
        ),
        child: Text(
          digit,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.black87, // Original color
          ),
        ),
      ),
    );
  }

  Widget _backspace(double size) {
    return GestureDetector(
      onTap: _onBackspacePressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              blurRadius: 12,
              offset: const Offset(0, 6),
              color: Colors.black.withOpacity(0.08),
            ),
          ],
        ),
        child: const Icon(
          Icons.backspace_rounded,
          color: Colors.black87, // Original color
        ),
      ),
    );
  }
}
