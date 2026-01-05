import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/routes/appRoutes.dart';
import '../../../../core/widgits/AddPasswordDialog.dart';
import '../../../../core/widgits/EditPasswordDialog.dart';
import '../../../../core/widgits/EmptyVaultView.dart';
import '../../../../core/widgits/PasswordCard.dart';
import '../../domain/PasswordEntity.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.settings);
            },
          ),
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
              value: passwordBloc,
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
                color: CupertinoColors.activeBlue,
              ),
            );
          }

          if (state is PasswordEmpty) {
            return EmptyVaultView();
          }

          if (state is PasswordLoaded) {
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.passwords.length,
              separatorBuilder: (_, _) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final item = state.passwords[index];

                // return Dismissible(
                //   key: ValueKey(item.id),
                //   direction: DismissDirection.endToStart,
                //   background: _deleteBackground(),
                //   confirmDismiss: (_) => _confirmDelete(context),
                //   onDismissed: (_) {
                //     context.read<PasswordBloc>().add(DeletePassword(item.id!));
                //   },
                //   child: PasswordCard(item: item),
                // );

                return Dismissible(
                  key: ValueKey(item.id),
                  direction: DismissDirection.horizontal,
                  background: _editBackground(),
                  secondaryBackground: _deleteBackground(),
                  confirmDismiss: (direction) async {
                    if (direction == DismissDirection.endToStart) {
                      return await _confirmDelete(context);
                    } else {
                      _openEditDialog(context, item);
                      return false;
                    }
                  },
                  onDismissed: (_) {
                    context.read<PasswordBloc>().add(
                      DeletePassword(item.id!),
                    );
                  },
                  child: PasswordCard(item: item),
                );

              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _deleteBackground() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.red.shade600,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        children: [
          Icon(Icons.delete, color: Colors.white),
          SizedBox(width: 8),
          Text(
            'Delete',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Delete Password'),
            content: const Text(
              'Are you sure you want to delete this password?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel', style: TextStyle(color: Colors.black),),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  Widget _editBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.blue.shade600,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'Edit',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: 8),
          Icon(Icons.edit, color: Colors.white),
        ],
      ),
    );
  }

  void _openEditDialog(BuildContext context, PasswordEntity item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<PasswordBloc>(),
        child: EditPasswordDialog(item: item),
      ),
    );
  }

}
