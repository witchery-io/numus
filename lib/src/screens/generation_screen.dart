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
          padding: EdgeInsets.all(24.0),
          child: Center(
            child: Column(
              children: <Widget>[
                Text('Geneation Mnemonic', style: TextStyle(fontSize: 24.0)),
                SizedBox(height: 4.0),
                Text('* Please save in your not',
                    style: TextStyle(color: Colors.red)),
                SizedBox(height: 10.0),
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
                SizedBox(height: 10.0),
                CustomButton(
                  child: Text('Verify'),
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
