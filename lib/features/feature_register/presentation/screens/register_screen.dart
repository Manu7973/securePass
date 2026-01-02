import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import '../../domain/SavePasscodeUseCase.dart';
import '../bloc/register_bloc.dart';
import '../bloc/register_event.dart';
import '../bloc/register_state.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

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
    final pinButtonSize = size.width / 8; // PIN button size
    final circleSize = 20.0; // Passcode circle size

    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.error!,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              duration: const Duration(seconds: 3),
            ),
          );
        }

        if (state.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                "Passcode saved successfully",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              duration: const Duration(seconds: 2),
            ),
          );

          // Navigate to HomeScreen
          Future.delayed(const Duration(milliseconds: 500), () {
            Navigator.of(context).pushReplacementNamed('/home');
          });
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      // Top animation
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: SizedBox(
                          height: size.height * 0.20,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Lottie.asset(repeat: false,
                              'assets/animations/secure_vault.json',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),

                      // Title + Passcode circles
                      Flexible(
                        flex: 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Secure Your Vault',
                              style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            BlocBuilder<RegisterBloc, RegisterState>(
                              builder: (context, state) {
                                return Text(
                                  state.isConfirmStep
                                      ? 'Re-enter passcode'
                                      : 'Enter passcode',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 24),
                            BlocBuilder<RegisterBloc, RegisterState>(
                              builder: (context, state) {
                                final digits = state.isConfirmStep
                                    ? state.confirmDigits
                                    : state.enteredDigits;
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(4, (i) {
                                    final filled = i < digits.length;
                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      width: circleSize,
                                      height: circleSize,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: filled
                                              ? CupertinoColors.activeBlue
                                              : Colors.grey,
                                          width: 2,
                                        ),
                                      ),
                                      child: filled
                                          ? const Icon(
                                              Icons.circle,
                                              size: 12,
                                              color: CupertinoColors.activeBlue,
                                            )
                                          : null,
                                    );
                                  }),
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      // Face ID toggle
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: BlocBuilder<RegisterBloc, RegisterState>(
                          builder: (context, state) {
                            if (!Platform.isIOS) {
                              return const SizedBox();
                            }

                            return CupertinoListTile(
                              title: const Text('Enable Face ID'),
                              trailing: CupertinoSwitch(
                                value: state.faceIdEnabled,
                                activeColor: CupertinoColors.activeBlue,
                                onChanged: (val) => context
                                    .read<RegisterBloc>()
                                    .add(FaceIdToggled(val)),
                              ),
                            );
                          },
                        ),
                      ),

                      // PIN pad
                      Flexible(
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildPinRow(['1', '2', '3'], pinButtonSize),
                              _buildPinRow(['4', '5', '6'], pinButtonSize),
                              _buildPinRow(['7', '8', '9'], pinButtonSize),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(width: pinButtonSize),
                                  _buildPinButton('0', pinButtonSize),
                                  _buildBackspaceButton(pinButtonSize),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Continue button
                      Padding(
                        padding: EdgeInsets.only(
                          left: 24,
                          right: 24,
                          top: 8,
                          bottom: MediaQuery.of(context).padding.bottom + 8,
                        ),
                        child: BlocBuilder<RegisterBloc, RegisterState>(
                          builder: (context, state) {
                            return SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: CupertinoButton(
                                color: CupertinoColors.activeBlue,
                                disabledColor: CupertinoColors.systemGrey4,
                                onPressed: state.canSubmit
                                    ? () => context.read<RegisterBloc>().add(
                                        RegisterSubmitted(),
                                      )
                                    : null,
                                child: const Text(
                                  'Continue',
                                  style: TextStyle(
                                    color: CupertinoColors.white,
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
          },
        ),
      ),
    );
  }

  Widget _buildPinRow(List<String> digits, double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: digits.map((d) => _buildPinButton(d, size)).toList(),
    );
  }

  Widget _buildPinButton(String digit, double size) {
    return GestureDetector(
      onTap: () => _onDigitPressed(digit),
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: CupertinoColors.systemGrey5, // ✅ PIN button color
        ),
        child: Text(
          digit,
          style: const TextStyle(
            color: CupertinoColors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildBackspaceButton(double size) {
    return GestureDetector(
      onTap: _onBackspacePressed,
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey.withOpacity(0.3),
        ),
        child: const Icon(Icons.backspace),
      ),
    );
  }
}
