import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fundamental/src/blocs/mnemonic/bloc.dart';
import 'package:flutter_fundamental/src/providers/link_provider.dart';
import 'package:flutter_fundamental/src/utils/encrypt_helper.dart';
import 'package:flutter_fundamental/src/utils/utils.dart';
import 'package:flutter_fundamental/src/widgets/widgets.dart';

class ExistingScreen extends StatefulWidget {
  final base64Mnemonic;
  final LinkProvider linkProvider;

  const ExistingScreen(
      {@required this.base64Mnemonic, @required this.linkProvider});

  @override
  _ExistingScreenState createState() => _ExistingScreenState();
}

class _ExistingScreenState extends State<ExistingScreen> {
  Stream linkStream;
  StreamSubscription<String> linkSubscription;

  @override
  void initState() {
    linkStream = widget.linkProvider.linkStream;
    linkSubscription = linkStream.listen((strLink) {
      Message.show(context, 'After to unlock please try again');
    });
    super.initState();
  }

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
                            title: 'Please type your pin',
                            onConfirmed: (strPin) {
                              try {
                                final encrypt = EncryptHelper(pin: strPin);
                                final mnemonic = encrypt.decryptByPinByBase64(
                                    widget.base64Mnemonic);
                                BlocProvider.of<MnemonicBloc>(context).add(
                                    AcceptMnemonic(
                                        mnemonic: mnemonic,
                                        mnemonicBase64: null));
                                Navigator.pop(context);
                              } catch (e) {
                                Message.show(cx, e.message);
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

  @override
  void dispose() {
    linkSubscription.cancel();
    super.dispose();
  }
}
