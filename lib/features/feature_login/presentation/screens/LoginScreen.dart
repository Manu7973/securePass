import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/routes/appRoutes.dart';
import '../../../feature_home/presentation/screens/HomeScreen.dart';
import '../bloc/login_bloc.dart';
import '../bloc/login_event.dart';
import '../bloc/login_state.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(
        getPasscode: context.read(),
        checkFaceId: context.read(),
        authenticateFaceId: context.read(),
      )..add(LoginStarted()),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatelessWidget {
  const _LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              behavior: SnackBarBehavior.floating,
              backgroundColor: CupertinoColors.systemRed,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        } else if (state is LoginSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Login Successful'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: CupertinoColors.activeGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );

          Future.microtask(() {
            Navigator.of(context).pushReplacementNamed(AppRoutes.home);
            // Navigator.of(context).pushReplacementNamed(AppRoutes.settings);
          });
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              // 🔐 Top static image
              SizedBox(
                height: size.height * 0.20, // keep box height as 20%
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Image.asset(
                    'assets/images/secure_login.png',
                    height: 120, // control the image size
                    width: 120, // optional: set width too
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // 🧾 Title
              const Text(
                'Enter Passcode',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),

              if(Platform.isIOS)
              const Text(
                'Use Face ID or enter your passcode',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 24),

              // 🔄 Dynamic content
              Expanded(
                child: BlocBuilder<LoginBloc, LoginState>(
                  builder: (context, state) {
                    if (state is LoginLoading) {
                      return const Center(child: CupertinoActivityIndicator());
                    }

                    if (state is LoginFaceId) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.face,
                            size: 64,
                            color: CupertinoColors.activeBlue,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Scanning Face ID',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      );
                    }

                    if (state is LoginPasscode || state is LoginFailure) {
                      return const _PasscodePad();
                    }

                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PasscodePad extends StatefulWidget {
  const _PasscodePad({super.key});

  @override
  State<_PasscodePad> createState() => _PasscodePadState();
}

class _PasscodePadState extends State<_PasscodePad> {
  String _enteredPasscode = '';

  void _onDigitPressed(String digit) {
    if (_enteredPasscode.length < 4) {
      setState(() => _enteredPasscode += digit);

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
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final buttonSize = size.width / 6.5;
    const rowSpacing = 16.0; // spacing between rows

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 24),

        // 🔵 Passcode dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(4, (index) {
            final filled = index < _enteredPasscode.length;
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              width: buttonSize / 3,
              height: buttonSize / 3,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: filled ? CupertinoColors.activeBlue : Colors.grey,
                  width: 2,
                ),
              ),
              child: filled
                  ? const Icon(
                      Icons.circle,
                      size: 14,
                      color: CupertinoColors.activeBlue,
                    )
                  : null,
            );
          }),
        ),

        const SizedBox(height: 32),

        // 🔢 PIN Pad with spacing between rows
        Column(
          children: [
            _buildPinRow(['1', '2', '3'], buttonSize),
            const SizedBox(height: rowSpacing),
            _buildPinRow(['4', '5', '6'], buttonSize),
            const SizedBox(height: rowSpacing),
            _buildPinRow(['7', '8', '9'], buttonSize),
            const SizedBox(height: rowSpacing),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(width: 60),
                _buildPinButton('0', buttonSize),
                _buildBackspaceButton(buttonSize),
              ],
            ),
          ],
        ),

        const SizedBox(height: 24),

        // 👤 Use Face ID button
        if(Platform.isIOS)
        TextButton.icon(
          onPressed: () {
            context.read<LoginBloc>().add(LoginStarted());
          },
          icon: const Icon(Icons.face, color: CupertinoColors.activeBlue),
          label: const Text(
            'Use Face ID',
            style: TextStyle(color: CupertinoColors.activeBlue),
          ),
        ),
      ],
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
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: CupertinoColors.systemGrey5,
        ),
        child: Text(
          digit,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
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
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: CupertinoColors.systemGrey5,
        ),
        child: const Icon(Icons.backspace, color: Colors.black54),
      ),
    );
  }
}
