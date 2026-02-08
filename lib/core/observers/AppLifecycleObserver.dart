import 'package:flutter/cupertino.dart';

import '../../main.dart';
import '../routes/appRoutes.dart';

class AppLifecycleGuard extends StatefulWidget {
  final Widget child;

  const AppLifecycleGuard({super.key, required this.child});

  @override
  State<AppLifecycleGuard> createState() => _AppLifecycleGuardState();
}

class _AppLifecycleGuardState extends State<AppLifecycleGuard>
    with WidgetsBindingObserver {

  bool _wasPaused = false;
  bool _firstResume = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _wasPaused = true;
      return;
    }

    if (state == AppLifecycleState.resumed) {
      if (_firstResume) {
        _firstResume = false;
        return;
      }

      if (!_wasPaused) return;

      _wasPaused = false;

      final currentRoute =
          ModalRoute.of(appNavigatorKey.currentContext!)?.settings.name;

      if (currentRoute == AppRoutes.login) return;
      appNavigatorKey.currentState?.pushNamedAndRemoveUntil(
        AppRoutes.login,
            (_) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
