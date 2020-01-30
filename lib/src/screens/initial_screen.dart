import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fundamental/src/blocs/mnemonic/bloc.dart';
import 'package:flutter_fundamental/src/blocs/tab/bloc.dart';
import 'package:flutter_fundamental/src/models/models.dart';
import 'package:flutter_fundamental/src/screens/screens.dart';
import 'package:flutter_fundamental/src/widgets/widgets.dart';

class InitialScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments;

    return BlocBuilder<TabBloc, AppTab>(
      builder: (context, activeTab) {
        return Scaffold(
          appBar: args is InitialArg ? AppBar(title: Text('Wallet')) : null,
          body: SafeArea(
            child: activeTab == AppTab.general
                ? BlocBuilder<MnemonicBloc, MnemonicState>(
                    builder: (context, state) {
                      if (state is MnemonicLoading) {
                        return LoadingIndicator();
                      } else if (state is MnemonicNotLoaded ||
                          state is MnemonicRemoved) {
                        return GeneralScreen();
                      } else if (state is MnemonicLoaded ||
                          state is MnemonicNotRemoved) {
                        if (args is InitialArg) {
                          return WalletScreen(mnemonic: args.mnemonic);
                        }

                        return ExistingScreen();
                      }

                      return null; // unreachable
                    },
                  )
                : GamesScreen(),
          ),
          bottomNavigationBar: TabSelector(
              activeTab: activeTab,
              onTabSelected: (tab) =>
                  BlocProvider.of<TabBloc>(context).add(UpdateTab(tab))),
        );
      },
    );
  }
}

class InitialArg {
  final String mnemonic;

  InitialArg(this.mnemonic);
}
