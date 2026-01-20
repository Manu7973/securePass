import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../features/feature_home/domain/PasswordStrength.dart';

class PasswordStrengthBar extends StatelessWidget {
  final PasswordStrength strength;

  const PasswordStrengthBar({super.key, required this.strength});

  int get level {
    switch (strength) {
      case PasswordStrength.weak:
        return 1;
      case PasswordStrength.medium:
        return 2;
      case PasswordStrength.strong:
        return 3;
      case PasswordStrength.veryStrong:
        return 4;
    }
  }

  Color _colorForIndex(int index) {
    if (index >= level) return Colors.grey.shade300;

    switch (strength) {
      case PasswordStrength.weak:
        return Colors.redAccent;
      case PasswordStrength.medium:
        return Colors.orangeAccent;
      case PasswordStrength.strong:
        return Colors.lightGreen;
      case PasswordStrength.veryStrong:
        return Colors.green;
    }
  }

  String get label {
    switch (strength) {
      case PasswordStrength.weak:
        return 'Weak';
      case PasswordStrength.medium:
        return 'Fair';
      case PasswordStrength.strong:
        return 'Strong';
      case PasswordStrength.veryStrong:
        return 'Very Strong';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(4, (index) {
            return Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 6,
                margin: EdgeInsets.only(right: index == 3 ? 0 : 6),
                decoration: BoxDecoration(
                  color: _colorForIndex(index),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: _colorForIndex(0),
          ),
        ),
      ],
    );
  }
}
