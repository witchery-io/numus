import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fundamental/src/blocs/mnemonic/bloc.dart';
import 'package:flutter_fundamental/src/widgets/pin_alert.dart';
import 'package:flutter_fundamental/src/widgets/widgets.dart';

class ExistingScreen extends StatelessWidget {
  final base64Mnemonic;

  ExistingScreen({@required this.base64Mnemonic});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CustomButton(
              child: Text('Unlock'), onPressed: () => _pinAlert(context)),
          CustomButton(
              child: Text('Logout'),
              onPressed: () {
                BlocProvider.of<MnemonicBloc>(context).add(RemoveMnemonic());
              }),
        ],
      ),
    );
  }

  Future<void> _pinAlert(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PinAlertDialog(PinAlertDialogArgs(null, base64Mnemonic));
      },
    );
  }
}
