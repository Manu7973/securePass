import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/routes/appRoutes.dart';
import '../bloc/settings_bloc.dart';
import '../bloc/settings_event.dart';
import '../bloc/settings_state.dart';
import 'package:flutter/services.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsBloc, SettingsState>(
      listenWhen: (prev, curr) => prev.deleted == false && curr.deleted == true,
      listener: (context, state) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Data deleted successfully'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: CupertinoColors.activeGreen,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            duration: const Duration(seconds: 2),
          ),
        );
        Future.delayed(const Duration(milliseconds: 300), () {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.register,
                (route) => false,
          );
        });
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F7FB),
        appBar: AppBar(
          title: const Text(
            'Settings',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              return Column(
                children: [
                  _settingsCard(
                    children: [
                      _settingsTile(
                        title: 'Change Passcode',
                        onTap: () => _showChangePasscodeDialog(context),
                      ),
                      if (Platform.isIOS) ...[
                        _divider(),
                        _faceIdTile(context, state),
                      ],
                    ],
                  ),
                  const SizedBox(height: 16),
                  _settingsCard(
                    children: [
                      _settingsTile(
                        title: 'App Info',
                        onTap: () => _showAppInfoDialog(context),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  _appTourCard(
                    children: [
                      _settingsTile(
                        title: 'App Tour',
                        onTap: () => _appTourCardDialog(context),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  _settingsCard(
                    children: [
                      ListTile(
                        title: const Text(
                          'Delete All Data',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onTap: () => _showDeleteDialog(context),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _faceIdTile(BuildContext context, SettingsState state) {
    return SwitchListTile(
      title: const Text(
        'Face ID Unlock',
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
      value: state.faceIdEnabled,
      onChanged: (value) {
        context.read<SettingsBloc>().add(ToggleFaceIdEvent(value));
      },
      activeColor: CupertinoColors.activeBlue,
    );
  }

  Widget _settingsCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _appTourCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _settingsTile({required String title, VoidCallback? onTap}) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _divider() => const Divider(height: 1);

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete All Data'),
        content: const Text('This action cannot be undone. Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.grey[800])),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<SettingsBloc>().add(DeleteAllDataEvent());
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showAppInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F7FB),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.lock_outline_rounded,
                  size: 40,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'SecurePass',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              const Text(
                'SecurePass safely stores your passwords locally on your device. '
                    'All data remains offline and is protected using your passcode or Face ID.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.grey, height: 1.2),
              ),
              const SizedBox(height: 10),
              const Text(
                '🔒 Your data never leaves your device.',
                style: TextStyle(fontSize: 13, color: Colors.black54),
              ),
              const SizedBox(height: 20),
              const Divider(height: 1),
              const SizedBox(height: 12),
              const Text(
                'Version 1.0.0',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Close',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _appTourCardDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return Dialog(
          backgroundColor: Color(0xFFF1F0F6),
          insetPadding: const EdgeInsets.all(12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              // 🔍 Zoomable Image
              InteractiveViewer(
                minScale: 1.0,
                maxScale: 4.0,
                panEnabled: true,
                child: Center(
                  child: Image.asset(
                    'assets/images/app_tour.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              Positioned(
                top: 12,
                right: 12,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showChangePasscodeDialog(BuildContext parentContext) {
    final oldCtrl = TextEditingController();
    final newCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();

    bool obscureOld = true;
    bool obscureNew = true;
    bool obscureConfirm = true;

    showDialog(
      context: parentContext,
      barrierDismissible: false,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 20),
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
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
                          color: Colors.black.withOpacity(.08),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.lock_reset_rounded,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Text(
                        'Change Passcode',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),
                  Text(
                    'Update your app security',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),

                  const SizedBox(height: 28),

                  _passcodeField(
                    controller: oldCtrl,
                    label: 'Current Passcode',
                    obscure: obscureOld,
                    onToggle: () => setState(() => obscureOld = !obscureOld),
                  ),

                  const SizedBox(height: 18),

                  _passcodeField(
                    controller: newCtrl,
                    label: 'New Passcode',
                    obscure: obscureNew,
                    onToggle: () => setState(() => obscureNew = !obscureNew),
                  ),

                  const SizedBox(height: 18),

                  _passcodeField(
                    controller: confirmCtrl,
                    label: 'Confirm New Passcode',
                    obscure: obscureConfirm,
                    onToggle: () =>
                        setState(() => obscureConfirm = !obscureConfirm),
                  ),

                  const SizedBox(height: 32),

                  /// 🎯 Actions
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(parentContext),
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
                          onPressed: () {
                            final oldPass = oldCtrl.text.trim();
                            final newPass = newCtrl.text.trim();
                            final confirmPass = confirmCtrl.text.trim();

                            if (oldPass.isEmpty ||
                                newPass.isEmpty ||
                                confirmPass.isEmpty) {
                              _showError(
                                  parentContext, 'All fields are required');
                              return;
                            }

                            if (newPass.length < 4) {
                              _showError(parentContext,
                                  'Passcode must be 4 digits');
                              return;
                            }

                            final storedPasscode =
                                parentContext.read<SettingsBloc>().state.passcode;

                            if (oldPass != storedPasscode) {
                              _showError(parentContext,
                                  'Old passcode is incorrect');
                              return;
                            }

                            if (oldPass == newPass) {
                              _showError(parentContext,
                                  'New passcode must be different');
                              return;
                            }

                            if (newPass != confirmPass) {
                              _showError(
                                  parentContext, 'Passcodes do not match');
                              return;
                            }

                            parentContext
                                .read<SettingsBloc>()
                                .add(ChangePasscodeEvent(newPass));

                            Navigator.pop(parentContext);

                            ScaffoldMessenger.of(parentContext).showSnackBar(
                              SnackBar(
                                content: const Text(
                                    'Passcode updated successfully'),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor:
                                CupertinoColors.activeGreen,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            elevation: 0,
                            padding:
                            const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text(
                            'Update',
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
          );
        },
      ),
    );
  }

  Widget _passcodeField({
    required TextEditingController controller,
    required String label,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: TextInputType.number,
      maxLength: 4,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(4),
      ],
      decoration: InputDecoration(
        labelText: label,
        counterText: '',
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 16,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: Colors.grey[600],
          ),
          onPressed: onToggle,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Colors.black,
            width: 1.4,
          ),
        ),
      ),
    );
  }


  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red,
      ),
    );
  }
}

