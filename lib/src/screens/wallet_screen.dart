import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fundamental/src/blocs/mnemonic/bloc.dart';
import 'package:flutter_fundamental/src/blocs/tab/bloc.dart';
import 'package:flutter_fundamental/src/blocs/wallet/bloc.dart';
import 'package:flutter_fundamental/src/models/app_tab.dart';
import 'package:flutter_fundamental/src/widgets/widgets.dart';

class WalletScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletBloc, WalletState>(builder: (context, state) {
      if (state is WalletLoading) {
        return LoadingIndicator();
      } else if (state is WalletLoaded) {
        print(state.props);
        return BlocBuilder<TabBloc, AppTab>(builder: (context, activeTab) {
          return Scaffold(
              appBar: activeTab == AppTab.general
                  ? AppBar(title: Text('Wallet'))
                  : null,
              drawer: LeftMenu(
                  // todo has error on log out
                  onLogout: () => BlocProvider.of<MnemonicBloc>(context)
                      .add(RemoveMnemonic())),
              body: activeTab == AppTab.general ? _WalletTab() : Games(),
              bottomNavigationBar: TabSelector(
                  activeTab: activeTab,
                  onTabSelected: (tab) =>
                      BlocProvider.of<TabBloc>(context).add(UpdateTab(tab))));
        });
      } else {
        return null;
      }
    });
  }
}

class _WalletTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('Wallet Content');
  }
}
