import 'package:bip39/bip39.dart' as bip39;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fundamental/src/blocs/mnemonic/bloc.dart';
import 'package:flutter_fundamental/src/widgets/widgets.dart';
import 'package:qr_flutter/qr_flutter.dart';

final TextStyle titleTextStyle =
    TextStyle(fontSize: 24.0, color: Colors.grey.shade300);
final TextStyle infoTextStyle =
    TextStyle(fontSize: 12.0, color: Colors.deepOrange);

class GenerationScreen extends StatelessWidget {
  static String genMnemonic() {
    return bip39.generateMnemonic();
  }

  @override
  Widget build(BuildContext context) {
    final String mnemonic = genMnemonic();
    final List<String> listMnemonic = mnemonic.split(' ');

    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
                padding: EdgeInsets.all(24.0),
                child: Center(
                  child: ListBody(children: <Widget>[
                    Text('Mnemonic has generated.', style: titleTextStyle),
                    SizedBox(height: 4.0),
                    Text('* Please save in your note', style: infoTextStyle),
                    SizedBox(height: 12.0),
                    Wrap(
                        spacing: 6.0,
                        children: listMnemonic.asMap().entries.map((entry) {
                          return CustomChip(
                              index: entry.key + 1, title: entry.value);
                        }).toList()),
                    Center(
                        child: QrImage(
                            data: mnemonic + ' bip39numus',
                            foregroundColor: Colors.grey.shade300,
                            size: MediaQuery.of(context).size.height / 2.6)),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          CustomButton(
                            child: Text('Verify'),
                            onPressed: () =>
                                BlocProvider.of<MnemonicBloc>(context)
                                    .add(VerifyOrRecoverMnemonic(mnemonic)),
                          )
                        ]),
                  ]),
                ))));
  }
}
