import 'package:flutter/cupertino.dart';

import '../blocs/AppLockEvent.dart';

// class AppLifecycleObserver extends WidgetsBindingObserver {
//   final AppLockBloc appLockBloc;
//   DateTime? _pausedAt;
//
//   AppLifecycleObserver(this.appLockBloc);
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.paused) {
//       _pausedAt = DateTime.now();
//     }
//
//     if (state == AppLifecycleState.resumed &&
//         _pausedAt != null &&
//         DateTime.now().difference(_pausedAt!).inSeconds > 2) {
//       appLockBloc.add(LockApp());
//     }
//   }
// }
