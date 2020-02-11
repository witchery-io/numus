import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fundamental/src/blocs/mnemonic/bloc.dart';
import 'package:flutter_fundamental/src/blocs/tab/bloc.dart';
import 'package:flutter_fundamental/src/blocs/wallet/bloc.dart';
import 'package:flutter_fundamental/src/models/app_tab.dart';
import 'package:flutter_fundamental/src/models/models.dart';
import 'package:flutter_fundamental/src/widgets/widgets.dart';

final TextStyle loadingStyle = TextStyle(fontSize: 12.0, color: Colors.grey);

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
              separatorBuilder: (context, index) => Divider(),
              itemBuilder: (context, index) => _Currency(currencies[index]),
              itemCount: currencies.length),
        ),
      ],
    );
  }
}

class _Currency extends StatelessWidget {
  final Future<Coin> items;

  _Currency(this.items);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final Coin item = snapshot.data;
            return ListTile(
              leading: Icon(item.icon),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('${item.name.toUpperCase()}'),
                  _fBalance(item.fb),
                ],
              ),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CustomButton(child: Text('Send'), onPressed: () {}),
                  CustomButton(child: Text('Receive'), onPressed: () {}),
                  CustomButton(child: Text('Transactions'), onPressed: () {}),
                ],
              ),
            );
          }
          return _centerLoading();
        },
        future: items);
  }

  Widget _fBalance(Future<Balance> fb) {
    print(fb);

    return FutureBuilder(
      future: fb,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print('#1: ${snapshot.error}');
        }

        if (snapshot.hasData) {
          final Balance data = snapshot.data;
          return Text('${data.balance / 100000000}');
        } else if (snapshot.connectionState == ConnectionState.waiting)
          return _centerLoading();

        return Text('No Balance', style: loadingStyle);
      },
    );
  }

  Widget _centerLoading() {
    return Center(child: Text('Loading...', style: loadingStyle));
  }
}
