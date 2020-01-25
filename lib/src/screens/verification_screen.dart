import 'package:flutter/material.dart';
import 'package:flutter_fundamental/src/widgets/widgets.dart';

class VerificationScreen extends StatefulWidget {
  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  List<String> _words = [];
  List<int> _keys = const [0, 4, 8];

  @override
  Widget build(BuildContext context) {
    final String mnemonic = ModalRoute.of(context).settings.arguments;

    print(mnemonic);
    
    /// if null argument or list<String>

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.0),
          child: Center(
            child: Column(
              children: <Widget>[
                Text('Verification', style: TextStyle(fontSize: 24.0)),
                SizedBox(height: 10.0),
                MnemonicVerificationTextField(
                    onChanged: (List<String> worldsList) {
//                  if (worldsList.length > _keys.length) return;

                  setState(() {
                    _words = worldsList;
                  });
                }),
                SizedBox(height: 10.0),
                Wrap(
                    spacing: 8.0,
                    children: _words.asMap().entries.map((entry) {
                      return Chip(
                        avatar: CircleAvatar(
                            backgroundColor: Colors.grey.shade800,
                            child: Text('${_keys[entry.key] + 1}')),
                        label: Text('${entry.value}'),
                      );
                    }).toList())
              ],
            ),
          ),
        ),
      ),
    );
  }
}
