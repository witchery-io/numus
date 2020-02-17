import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fundamental/src/app_keys.dart';
import 'package:flutter_fundamental/src/blocs/mnemonic/bloc.dart';
import 'package:flutter_fundamental/src/blocs/tab/bloc.dart';
import 'package:flutter_fundamental/src/blocs/wallet/bloc.dart';
import 'package:flutter_fundamental/src/models/app_tab.dart';
import 'package:flutter_fundamental/src/models/models.dart';
import 'package:flutter_fundamental/src/widgets/widgets.dart';

final TextStyle loadingStyle = TextStyle(fontSize: 12.0, color: Colors.grey);

class RenderWalletScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletBloc, WalletState>(builder: (context, state) {
      if (state is WalletLoading) {
        return LoadingIndicator(key: AppKeys.statsLoadingIndicator);
      } else if (state is WalletLoaded) {
        return _WalletScreen(currencies: state.currencies);
      } else if (state is WalletNotLoaded) {
        return NoResult(key: AppKeys.noResultContainer);
      } else {
        return Container(key: AppKeys.emptyStatsContainer);
      }
    });
  }
}

class _WalletScreen extends StatelessWidget {
  final List currencies;

  _WalletScreen({@required this.currencies}) : assert(currencies.isNotEmpty);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TabBloc, AppTab>(builder: (context, activeTab) {
      return Scaffold(
          appBar: activeTab == AppTab.general
              ? AppBar(title: Text('Wallet'))
              : null,
          drawer: LeftMenu(onLogout: () {
            Navigator.pop(context);
            BlocProvider.of<MnemonicBloc>(context).add(RemoveMnemonic());
          }),
          body: activeTab == AppTab.general
              ? WalletTab(currencies: currencies)
              : GameTab(currencies: currencies),
          bottomNavigationBar: TabSelector(
              activeTab: activeTab,
              onTabSelected: (tab) =>
                  BlocProvider.of<TabBloc>(context).add(UpdateTab(tab))));
    });
  }
}
