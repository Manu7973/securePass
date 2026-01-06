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

class RegisterScreenAndroid extends StatelessWidget {
  const RegisterScreenAndroid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RegisterBloc(context.read<SavePasscodeUseCase>()),
      child: const _RegisterViewAndroid(),
    );
  }
}

class _RegisterViewAndroid extends StatefulWidget {
  const _RegisterViewAndroid();

  @override
  State<_RegisterViewAndroid> createState() => _RegisterViewAndroidState();
}

class _RegisterViewAndroidState extends State<_RegisterViewAndroid> {
  void _onDigitPressed(String digit) {
    context.read<RegisterBloc>().add(DigitEntered(digit));
  }

  void _onBackspacePressed() {
    context.read<RegisterBloc>().add(DigitRemoved());
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final pinButtonSize = size.width / 6.5;

    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error!),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.red.shade600,
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
        backgroundColor: Colors.grey.shade50,
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40),

              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lock_outline,
                  size: 42,
                  color: Colors.blue,
                ),
              ),

              const SizedBox(height: 18),

              const Text(
                'Secure Your Vault',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.3,
                ),
              ),

              const SizedBox(height: 6),

              BlocBuilder<RegisterBloc, RegisterState>(
                builder: (context, state) {
                  return Text(
                    state.isConfirmStep
                        ? 'Confirm your 4-digit PIN'
                        : 'Create a 4-digit PIN',
                    style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
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
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: filled ? Colors.blue : Colors.grey.shade400,
                          boxShadow: filled
                              ? [
                                  BoxShadow(
                                    color: Colors.blue.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : [],
                        ),
                      );
                    }),
                  );
                },
              ),

              const SizedBox(height: 32),

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
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 12,
                            color: Colors.black.withOpacity(0.05),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.fingerprint, color: Colors.blue),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Enable Fingerprint',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          SwitchTheme(
                            data: SwitchThemeData(
                              trackColor: MaterialStateProperty.resolveWith((
                                states,
                              ) {
                                if (states.contains(MaterialState.selected)) {
                                  return Colors.blue.withOpacity(0.5);
                                }
                                return Colors.white; // inactive track
                              }),
                              thumbColor: MaterialStateProperty.resolveWith((
                                states,
                              ) {
                                if (states.contains(MaterialState.selected)) {
                                  return Colors.blue;
                                }
                                return Colors.grey.shade400; // inactive circle
                              }),
                              trackOutlineColor:
                                  MaterialStateProperty.resolveWith((states) {
                                    if (states.contains(
                                      MaterialState.selected,
                                    )) {
                                      return Colors.blue;
                                    }
                                    return Colors
                                        .grey
                                        .shade400; // inactive border
                                  }),
                              trackOutlineWidth: MaterialStateProperty.all(1.5),
                            ),
                            child: Switch(
                              value: state.faceIdEnabled,
                              onChanged: (val) => context
                                  .read<RegisterBloc>()
                                  .add(FaceIdToggled(val)),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const Spacer(),

              /// 🔢 PIN PAD
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
                            ? () => context.read<RegisterBloc>().add(
                                RegisterSubmitted(),
                              )
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          disabledBackgroundColor: Colors.grey.shade400,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          elevation: 4,
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
    return InkWell(
      onTap: () => _onDigitPressed(digit),
      borderRadius: BorderRadius.circular(size / 2),
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
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _backspace(double size) {
    return InkWell(
      onTap: _onBackspacePressed,
      borderRadius: BorderRadius.circular(size / 2),
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
