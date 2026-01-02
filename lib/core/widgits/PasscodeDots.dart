import 'package:flutter/cupertino.dart';

class PasscodeDots extends StatelessWidget {
  final int filledCount;

  const PasscodeDots({super.key, required this.filledCount});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        4,
            (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index < filledCount
                ? CupertinoColors.activeBlue
                : CupertinoColors.systemGrey4,
          ),
        ),
      ),
    );
  }
}