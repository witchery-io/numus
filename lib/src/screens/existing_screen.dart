import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:games.fair.wallet/src/blocs/mnemonic/bloc.dart';
import 'package:games.fair.wallet/src/providers/link_provider.dart';
import 'package:games.fair.wallet/src/utils/encrypt_helper.dart';
import 'package:games.fair.wallet/src/utils/utils.dart';
import 'package:games.fair.wallet/src/widgets/widgets.dart';

class ExistingScreen extends StatefulWidget {
  final base64Mnemonic;
  final LinkProvider linkProvider;

  const ExistingScreen(
      {@required this.base64Mnemonic, @required this.linkProvider});

  @override
  _ExistingScreenState createState() => _ExistingScreenState();
}

class _ExistingScreenState extends State<ExistingScreen> {
  StreamSubscription<String> linkSubscription;

  @override
  void initState() {
    initLinkStream();
    super.initState();
  }

  initLinkStream() async {
    linkSubscription = widget.linkProvider.linkStream.listen((strLink) {
      Message.show(context, 'After to unlock please try again');
    });
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
                      builder: (BuildContext bc) {
                        return PinAlertDialog(
                            title: 'Please enter your pin',
                            onConfirmed: _confirmed);
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

  void _confirmed(strPin) {
    try {
      final encrypt = EncryptHelper(pin: strPin);
      final mnemonic = encrypt.decryptByPinByBase64(widget.base64Mnemonic);
      Navigator.pop(context);
      BlocProvider.of<MnemonicBloc>(context)
          .add(AcceptMnemonic(mnemonic: mnemonic, mnemonicBase64: null));
    } catch (e) {
      Message.show(context, e.message);
    }
  }

  @override
  void dispose() {
    linkSubscription.cancel();
    super.dispose();
  }
}
