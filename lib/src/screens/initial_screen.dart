import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fundamental/core/core.dart';
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
        /// should be changed
        final isWallet = args is InitialArgs && activeTab == AppTab.general;

        return Scaffold(
          appBar: isWallet
              ? AppBar(title: Text('Wallet'), centerTitle: true)
              : null,
          drawer: isWallet
              ? Drawer(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      DrawerHeader(
                        child: Text('Account#',
                            style:
                                TextStyle(color: Colors.white, fontSize: 24)),
                      ),
                      ListTile(
                        leading: Icon(Icons.delete_outline),
                        title: Text('Log out'),
                        onTap: () {
                          Navigator.pushNamedAndRemoveUntil(
                              context, Router.initial, (_) => false);
                        },
                      ),
                    ],
                  ),
                )
              : null,
          body: SafeArea(
            child: activeTab == AppTab.general
                ? BlocBuilder<MnemonicBloc, MnemonicState>(
                    builder: (context, state) {
                      if (state is MnemonicLoading) {
                        return LoadingIndicator();
                      } else if (state is MnemonicNotLoaded ||
                          state is MnemonicRemoved ||
                          state is MnemonicNotRemoved) {
                        return GeneralScreen();
                      } else if (state is MnemonicLoaded) {
                        if (args is InitialArgs) {
                          return WalletScreen(mnemonic: args.mnemonic);
                        }

                        return ExistingScreen(base64Mnemonic: state.mnemonic);
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

class InitialArgs {
  final String mnemonic;

  InitialArgs(this.mnemonic);
}
