import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fundamental/src/blocs/mnemonic/bloc.dart';
import 'package:flutter_fundamental/src/blocs/tab/bloc.dart';
import 'package:flutter_fundamental/src/models/app_tab.dart';
import 'package:flutter_fundamental/src/widgets/widgets.dart';
import 'package:multi_currency/multi_currency.dart';

class WalletScreen extends StatefulWidget {
  final mnemonic;

  WalletScreen({@required this.mnemonic}) : assert(mnemonic != null);

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  MultiCurrency mc;

  @override
  void initState() {
    mc = MultiCurrency(widget.mnemonic);
    super.initState();
  }

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
          body: activeTab == AppTab.general ? _WalletTab(mc: mc) : Games(),
          bottomNavigationBar: TabSelector(
              activeTab: activeTab,
              onTabSelected: (tab) =>
                  BlocProvider.of<TabBloc>(context).add(UpdateTab(tab))));
    });
  }
}

class _WalletTab extends StatelessWidget {
  final MultiCurrency mc;

  _WalletTab({@required this.mc});

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Container(
          margin: EdgeInsets.all(12.0),
          child: Text('Currencies', style: TextStyle(fontSize: 24.0))),
      Expanded(
          child: ListView.separated(
              itemCount: mc.getCurrencies.length,
              separatorBuilder: (context, index) =>
                  Divider(color: Colors.white),
              itemBuilder: (context, index) {
                final item = mc.getCurrencies[index];
                return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _Currency(item: item));
              }))
    ]);
  }
}

class _Currency extends StatelessWidget {
  final item;

  _Currency({@required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('${item.name.toUpperCase()}', style: TextStyle(fontSize: 22.0)),
          Text('Private Key: ${item.getPrivateKey()}'),
          Text('Public Key: ${item.getPublicKey()}'),
          FutureBuilder(
              future: item.getAddress(),
              builder: (context, snapshot) {
                return Text('${snapshot.data}');
              })
        ]);
  }
}
