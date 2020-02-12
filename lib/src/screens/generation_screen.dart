import 'package:bip39/bip39.dart' as bip39;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fundamental/src/blocs/mnemonic/bloc.dart';
import 'package:flutter_fundamental/src/widgets/widgets.dart';

final TextStyle titleTextStyle =
    TextStyle(fontSize: 24.0, color: Colors.grey.shade300);
final TextStyle infoTextStyle =
    TextStyle(fontSize: 12.0, color: Colors.deepOrange);

class GenerationScreen extends StatelessWidget {
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
                          return Chip(
                              avatar: CircleAvatar(
                                  backgroundColor: Colors.grey.shade800,
                                  child: Text('${entry.key + 1}')),
                              label: Text('${entry.value}'));
                        }).toList()),
                    SizedBox(height: 12.0),
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

  static String genMnemonic() {
    return bip39.generateMnemonic();
  }
}
