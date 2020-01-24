import 'package:flutter/material.dart';
import 'package:flutter_fundamental/core/core.dart';
import 'package:flutter_fundamental/src/widgets/widgets.dart';

class GenerationScreen extends StatelessWidget {
  final String generateMnemonic =
      'limit boost flip evil regret shy alert always shine cabin unique angry';

  @override
  Widget build(BuildContext context) {
    final List<String> keyWords = generateMnemonic.split(' ');

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              children: <Widget>[
                Text('Geneation Mnemonic', style: TextStyle(fontSize: 24.0)),
                Text('* Please save in your not',
                    style: TextStyle(color: Colors.red)),
                Wrap(
                    spacing: 8.0,
                    children: keyWords.asMap().entries.map((entry) {
                      return Chip(
                          avatar: CircleAvatar(
                            backgroundColor: Colors.grey.shade800,
                            child: Text('${entry.key + 1}'),
                          ),
                          label: Text('${entry.value}'));
                    }).toList()),
                CustomButton(
                  child: Text('Confirm'),
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.verification,
                        arguments: keyWords);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
