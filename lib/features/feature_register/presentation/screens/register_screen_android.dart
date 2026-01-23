import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    final width = MediaQuery.of(context).size.width;
    final pinButtonSize = width / 6.8;

    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error!),
              backgroundColor: Colors.red.shade600,
            ),
          );
        }

        if (state.success) {
          Navigator.pushReplacementNamed(context, AppRoutes.home);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        body: SafeArea(
          bottom: true,
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    const SizedBox(height: 32),

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

                    const SizedBox(height: 16),

                    const Text(
                      'Secure Your Vault',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    BlocBuilder<RegisterBloc, RegisterState>(
                      builder: (context, state) {
                        return Text(
                          state.isConfirmStep
                              ? 'Confirm your 4-digit PIN'
                              : 'Create a 4-digit PIN',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey.shade600,
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 30),

                    BlocBuilder<RegisterBloc, RegisterState>(
                      builder: (context, state) {
                        final digits = state.isConfirmStep
                            ? state.confirmDigits
                            : state.enteredDigits;

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(4, (i) {
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              width: 14,
                              height: 14,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: i < digits.length
                                    ? Colors.blue
                                    : Colors.grey.shade400,
                              ),
                            );
                          }),
                        );
                      },
                    ),

                    const SizedBox(height: 30),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22),
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
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Platform.isIOS
                                      ? Icons.face
                                      : Icons.fingerprint,
                                  color: Colors.blue,
                                ),
                                const SizedBox(width: 10),
                                const Expanded(
                                  child: Text(
                                    'Enable Fingerprint / Face Unlock',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Switch(
                                  value: state.faceIdEnabled,
                                  onChanged: (val) {
                                    context.read<RegisterBloc>().add(
                                      FaceIdToggled(val),
                                    );
                                  },
                                  activeColor: Colors.white,
                                  activeTrackColor: CupertinoColors.activeBlue,
                                  inactiveThumbColor: Colors.white,
                                  inactiveTrackColor: Colors.grey.shade300,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 24),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Column(
                        children: [
                          _pinRow(['1', '2', '3'], pinButtonSize),
                          const SizedBox(height: 16),
                          _pinRow(['4', '5', '6'], pinButtonSize),
                          const SizedBox(height: 16),
                          _pinRow(['7', '8', '9'], pinButtonSize),
                          const SizedBox(height: 16),
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
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
                child: BlocBuilder<RegisterBloc, RegisterState>(
                  builder: (context, state) {
                    return GestureDetector(
                      onTapDown: (_) => state.canSubmit ? null : null,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: state.canSubmit
                              ? const LinearGradient(
                                  colors: [
                                    Color(0xFF4A90E2),
                                    Color(0xFF357ABD),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : LinearGradient(
                                  colors: [
                                    Colors.grey.shade400,
                                    Colors.grey.shade500,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                          boxShadow: state.canSubmit
                              ? [
                                  BoxShadow(
                                    color: Colors.blue.shade300.withOpacity(
                                      0.4,
                                    ),
                                    blurRadius: 12,
                                    offset: const Offset(0, 6),
                                  ),
                                ]
                              : [],
                        ),
                        child: ElevatedButton(
                          onPressed: state.canSubmit
                              ? () => context.read<RegisterBloc>().add(
                                  RegisterSubmitted(),
                                )
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 300),
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: state.canSubmit
                                  ? Colors.white
                                  : Colors.grey.shade200,
                            ),
                            child: const Text('Create Vault'),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
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
