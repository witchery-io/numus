import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fundamental/src/blocs/mnemonic/bloc.dart';
import 'package:flutter_fundamental/src/blocs/tab/bloc.dart';
import 'package:flutter_fundamental/src/models/models.dart';
import 'package:flutter_fundamental/src/widgets/widgets.dart';

class InitialScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TabBloc, AppTab>(
      builder: (context, activeTab) {
        return Scaffold(
          body: activeTab == AppTab.general
              ? BlocBuilder<MnemonicBloc, MnemonicState>(
                  builder: (context, state) {
                    if (state is MnemonicLoading) {
                      return CircularProgressIndicator();
                    }
                    if (state is MnemonicLoaded) {
                      return Existing();
                    }
                    if (state is MnemonicNotLoaded) {
                      return General();
                    }

                    return null; // unreachable
                  },
                )
              : Games(),
          bottomNavigationBar: TabSelector(
              activeTab: activeTab,
              onTabSelected: (tab) =>
                  BlocProvider.of<TabBloc>(context).add(UpdateTab(tab))),
        );
      },
    );
  }
}

class Existing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Existing'));
  }
}

class General extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('General'));
  }
}

class Games extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Games'));
  }
}

class Wallet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Wallet'));
  }
}
