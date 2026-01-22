import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/feature_home/domain/PasswordEntity.dart';
import '../../features/feature_home/domain/SiteCategoryClassifier.dart';
import '../../features/feature_home/presentation/bloc/home_bloc.dart';
import '../../features/feature_home/presentation/bloc/home_event.dart';

class EditPasswordDialog extends StatefulWidget {
  final PasswordEntity item;

  const EditPasswordDialog({
    super.key,
    required this.item,
  });

  @override
  State<EditPasswordDialog> createState() => _EditPasswordDialogState();
}

class _EditPasswordDialogState extends State<EditPasswordDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController siteCtrl;
  late final TextEditingController userCtrl;
  late final TextEditingController passCtrl;

  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    siteCtrl = TextEditingController(text: widget.item.site);
    userCtrl = TextEditingController(text: widget.item.username);
    passCtrl = TextEditingController(text: widget.item.password);
  }

  @override
  void dispose() {
    siteCtrl.dispose();
    userCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final detectedCategory =
    SiteCategoryClassifier.detect(siteCtrl.text.trim());

    context.read<PasswordBloc>().add(
      UpdatePassword(
        PasswordEntity(
          id: widget.item.id,
          site: siteCtrl.text.trim(),
          username: userCtrl.text.trim(),
          password: passCtrl.text.trim(), category: detectedCategory,
          isfav: false
        ),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔐 Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: CupertinoColors.activeBlue.withOpacity(.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.edit_outlined,
                      color: CupertinoColors.activeBlue,
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Text(
                    'Edit Password',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),
              Text(
                'Update your saved credentials',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),

              const SizedBox(height: 28),

              _buildField(
                controller: siteCtrl,
                label: 'Website / App',
                icon: Icons.public,
              ),

              const SizedBox(height: 18),

              _buildField(
                controller: userCtrl,
                label: 'Username',
                icon: Icons.person_outline,
              ),

              const SizedBox(height: 18),

              _buildField(
                controller: passCtrl,
                label: 'Password',
                icon: Icons.lock_outline,
                obscureText: _obscure,
                suffix: IconButton(
                  icon: Icon(
                    _obscure
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Colors.grey[600],
                  ),
                  onPressed: () {
                    setState(() => _obscure = !_obscure);
                  },
                ),
              ),

              const SizedBox(height: 32),

              /// 🎯 Actions
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CupertinoColors.activeBlue,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Save Changes',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    Widget? suffix,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      cursorColor: CupertinoColors.activeBlue,
      validator: (v) =>
      v == null || v.trim().isEmpty ? '$label is required' : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: CupertinoColors.activeBlue),
        suffixIcon: suffix,
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: CupertinoColors.activeBlue,
            width: 1.4,
          ),
        ),
      ),
    );
  }
}

