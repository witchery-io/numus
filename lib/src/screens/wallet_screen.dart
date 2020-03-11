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
import 'package:flutter_fundamental/src/providers/providers.dart';
import 'package:flutter_fundamental/src/utils/message.dart';
import 'package:flutter_fundamental/src/widgets/widgets.dart';

final TextStyle loadingStyle = TextStyle(fontSize: 12.0, color: Colors.grey);

class RenderWalletScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletBloc, WalletState>(builder: (context, state) {
      if (state is WalletLoading) {
        return LoadingIndicator(key: AppKeys.statsLoadingIndicator);
      } else if (state is WalletLoaded) {
        return WalletScreen(
            linkProvider: LinkProvider.of(context),
            currencies: state.currencies);
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
  final LinkProvider linkProvider;

  WalletScreen({@required this.linkProvider, @required this.currencies})
      : assert(currencies.isNotEmpty);

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen>
    with WidgetsBindingObserver {
  StreamSubscription<String> linkSubscription;

  @override
  void initState() {
    _initLinkStream();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  void _initLinkStream() async {
    linkSubscription = widget.linkProvider.linkStream.listen((strLink) {
      try {
        final link = Bip21.decode(strLink);
        _showInvoiceDialog(link.address, link.amount);
      } catch (e) {
        Message.show(context, e.message);
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached ||
        state == AppLifecycleState.inactive) {
      BlocProvider.of<MnemonicBloc>(context).add(LoadMnemonic());
    }
  }

  @override
  Widget build(BuildContext context) {
    final crs = widget.currencies;
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
              ? WalletTab(currencies: crs)
              : GameTab(
                  key: AppKeys.gameTab,
                  showInvoiceDialog: _showInvoiceDialog,
                  isAuth: true,
                  currencies: crs),
          bottomNavigationBar: TabSelector(
              activeTab: activeTab,
              onTabSelected: (tab) =>
                  BlocProvider.of<TabBloc>(context).add(UpdateTab(tab))));
    });
  }

  _showInvoiceDialog(String address, double price) async {
    final keyCoin = widget.currencies.first;
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
                        Navigator.of(context).pop();
                        Message.show(context, 'Your request is checking');
                        await keyCoin.transaction(address, price, keyCoin);
                        Message.show(context, 'Your request has accepted');
                      } catch (e) {
                        Message.show(context, e.message);
                      }
                    })
              ]);
        });
  }

  @override
  void dispose() {
    linkSubscription.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
