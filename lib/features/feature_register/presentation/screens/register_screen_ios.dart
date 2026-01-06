import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/routes/appRoutes.dart';
import '../../domain/SavePasscodeUseCase.dart';
import '../bloc/register_bloc.dart';
import '../bloc/register_event.dart';
import '../bloc/register_state.dart';

// class RegisterScreen extends StatelessWidget {
//   const RegisterScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => RegisterBloc(context.read<SavePasscodeUseCase>()),
//       child: const _RegisterView(),
//     );
//   }
// }
//
// class _RegisterView extends StatefulWidget {
//   const _RegisterView();
//
//   @override
//   State<_RegisterView> createState() => _RegisterViewState();
// }
//
// class _RegisterViewState extends State<_RegisterView> {
//   void _onDigitPressed(String digit) {
//     context.read<RegisterBloc>().add(DigitEntered(digit));
//   }
//
//   void _onBackspacePressed() {
//     context.read<RegisterBloc>().add(DigitRemoved());
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final pinButtonSize = size.width / 8; // PIN button size
//     final circleSize = 20.0; // Passcode circle size
//
//     return BlocListener<RegisterBloc, RegisterState>(
//       listener: (context, state) {
//         if (state.error != null) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(
//                 state.error!,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               backgroundColor: Colors.redAccent,
//               behavior: SnackBarBehavior.floating,
//               margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               duration: const Duration(seconds: 3),
//             ),
//           );
//         }
//
//         if (state.success) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: const Text(
//                 "Passcode saved successfully",
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               backgroundColor: Colors.green,
//               behavior: SnackBarBehavior.floating,
//               margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               duration: const Duration(seconds: 2),
//             ),
//           );
//
//           // Navigate to HomeScreen
//           Future.delayed(const Duration(milliseconds: 500), () {
//             Navigator.of(context).pushReplacementNamed('/home');
//           });
//         }
//       },
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         body: LayoutBuilder(
//           builder: (context, constraints) {
//             return SingleChildScrollView(
//               physics: const ClampingScrollPhysics(),
//               child: ConstrainedBox(
//                 constraints: BoxConstraints(minHeight: constraints.maxHeight),
//                 child: IntrinsicHeight(
//                   child: Column(
//                     children: [
//                       // Top animation
//                       Padding(
//                         padding: const EdgeInsets.only(top: 20),
//                         child: SizedBox(
//                           height: size.height * 0.20,
//                           child: Align(
//                             alignment: Alignment.bottomCenter,
//                             child: Lottie.asset(repeat: false,
//                               'assets/animations/secure_vault.json',
//                               fit: BoxFit.contain,
//                             ),
//                           ),
//                         ),
//                       ),
//
//                       // Title + Passcode circles
//                       Flexible(
//                         flex: 2,
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             const Text(
//                               'Secure Your Vault',
//                               style: TextStyle(
//                                 fontSize: 23,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                             const SizedBox(height: 8),
//                             BlocBuilder<RegisterBloc, RegisterState>(
//                               builder: (context, state) {
//                                 return Text(
//                                   state.isConfirmStep
//                                       ? 'Re-enter passcode'
//                                       : 'Enter passcode',
//                                   style: const TextStyle(
//                                     fontSize: 15,
//                                     color: Colors.grey,
//                                   ),
//                                 );
//                               },
//                             ),
//                             const SizedBox(height: 24),
//                             BlocBuilder<RegisterBloc, RegisterState>(
//                               builder: (context, state) {
//                                 final digits = state.isConfirmStep
//                                     ? state.confirmDigits
//                                     : state.enteredDigits;
//                                 return Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: List.generate(4, (i) {
//                                     final filled = i < digits.length;
//                                     return Container(
//                                       margin: const EdgeInsets.symmetric(
//                                         horizontal: 8,
//                                       ),
//                                       width: circleSize,
//                                       height: circleSize,
//                                       decoration: BoxDecoration(
//                                         shape: BoxShape.circle,
//                                         border: Border.all(
//                                           color: filled
//                                               ? CupertinoColors.activeBlue
//                                               : Colors.grey,
//                                           width: 2,
//                                         ),
//                                       ),
//                                       child: filled
//                                           ? const Icon(
//                                               Icons.circle,
//                                               size: 12,
//                                               color: CupertinoColors.activeBlue,
//                                             )
//                                           : null,
//                                     );
//                                   }),
//                                 );
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//
//                       // Face ID toggle
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 24),
//                         child: BlocBuilder<RegisterBloc, RegisterState>(
//                           builder: (context, state) {
//                             if (!Platform.isIOS) {
//                               return const SizedBox();
//                             }
//
//                             return CupertinoListTile(
//                               title: const Text('Enable Face ID'),
//                               trailing: CupertinoSwitch(
//                                 value: state.faceIdEnabled,
//                                 activeColor: CupertinoColors.activeBlue,
//                                 onChanged: (val) => context
//                                     .read<RegisterBloc>()
//                                     .add(FaceIdToggled(val)),
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//
//                       // PIN pad
//                       Flexible(
//                         flex: 4,
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 24),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               _buildPinRow(['1', '2', '3'], pinButtonSize),
//                               _buildPinRow(['4', '5', '6'], pinButtonSize),
//                               _buildPinRow(['7', '8', '9'], pinButtonSize),
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceEvenly,
//                                 children: [
//                                   SizedBox(width: pinButtonSize),
//                                   _buildPinButton('0', pinButtonSize),
//                                   _buildBackspaceButton(pinButtonSize),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//
//                       // Continue button
//                       Padding(
//                         padding: EdgeInsets.only(
//                           left: 24,
//                           right: 24,
//                           top: 8,
//                           bottom: MediaQuery.of(context).padding.bottom + 8,
//                         ),
//                         child: BlocBuilder<RegisterBloc, RegisterState>(
//                           builder: (context, state) {
//                             return SizedBox(
//                               width: double.infinity,
//                               height: 50,
//                               child: CupertinoButton(
//                                 color: CupertinoColors.activeBlue,
//                                 disabledColor: CupertinoColors.systemGrey,
//                                 onPressed: state.canSubmit
//                                     ? () => context.read<RegisterBloc>().add(
//                                         RegisterSubmitted(),
//                                       )
//                                     : null,
//                                 child: const Text(
//                                   'Sign Up',
//                                   style: TextStyle(
//                                     color: CupertinoColors.white,
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPinRow(List<String> digits, double size) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: digits.map((d) => _buildPinButton(d, size)).toList(),
//     );
//   }
//
//   Widget _buildPinButton(String digit, double size) {
//     return GestureDetector(
//       onTap: () => _onDigitPressed(digit),
//       child: Container(
//         width: size,
//         height: size,
//         alignment: Alignment.center,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           color: CupertinoColors.systemGrey5, // ✅ PIN button color
//         ),
//         child: Text(
//           digit,
//           style: const TextStyle(
//             color: CupertinoColors.black,
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildBackspaceButton(double size) {
//     return GestureDetector(
//       onTap: _onBackspacePressed,
//       child: Container(
//         width: size,
//         height: size,
//         alignment: Alignment.center,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           color: Colors.grey.withOpacity(0.3),
//         ),
//         child: const Icon(Icons.backspace),
//       ),
//     );
//   }
// }



class RegisterScreeniOS extends StatelessWidget {
  const RegisterScreeniOS({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RegisterBloc(context.read<SavePasscodeUseCase>()),
      child: const _RegisterView(),
    );
  }
}

class _RegisterView extends StatefulWidget {
  const _RegisterView();

  @override
  State<_RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<_RegisterView> {
  void _onDigitPressed(String digit) {
    context.read<RegisterBloc>().add(DigitEntered(digit));
  }

  void _onBackspacePressed() {
    context.read<RegisterBloc>().add(DigitRemoved());
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final pinButtonSize = size.width / 6.8;

    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error!),
              behavior: SnackBarBehavior.floating,
              backgroundColor: CupertinoColors.systemRed,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          );
        }

        if (state.success) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F5F9),
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40),

              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: CupertinoColors.activeBlue.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.shield_rounded,
                  size: 42,
                  color: CupertinoColors.activeBlue,
                ),
              ),

              const SizedBox(height: 18),

              const Text(
                'Secure Your Vault',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
              ),

              const SizedBox(height: 6),

              BlocBuilder<RegisterBloc, RegisterState>(
                builder: (context, state) {
                  return Text(
                    state.isConfirmStep
                        ? 'Confirm your 4-digit passcode'
                        : 'Create a 4-digit passcode',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey.shade600,
                    ),
                  );
                },
              ),

              const SizedBox(height: 36),

              BlocBuilder<RegisterBloc, RegisterState>(
                builder: (context, state) {
                  final digits = state.isConfirmStep
                      ? state.confirmDigits
                      : state.enteredDigits;

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (i) {
                      final filled = i < digits.length;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: filled
                              ? CupertinoColors.activeBlue
                              : Colors.grey.shade400,
                        ),
                      );
                    }),
                  );
                },
              ),

              const SizedBox(height: 32),

              if (Platform.isIOS)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: BlocBuilder<RegisterBloc, RegisterState>(
                    builder: (context, state) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 16,
                              color: Colors.black.withOpacity(0.05),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.face,
                              color: CupertinoColors.activeBlue,
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                'Enable Face ID',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            CupertinoSwitch(
                              value: state.faceIdEnabled,
                              activeColor: CupertinoColors.activeBlue,
                              onChanged: (val) => context
                                  .read<RegisterBloc>()
                                  .add(FaceIdToggled(val)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

              const Spacer(),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  children: [
                    _pinRow(['1', '2', '3'], pinButtonSize),
                    const SizedBox(height: 18),
                    _pinRow(['4', '5', '6'], pinButtonSize),
                    const SizedBox(height: 18),
                    _pinRow(['7', '8', '9'], pinButtonSize),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const SizedBox(width: 60),
                        _pinButton('0', pinButtonSize),
                        _backspace(pinButtonSize),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 26),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: BlocBuilder<RegisterBloc, RegisterState>(
                  builder: (context, state) {
                    return SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: state.canSubmit
                            ? () => context
                            .read<RegisterBloc>()
                            .add(RegisterSubmitted())
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CupertinoColors.activeBlue,
                          disabledBackgroundColor:
                          CupertinoColors.systemGrey4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Create Vault',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pinRow(List<String> digits, double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: digits.map((d) => _pinButton(d, size)).toList(),
    );
  }

  Widget _pinButton(String digit, double size) {
    return GestureDetector(
      onTap: () => _onDigitPressed(digit),
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 18,
              offset: const Offset(0, 8),
              color: Colors.black.withOpacity(0.08),
            ),
          ],
        ),
        child: Text(
          digit,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _backspace(double size) {
    return GestureDetector(
      onTap: _onBackspacePressed,
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 18,
              offset: const Offset(0, 8),
              color: Colors.black.withOpacity(0.08),
            ),
          ],
        ),
        child: const Icon(Icons.backspace_rounded),
      ),
    );
  }
}
