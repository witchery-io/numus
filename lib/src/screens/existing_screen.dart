import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fundamental/src/blocs/mnemonic/bloc.dart';
import 'package:flutter_fundamental/src/widgets/widgets.dart';

class ExistingScreen extends StatelessWidget {
  final base64Mnemonic;

  const ExistingScreen({@required this.base64Mnemonic});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CustomButton(
              child: Text('Unlock'),
              onPressed: () async {
                showDialog<void>(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return PinAlertDialog(PinAlertDialogArgs(
                          title: 'Please set your pin.',
                          mnemonic: null,
                          base64Mnemonic: base64Mnemonic));
                    });
              }),
          CustomButton(
              child: Text('Logout'),
              onPressed: () {
                BlocProvider.of<MnemonicBloc>(context).add(RemoveMnemonic());
              }),
        ],
      ),
    );
  }
}
