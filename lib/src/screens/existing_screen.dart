import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fundamental/src/blocs/mnemonic/bloc.dart';
import 'package:flutter_fundamental/src/utils/encrypt_helper.dart';
import 'package:flutter_fundamental/src/widgets/widgets.dart';
import 'package:toast/toast.dart';

class ExistingScreen extends StatelessWidget {
  final base64Mnemonic;

  const ExistingScreen({@required this.base64Mnemonic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CustomButton(
                child: Text('Unlock'),
                onPressed: () async {
                  showDialog<void>(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext cx) {
                        return PinAlertDialog(
                            title: 'Please type your pin.',
                            onConfirmed: (strPin) {
                              try {
                                final encrypt = EncryptHelper(pin: strPin);
                                final mnemonic = encrypt
                                    .decryptByPinByBase64(base64Mnemonic);
                                BlocProvider.of<MnemonicBloc>(context).add(
                                    AcceptMnemonic(
                                        mnemonic: mnemonic,
                                        mnemonicBase64: null));
                                Navigator.pop(context);
                              } catch (e) {
                                Toast.show(e.message, cx,
                                    duration: 2, gravity: Toast.TOP);
                              }
                            });
                      });
                }),
            CustomButton(
                child: Text('Log out'),
                onPressed: () => BlocProvider.of<MnemonicBloc>(context)
                    .add(RemoveMnemonic())),
          ],
        ),
      ),
    );
  }
}
