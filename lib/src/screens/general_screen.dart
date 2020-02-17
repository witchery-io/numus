import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fundamental/src/blocs/mnemonic/bloc.dart';
import 'package:flutter_fundamental/src/blocs/tab/bloc.dart';
import 'package:flutter_fundamental/src/models/app_tab.dart';
import 'package:flutter_fundamental/src/widgets/widgets.dart';

class GeneralScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TabBloc, AppTab>(builder: (context, activeTab) {
      return Scaffold(
          body: activeTab == AppTab.general ? _GeneralTab() : GameWebView(),
          bottomNavigationBar: TabSelector(
              activeTab: activeTab,
              onTabSelected: (tab) =>
                  BlocProvider.of<TabBloc>(context).add(UpdateTab(tab))));
    });
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
