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
  StreamSubscription _deepLinkSub;

  @override
  void initState() {
    _deepLinkSub = getLinksStream().listen(onData, onError: (e) {
      Message.show(context, e.message);
    });
    super.initState();
  }

  onData(String link) {
    final decoded = Bip21.decode(link);
    print(decoded);
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
              : GameTab(key: AppKeys.gameTab, currencies: widget.currencies),
          bottomNavigationBar: TabSelector(
              activeTab: activeTab,
              onTabSelected: (tab) =>
                  BlocProvider.of<TabBloc>(context).add(UpdateTab(tab))));
    });
  }

  @override
  void dispose() {
    _deepLinkSub.cancel();
    super.dispose();
  }
}
