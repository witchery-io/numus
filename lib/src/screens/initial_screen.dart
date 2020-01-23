import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fundamental/src/blocs/mnemonic/bloc.dart';

class InitialScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocBuilder<MnemonicBloc, MnemonicState>(
          builder: (context, state) {
            if (state is MnemonicLoading) {
              return CircularProgressIndicator();
            }
            if (state is MnemonicLoaded) {
              print(state.mnemonic);
              return Text('Mnemonic Loaded');
            }
            if (state is MnemonicNotLoaded) {
              return Text('Mnemonic Not Loaded');
            }

            return null; // unreachable
          },
        ),
      ),
    );
  }
}
