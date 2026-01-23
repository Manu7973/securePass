import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum PasswordFilter { all, favorites }

class PasswordFilterDialog extends StatelessWidget {
  final PasswordFilter selected;
  final Function(PasswordFilter) onSelected;

  const PasswordFilterDialog({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 12,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Filter Passwords',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildOption(
                context,
                icon: Icons.list_alt_rounded,
                text: 'All',
                selected: selected == PasswordFilter.all,
                onTap: () => onSelected(PasswordFilter.all),
              ),
              const SizedBox(height: 12),
              _buildOption(
                context,
                icon: Icons.favorite_rounded,
                text: 'Favorites Only',
                selected: selected == PasswordFilter.favorites,
                iconColor: Colors.red,
                onTap: () => onSelected(PasswordFilter.favorites),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
    );
  }

  Widget _buildOption(
    BuildContext context, {
    required IconData icon,
    required String text,
    required bool selected,
    Color? iconColor, // affects only the icon
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          // selected box color stays blue
          color: selected ? Colors.blue.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? CupertinoColors.activeBlue : Colors.grey.shade300,
            width: 1.2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color:
                  iconColor ??
                  (selected ? CupertinoColors.activeBlue : Colors.grey),
            ),
            const SizedBox(width: 12),
            // Text stays same
            Text(
              text,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: selected ? CupertinoColors.activeBlue : Colors.black87,
              ),
            ),
            const Spacer(),
            if (selected)
              Icon(
                Icons.check_circle,
                color: CupertinoColors.activeBlue,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
