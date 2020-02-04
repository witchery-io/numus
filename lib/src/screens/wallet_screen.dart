import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fundamental/src/blocs/mnemonic/bloc.dart';
import 'package:flutter_fundamental/src/blocs/tab/bloc.dart';
import 'package:flutter_fundamental/src/models/app_tab.dart';
import 'package:flutter_fundamental/src/widgets/widgets.dart';

class WalletScreen extends StatelessWidget {
  final mnemonic;

  WalletScreen({@required this.mnemonic}) : assert(mnemonic != null);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TabBloc, AppTab>(builder: (context, activeTab) {
      return Scaffold(
          appBar: activeTab == AppTab.general
              ? AppBar(title: Text('Wallet'))
              : null,
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.deepOrange,
                  ),
                  child: Text(
                    'Account',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.delete_outline),
                  title: Text('Log out'),
                  onTap: () {
                    BlocProvider.of<MnemonicBloc>(context)
                        .add(RemoveMnemonic());
                  },
                ),
              ],
            ),
          ),
          body: activeTab == AppTab.general ? _WalletTab(mnemonic) : Games(),
          bottomNavigationBar: TabSelector(
              activeTab: activeTab,
              onTabSelected: (tab) =>
                  BlocProvider.of<TabBloc>(context).add(UpdateTab(tab))));
    });
  }
}

class _WalletTab extends StatelessWidget {
  final String mn;

  _WalletTab(this.mn);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(12.0),
      child: ListBody(
        children: <Widget>[
          Text('Wallet'),
          Text('$mn'),
          RaisedButton(
            onPressed: () {
            },
            child: Text('Example'),
          )
        ],
      ),
    );
  }
}
