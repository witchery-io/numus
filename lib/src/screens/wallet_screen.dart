import 'dart:async';

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
import 'package:screen_state/screen_state.dart';

final TextStyle loadingStyle = TextStyle(fontSize: 12.0, color: Colors.grey);

class RenderWalletScreen extends StatefulWidget {
  final ScreenProvider screenProvider;

  const RenderWalletScreen({@required this.screenProvider});

  @override
  _RenderWalletScreenState createState() => _RenderWalletScreenState();
}

class _RenderWalletScreenState extends State<RenderWalletScreen> {
  Stream screenStream;
  StreamSubscription<ScreenStateEvent> screenSubscription;

  @override
  void initState() {
    screenStream = widget.screenProvider.screenStream;
    screenSubscription = screenStream.listen((event) {
      if (event == ScreenStateEvent.SCREEN_OFF)
        BlocProvider.of<MnemonicBloc>(context).add(LoadMnemonic());
    });
    super.initState();
  }

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

  @override
  void dispose() {
    screenSubscription.cancel();
    super.dispose();
  }
}

class WalletScreen extends StatelessWidget {
  final List currencies;

  WalletScreen({@required this.currencies}) : assert(currencies.isNotEmpty);

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
              : GameTab(
                  key: AppKeys.gameTab,
                  showInvoiceDialog: (String address, double price) async {
                    await showDialog<void>(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                              title: Text('Invoice'),
                              content: SingleChildScrollView(
                                child: ListBody(children: <Widget>[
                                  Text(
                                      'Sending ADDRESS $address and PRICE $price')
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
                                        Message.show(context,
                                            'Your request is checking');
                                        final Coin btc = await currencies.first;
                                        await btc.transaction(address, price);
                                        Message.show(context,
                                            'Your request has accepted');
                                        Navigator.of(context).pop();
                                      } catch (e) {
                                        Message.show(context, e.message);
                                      }
                                    })
                              ]);
                        });
                  },
                  isAuth: true,
                  currencies: currencies),
          bottomNavigationBar: TabSelector(
              activeTab: activeTab,
              onTabSelected: (tab) =>
                  BlocProvider.of<TabBloc>(context).add(UpdateTab(tab))));
    });
  }
}
