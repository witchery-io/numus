import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fundamental/src/blocs/mnemonic/bloc.dart';
import 'package:flutter_fundamental/src/blocs/tab/bloc.dart';
import 'package:flutter_fundamental/src/models/app_tab.dart';
import 'package:flutter_fundamental/src/widgets/widgets.dart';

class WalletScreen extends StatefulWidget {
  final mnemonic;

  WalletScreen({@required this.mnemonic}) : assert(mnemonic != null);

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TabBloc, AppTab>(builder: (context, activeTab) {
      return Scaffold(
          appBar: activeTab == AppTab.general
              ? AppBar(title: Text('Wallet'))
              : null,
          drawer: LeftMenu(
              onLogout: () =>
                  BlocProvider.of<MnemonicBloc>(context).add(RemoveMnemonic())),
          body: activeTab == AppTab.general ? _WalletTab() : Games(),
          bottomNavigationBar: TabSelector(
              activeTab: activeTab,
              onTabSelected: (tab) =>
                  BlocProvider.of<TabBloc>(context).add(UpdateTab(tab))));
    });
  }
}

class _WalletTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Container(
          margin: EdgeInsets.all(12.0),
          child: Text('Currencies', style: TextStyle(fontSize: 24.0))),
    ]);
  }
}
