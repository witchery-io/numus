import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:games.fair.wallet/src/app_keys.dart';
import 'package:games.fair.wallet/src/blocs/mnemonic/bloc.dart';
import 'package:games.fair.wallet/src/blocs/tab/bloc.dart';
import 'package:games.fair.wallet/src/models/app_tab.dart';
import 'package:games.fair.wallet/src/providers/providers.dart';
import 'package:games.fair.wallet/src/utils/message.dart';
import 'package:games.fair.wallet/src/widgets/widgets.dart';

class GeneralScreen extends StatefulWidget {
  final LinkProvider linkProvider;

  const GeneralScreen({@required this.linkProvider});

  @override
  _GeneralScreenState createState() => _GeneralScreenState();
}

class _GeneralScreenState extends State<GeneralScreen> {
  StreamSubscription<String> linkSubscription;

  @override
  void initState() {
    initLinkStream();
    super.initState();
  }

  initLinkStream() async {
    linkSubscription = widget.linkProvider.linkStream.listen((strLink) {
      Message.show(context, 'Please create or recover');
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TabBloc, AppTab>(builder: (context, activeTab) {
      return Scaffold(
          body: activeTab == AppTab.general
              ? _GeneralTab()
              : GameTab(key: AppKeys.gameTab),
          bottomNavigationBar: TabSelector(
              activeTab: activeTab,
              onTabSelected: (tab) =>
                  BlocProvider.of<TabBloc>(context).add(UpdateTab(tab))));
    });
  }

  @override
  void dispose() {
    linkSubscription.cancel();
    super.dispose();
  }
}

class _GeneralTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
          CustomButton(
              child: Text('Create New'),
              onPressed: () =>
                  BlocProvider.of<MnemonicBloc>(context).add(NewMnemonic())),
          CustomButton(
              child: Text('Recover'),
              onPressed: () => BlocProvider.of<MnemonicBloc>(context)
                  .add(VerifyOrRecoverMnemonic(null))),
        ]));
  }
}
