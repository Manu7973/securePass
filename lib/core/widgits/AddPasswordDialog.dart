import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/feature_home/domain/PasswordEntity.dart';
import '../../features/feature_home/presentation/bloc/home_bloc.dart';
import '../../features/feature_home/presentation/bloc/home_event.dart';
//
// class AddPasswordDialog extends StatefulWidget {
//   const AddPasswordDialog({super.key});
//
//   @override
//   State<AddPasswordDialog> createState() => _AddPasswordDialogState();
// }
//
// class _AddPasswordDialogState extends State<AddPasswordDialog> {
//   final _formKey = GlobalKey<FormState>();
//
//   final siteCtrl = TextEditingController();
//   final userCtrl = TextEditingController();
//   final passCtrl = TextEditingController();
//
//   @override
//   void dispose() {
//     siteCtrl.dispose();
//     userCtrl.dispose();
//     passCtrl.dispose();
//     super.dispose();
//   }
//
//   void _save() {
//     if (!_formKey.currentState!.validate()) return;
//
//     context.read<PasswordBloc>().add(
//       AddPassword(
//         PasswordEntity(
//           id: null,
//           site: siteCtrl.text.trim(),
//           username: userCtrl.text.trim(),
//           password: passCtrl.text.trim(),
//         ),
//       ),
//     );
//
//     Navigator.pop(context);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       backgroundColor: Colors.white,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 'Add New Password',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.grey[800],
//                 ),
//               ),
//               const SizedBox(height: 22),
//               _buildTextField(siteCtrl, 'Site name', Icons.web),
//               const SizedBox(height: 16),
//               _buildTextField(userCtrl, 'Username', Icons.person),
//               const SizedBox(height: 16),
//               _buildTextField(
//                 passCtrl,
//                 'Password',
//                 Icons.lock,
//                 obscureText: true,
//               ),
//               const SizedBox(height: 24),
//               Row(
//                 children: [
//                   Expanded(
//                     child: OutlinedButton(
//                       onPressed: () => Navigator.pop(context),
//                       child: Text('Cancel', style: TextStyle(color: Colors.grey[800]),),
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: _save,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blueAccent,
//                       ),
//                       child: const Text(
//                         'Save',
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTextField(
//       TextEditingController controller,
//       String label,
//       IconData icon, {
//         bool obscureText = false,
//       }) {
//     return TextFormField(
//       controller: controller,
//       obscureText: obscureText,
//       cursorColor: Colors.blueAccent,
//       validator: (value) =>
//       value == null || value.trim().isEmpty ? '$label is required' : null,
//       decoration: InputDecoration(
//         labelText: label,
//         floatingLabelStyle:
//         const TextStyle(color: Colors.blueAccent),
//         prefixIcon: Icon(icon, color: Colors.blueAccent),
//         filled: true,
//         fillColor: Colors.grey.shade100,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide.none,
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide:
//           const BorderSide(color: Colors.blueAccent, width: 1.5),
//         ),
//       ),
//     );
//   }
// }
//
//


class AddPasswordDialog extends StatefulWidget {
  const AddPasswordDialog({super.key});

  @override
  State<AddPasswordDialog> createState() => _AddPasswordDialogState();
}

class _AddPasswordDialogState extends State<AddPasswordDialog> {
  final _formKey = GlobalKey<FormState>();

  final siteCtrl = TextEditingController();
  final userCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  void dispose() {
    siteCtrl.dispose();
    userCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    context.read<PasswordBloc>().add(
      AddPassword(
        PasswordEntity(
          id: null,
          site: siteCtrl.text.trim(),
          username: userCtrl.text.trim(),
          password: passCtrl.text.trim(),
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
                      color: Colors.blueAccent.withOpacity(.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.lock_outline,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Text(
                    'Add Password',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),
              Text(
                'Securely store your login details',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),

              const SizedBox(height: 28),

              /// 🔗 Site
              _buildTextField(
                controller: siteCtrl,
                label: 'Website / App',
                icon: Icons.public,
              ),

              const SizedBox(height: 18),

              /// 👤 Username
              _buildTextField(
                controller: userCtrl,
                label: 'Username',
                icon: Icons.person_outline,
              ),

              const SizedBox(height: 18),

              /// 🔑 Password
              _buildTextField(
                controller: passCtrl,
                label: 'Password',
                icon: Icons.lock_outline,
                obscureText: true,
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
                        backgroundColor: Colors.blueAccent,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Save',
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

  /// ✨ Modern input field
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: (v) =>
      v == null || v.trim().isEmpty ? '$label is required' : null,
      cursorColor: Colors.blueAccent,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blueAccent),
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
          borderSide:
          const BorderSide(color: Colors.blueAccent, width: 1.5),
        ),
      ),
    );
  }
}

