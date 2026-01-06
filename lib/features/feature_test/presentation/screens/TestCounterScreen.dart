import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/TestBloc.dart';
import '../bloc/TestState.dart';

class TestCounterScreen extends StatelessWidget {
  const TestCounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Counter")),
      body: Center(
        child: BlocBuilder<PasscodeBloc, PasscodeState>(
          builder: (context, state) {
            if(state is PasscodeLoading){
              return const CircularProgressIndicator();
            }

            if(state is PasscodeLoaded){
              return Text(
                state.passcode ?? "No passcode saved",
                style: const TextStyle(fontSize: 24),
              );
            }

            if(state is PasscodeError){
              return Text(state.message);
            }

            return const Text("Initializing...");

          },
        ),
      ),
    );
  }
}
