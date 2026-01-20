import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/blocs/AppLockEvent.dart';
import '../../../../core/routes/appRoutes.dart';
import '../bloc/login_bloc.dart';
import '../bloc/login_event.dart';
import '../bloc/login_state.dart';

class LoginScreenAndroid extends StatelessWidget {
  const LoginScreenAndroid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(
        getPasscode: context.read(),
        checkFaceId: context.read(),
        authenticateFaceId: context.read(),
      )..add(LoginStarted()),
      child: const _LoginViewAndroid(),
    );
  }
}

class _LoginViewAndroid extends StatelessWidget {
  const _LoginViewAndroid({super.key});

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
              duration: const Duration(milliseconds: 1500),
              backgroundColor: Colors.red.shade600,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        } else if (state is LoginSuccess) {
          Future.microtask(() =>
              Navigator.of(context).pushReplacementNamed(AppRoutes.home));
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade50, // main background
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      const SizedBox(height: 40),

                      // 🔐 Top image
                      SizedBox(
                        height: size.height * 0.2,
                        child: Center(
                          child: Image.asset(
                            'assets/images/secure_login.png',
                            width: 120,
                            height: 120,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      const Text(
                        'Enter Passcode',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Enter your passcode to continue',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Passcode pad with card background
                      const _PasscodePadAndroid(),

                      const Spacer(),

                      // Optional Fingerprint login (if available)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 32),
                        child: TextButton.icon(
                          onPressed: () {
                            // Trigger fingerprint if supported
                          },
                          icon: const Icon(Icons.fingerprint,
                              color: Colors.blue),
                          label: const Text(
                            'Use Fingerprint',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            padding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 24),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
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

class _PasscodePadAndroidState extends State<_PasscodePadAndroid> {
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
        _enteredPasscode =
            _enteredPasscode.substring(0, _enteredPasscode.length - 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final buttonSize = width / 6;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // Passcode dots card
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              // color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                final filled = index < _enteredPasscode.length;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: filled ? Colors.blue : Colors.grey.shade400,
                  ),
                );
              }),
            ),
          ),

          const SizedBox(height: 32),

          // PIN pad
          Column(
            children: [
              _buildPinRow(['1', '2', '3'], buttonSize),
              const SizedBox(height: 16),
              _buildPinRow(['4', '5', '6'], buttonSize),
              const SizedBox(height: 16),
              _buildPinRow(['7', '8', '9'], buttonSize),
              const SizedBox(height: 16),
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
        ],
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
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 12,
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Text(
          digit,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
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
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 12,
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Icon(Icons.backspace, color: Colors.black87),
      ),
    );
  }
}
