import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fundamental/src/blocs/mnemonic/bloc.dart';
import 'package:flutter_fundamental/src/blocs/tab/bloc.dart';
import 'package:flutter_fundamental/src/blocs/wallet/bloc.dart';
import 'package:flutter_fundamental/src/models/app_tab.dart';
import 'package:flutter_fundamental/src/widgets/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WalletScreen extends StatefulWidget {
  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletBloc, WalletState>(builder: (context, state) {
      if (state is WalletLoading) {
        return LoadingIndicator();
      } else if (state is WalletLoaded) {
        return _WalletScreen(currencies: state.currencies);
      } else if (state is WalletNotLoaded) {
        return Scaffold(body: Center(child: Text('No result.')));
      } else {
        return null;
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
          body: activeTab == AppTab.general ? _WalletTab(currencies) : Games(),
          bottomNavigationBar: TabSelector(
              activeTab: activeTab,
              onTabSelected: (tab) =>
                  BlocProvider.of<TabBloc>(context).add(UpdateTab(tab))));
    });
  }
}

class _WalletTab extends StatelessWidget {
  final List currencies;

  _WalletTab(this.currencies);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
            margin: EdgeInsets.all(8.0),
            child: Text('Currencies', style: TextStyle(fontSize: 24.0))),
        Expanded(
          child: ListView.separated(
              padding: EdgeInsets.all(8.0),
              itemBuilder: (context, index) => _Currency(currencies[index]),
              separatorBuilder: (context, index) => Divider(),
              itemCount: currencies.length),
        ),
      ],
    );
  }
}

class _Currency extends StatelessWidget {
  final item;

  _Currency(this.item);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(FontAwesomeIcons.coins),
      title: Text('${item.name.toUpperCase()}'),
      subtitle: Text('${item.getPublicKey()}'),
      isThreeLine: true,
      trailing: FutureBuilder(
        future: item.getAddress(),
        builder: (context, snapshot) {
          return Text('0.55');
        },
      ),
    );
  }
}
