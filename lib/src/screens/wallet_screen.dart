import 'dart:async';

import 'package:bip21/bip21.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fundamental/src/app_keys.dart';
import 'package:flutter_fundamental/src/blocs/mnemonic/bloc.dart';
import 'package:flutter_fundamental/src/blocs/tab/bloc.dart';
import 'package:flutter_fundamental/src/blocs/wallet/bloc.dart';
import 'package:flutter_fundamental/src/models/app_tab.dart';
import 'package:flutter_fundamental/src/models/models.dart';
import 'package:flutter_fundamental/src/utils/message.dart';
import 'package:flutter_fundamental/src/widgets/widgets.dart';
import 'package:uni_links/uni_links.dart';

final TextStyle loadingStyle = TextStyle(fontSize: 12.0, color: Colors.grey);

class RenderWalletScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletBloc, WalletState>(builder: (context, state) {
      if (state is WalletLoading) {
        return LoadingIndicator(key: AppKeys.statsLoadingIndicator);
      } else if (state is WalletLoaded) {
        return WalletScreen(currencies: state.currencies);
      } else if (state is WalletNotLoaded) {
        return NoResult(key: AppKeys.noResultContainer);
      } else {
        return Container(key: AppKeys.emptyStatsContainer);
      }
    });
  }
}

class WalletScreen extends StatefulWidget {
  final List currencies;

  WalletScreen({@required this.currencies}) : assert(currencies.isNotEmpty);

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  StreamSubscription _deepLinkSubscription;

  @override
  void initState() {
    initDeepLink();
    super.initState();
  }

  initDeepLink() {
    _deepLinkSubscription = getLinksStream().listen((String link) async {
      try {
        final decodeLink = Bip21.decode(link);
        await _onShowInvoice(decodeLink.address, decodeLink.amount);
      } catch (e) {
        Message.show(context, e.message);
      }
    }, onError: (e) {
      Message.show(context, e.message);
    });
  }

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
              ? WalletTab(currencies: widget.currencies)
              : GameTab(
                  key: AppKeys.gameTab,
                  showInvoiceDialog: _onShowInvoice,
                  isAuth: true,
                  currencies: widget.currencies),
          bottomNavigationBar: TabSelector(
              activeTab: activeTab,
              onTabSelected: (tab) =>
                  BlocProvider.of<TabBloc>(context).add(UpdateTab(tab))));
    });
  }

  Future<void> _onShowInvoice(String address, double price) async {
    await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Invoice'),
              content: SingleChildScrollView(
                child: ListBody(children: <Widget>[
                  Text('Sending ADDRESS $address and PRICE $price')
                ]),
              ),
              actions: <Widget>[
                FlatButton(
                    child: Text('Close'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                FlatButton(
                    child: Text('Accept'),
                    onPressed: () async {
                      try {
                        Message.show(context, 'Your request is checking');
                        final Coin btc = await widget.currencies.first;
                        await btc.transaction(address, price);
                        Message.show(context, 'Your request has accepted');
                        Navigator.of(context).pop();
                      } catch (e) {
                        Message.show(context, e.message);
                      }
                    })
              ]);
        });
  }

  @override
  void dispose() {
    _deepLinkSubscription.cancel();
    super.dispose();
  }
}
