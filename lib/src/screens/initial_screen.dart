import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fundamental/core/core.dart';
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
          body: SafeArea(
            child: activeTab == AppTab.general
                ? BlocBuilder<MnemonicBloc, MnemonicState>(
                    builder: (context, state) {
                      if (state is MnemonicLoading) {
                        return LoadingIndicator();
                      }
                      if (state is MnemonicNotLoaded) {
                        return General();
                      }
                      if (state is MnemonicLoaded) {
                        return Existing();
                      }
                      
                      // will be changed
                      if (state is MnemonicApproved) {
                        return Wallet();
                      }

                      return null; // unreachable
                    },
                  )
                : Games(),
          ),
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CustomButton(child: Text('Unlock'), onPressed: () {}),
          CustomButton(child: Text('Logout'), onPressed: () {}),
        ],
      ),
    );
  }
}

class General extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CustomButton(
              child: Text('Create New'),
              onPressed: () => Navigator.pushNamed(context, Routes.generation)),
          CustomButton(
              child: Text('Recover'),
              onPressed: () =>
                  Navigator.pushNamed(context, Routes.verificationOrRecover)),
        ],
      ),
    );
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
