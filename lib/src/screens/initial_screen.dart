import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fundamental/src/blocs/mnemonic/bloc.dart';
import 'package:flutter_fundamental/src/screens/screens.dart';
import 'package:flutter_fundamental/src/widgets/widgets.dart';

class InitialScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MnemonicBloc, MnemonicState>(builder: (context, state) {
      if (state is MnemonicLoading) {
        return LoadingIndicator();
      } else if (state is MnemonicNotLoaded || state is MnemonicRemoved) {
        return GeneralScreen();
      } else if (state is MnemonicLoaded) {
        return ExistingScreen(base64Mnemonic: state.mnemonic);
      } else {
        return null; // unknown screen
      }
    });
  }
}

class InitialArgs {
  final String mnemonic;

  InitialArgs(this.mnemonic);
}
