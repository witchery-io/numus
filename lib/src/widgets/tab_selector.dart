import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:games.fair.wallet/src/models/app_tab.dart';

class TabSelector extends StatelessWidget {
  final AppTab activeTab;
  final Function(AppTab) onTabSelected;

  TabSelector({
    @required this.activeTab,
    @required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        currentIndex: AppTab.values.indexOf(activeTab),
        onTap: (index) => onTabSelected(AppTab.values[index]),
        items: AppTab.values.map((tab) {
          return BottomNavigationBarItem(
            icon: Icon(tab == AppTab.general
                ? Icons.account_balance_wallet
                : Icons.games),
            title: Text(tab == AppTab.general ? 'Wallet' : 'Games'),
          );
        }).toList());
  }
}
