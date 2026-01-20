// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../../core/routes/appRoutes.dart';
// import '../../../../core/widgits/AddPasswordDialog.dart';
// import '../../../../core/widgits/EditPasswordDialog.dart';
// import '../../../../core/widgits/EmptyVaultView.dart';
// import '../../../../core/widgits/PasswordCard.dart';
// import '../../domain/PasswordEntity.dart';
// import '../bloc/home_bloc.dart';
// import '../bloc/home_event.dart';
// import '../bloc/home_state.dart';
//
// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final passwordBloc = context.read<PasswordBloc>();
//     if (passwordBloc.state is PasswordInitial) {
//       passwordBloc.add(LoadPasswords());
//     }
//
//     return Scaffold(
//       backgroundColor: const Color(0xFFF6F7FB),
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.white,
//         title: const Text(
//           'Secure Vault',
//           style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.settings, color: Colors.black),
//             onPressed: () {
//               Navigator.of(context).pushNamed(AppRoutes.settings);
//             },
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         backgroundColor: CupertinoColors.activeBlue,
//         onPressed: () {
//           showModalBottomSheet(
//             context: context,
//             isScrollControlled: true,
//             backgroundColor: Colors.transparent,
//             builder: (_) => BlocProvider.value(
//               value: passwordBloc,
//               child: const AddPasswordDialog(),
//             ),
//           );
//         },
//         icon: const Icon(Icons.add, color: Colors.white),
//         label: const Text(
//           'Add Password',
//           style: TextStyle(color: Colors.white),
//         ),
//       ),
//       body: BlocBuilder<PasswordBloc, PasswordState>(
//         builder: (context, state) {
//           if (state is PasswordInitial || state is PasswordLoading) {
//             return const Center(
//               child: CircularProgressIndicator(
//                 color: CupertinoColors.activeBlue,
//               ),
//             );
//           }
//
//           if (state is PasswordEmpty) {
//             return EmptyVaultView();
//           }
//
//           if (state is PasswordLoaded) {
//             return ListView.separated(
//               padding: const EdgeInsets.all(16),
//               itemCount: state.passwords.length,
//               separatorBuilder: (_, _) => const SizedBox(height: 14),
//               itemBuilder: (context, index) {
//                 final item = state.passwords[index];
//
//                 return Dismissible(
//                   key: ValueKey(item.id ?? item.hashCode),
//                   direction: DismissDirection.horizontal,
//                   background: _editBackground(),
//                   secondaryBackground: _deleteBackground(),
//                   confirmDismiss: (direction) async {
//                     if (direction == DismissDirection.endToStart) {
//                       return await _confirmDelete(context);
//                     } else {
//                       _openEditDialog(context, item);
//                       return false;
//                     }
//                   },
//                   onDismissed: (_) {
//                     context.read<PasswordBloc>().add(DeletePassword(item.id!));
//                   },
//                   child: PasswordCard(item: item),
//                 );
//               },
//             );
//           }
//
//           return const SizedBox();
//         },
//       ),
//     );
//   }
//
//   Widget _deleteBackground() {
//     return Container(
//       alignment: Alignment.centerLeft,
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       decoration: BoxDecoration(
//         color: Colors.red.shade600,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: const Row(
//         children: [
//           Icon(Icons.delete, color: Colors.white),
//           SizedBox(width: 8),
//           Text(
//             'Delete',
//             style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Future<bool> _confirmDelete(BuildContext context) async {
//     return await showDialog<bool>(
//       context: context,
//       barrierDismissible: false,
//       builder: (_) => Dialog(
//         backgroundColor: Colors.grey.shade50,
//         surfaceTintColor: Colors.grey.shade50,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // Icon
//               Container(
//                 padding: const EdgeInsets.all(14),
//                 decoration: BoxDecoration(
//                   color: Colors.red.withOpacity(0.12),
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(
//                   Icons.delete_forever_rounded,
//                   color: Colors.red,
//                   size: 36,
//                 ),
//               ),
//
//               const SizedBox(height: 20),
//
//               // Title
//               const Text(
//                 'Delete Password',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//
//               const SizedBox(height: 12),
//
//               // Description
//               const Text(
//                 'Are you sure you want to delete this password? '
//                     'This action cannot be undone.',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Colors.grey,
//                   height: 1.4,
//                 ),
//               ),
//
//               const SizedBox(height: 28),
//
//               // Actions
//               Row(
//                 children: [
//                   Expanded(
//                     child: TextButton(
//                       onPressed: () => Navigator.pop(context, false),
//                       style: TextButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(14),
//                         ),
//                       ),
//                       child: const Text(
//                         'Cancel',
//                         style: TextStyle(
//                           fontWeight: FontWeight.w600,
//                           color: Colors.black54,
//                         ),
//                       ),
//                     ),
//                   ),
//
//                   const SizedBox(width: 12),
//
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: () => Navigator.pop(context, true),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.red,
//                         elevation: 0,
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(14),
//                         ),
//                       ),
//                       child: const Text(
//                         'Delete',
//                         style: TextStyle(
//                           fontWeight: FontWeight.w700,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     ) ??
//         false;
//   }
//
//   Widget _editBackground() {
//     return Container(
//       alignment: Alignment.centerRight,
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       decoration: BoxDecoration(
//         color: Colors.blue.shade600,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: const Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           Text(
//             'Edit',
//             style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
//           ),
//           SizedBox(width: 8),
//           Icon(Icons.edit, color: Colors.white),
//         ],
//       ),
//     );
//   }
//
//   void _openEditDialog(BuildContext context, PasswordEntity item) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (_) => BlocProvider.value(
//         value: context.read<PasswordBloc>(),
//         child: EditPasswordDialog(item: item),
//       ),
//     );
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/routes/appRoutes.dart';
import '../../../../core/widgits/AddPasswordDialog.dart';
import '../../../../core/widgits/DeleteDialog.dart';
import '../../../../core/widgits/EditPasswordDialog.dart';
import '../../../../core/widgits/EmptyVaultView.dart';
import '../../../../core/widgits/PasswordCard.dart';
import '../../domain/PasswordEntity.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static final ValueNotifier<bool> _showSearch = ValueNotifier(false);
  static final ScrollController _controller = ScrollController();

  static bool _locked = false;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<PasswordBloc>();

    if (bloc.state is PasswordInitial) {
      bloc.add(LoadPasswords());
    }

    _controller.addListener(() {
      final direction = _controller.position.userScrollDirection;

      if (_controller.offset <= 0 &&
          direction == ScrollDirection.forward &&
          !_locked) {
        _locked = true;
        _showSearch.value = true;
      }

      // 👇 Scroll up → hide search
      if (direction == ScrollDirection.reverse && _showSearch.value) {
        _showSearch.value = false;
        _locked = false;
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      floatingActionButton: _fab(context, bloc),
      body: CustomScrollView(
        controller: _controller,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [_appBar(context), _animatedSearch(context), _passwordList()],
      ),
    );
  }

  Widget _appBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
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
    );
  }

  // ---------------- SMOOTH SEARCH ----------------

  Widget _animatedSearch(BuildContext context) {
    return SliverToBoxAdapter(
      child: ValueListenableBuilder<bool>(
        valueListenable: _showSearch,
        builder: (_, visible, __) {
          return AnimatedSize(
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOutCubic,
            child: visible
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search by site name',
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (q) {
                        context.read<PasswordBloc>().add(SearchPasswords(q));
                      },
                    ),
                  )
                : const SizedBox(height: 0),
          );
        },
      ),
    );
  }

  Widget _passwordList() {
    return BlocBuilder<PasswordBloc, PasswordState>(
      builder: (context, state) {
        if (state is PasswordLoading || state is PasswordInitial) {
          return const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is PasswordEmpty) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: EmptyVaultView(),
          );
        }

        if (state is PasswordLoaded) {
          return SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
            sliver: SliverList.separated(
              itemCount: state.passwords.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final item = state.passwords[index];

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
                    context.read<PasswordBloc>().add(DeletePassword(item.id!));
                  },
                  child: PasswordCard(item: item),
                );
              },
            ),
          );
        }

        return const SliverToBoxAdapter();
      },
    );
  }

  FloatingActionButton _fab(BuildContext context, PasswordBloc bloc) {
    return FloatingActionButton.extended(
      backgroundColor: CupertinoColors.activeBlue,
      icon: const Icon(Icons.add, color: Colors.white),
      label: const Text('Add Password', style: TextStyle(color: Colors.white)),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) =>
              BlocProvider.value(value: bloc, child: const AddPasswordDialog()),
        );
      },
    );
  }

  Widget _deleteBackground() => Container(
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

  Widget _editBackground() => Container(
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
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        SizedBox(width: 8),
        Icon(Icons.edit, color: Colors.white),
      ],
    ),
  );

  Future<bool> _confirmDelete(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (_) => const DeleteDialog(),
        ) ??
        false;
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
