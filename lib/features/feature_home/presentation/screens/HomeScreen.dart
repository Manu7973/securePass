import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/routes/appRoutes.dart';
import '../../../../core/widgits/AddPasswordDialog.dart';
import '../../../../core/widgits/EmptyVaultView.dart';
import '../../../../core/widgits/PasswordCard.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Trigger password loading on first build
    final passwordBloc = context.read<PasswordBloc>();
    if (passwordBloc.state is PasswordInitial) {
      passwordBloc.add(LoadPasswords());
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        elevation: 0,
      backgroundColor: Colors.white,
        title: const Text(
          'Secure Vault',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.settings);
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: CupertinoColors.activeBlue,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => BlocProvider.value(
              value: passwordBloc, // 👈 reuse the same bloc
              child: const AddPasswordDialog(),
            ),
          );
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Add Password',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: BlocBuilder<PasswordBloc, PasswordState>(
        builder: (context, state) {
          if (state is PasswordInitial || state is PasswordLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: CupertinoColors.activeBlue, // ✅ spinner color
              ),
            );
          }

          if (state is PasswordEmpty) {
            return  EmptyVaultView();
          }

          if (state is PasswordLoaded) {
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.passwords.length,
              separatorBuilder: (_, _) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final item = state.passwords[index];
                debugPrint('Passwords loaded: ${item.site}');
                return PasswordCard(item: item);
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}

