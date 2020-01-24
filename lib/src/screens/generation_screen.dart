import 'package:flutter/material.dart';

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
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Geneation Mnemonic',
                  style: TextStyle(fontSize: 24.0),
                ),
                Text('Pleas save in your not'),
                Wrap(
                    spacing: 8.0,
                    children: keyWords.asMap().entries.map((entry) {
                      return Chip(
                        avatar: CircleAvatar(
                          backgroundColor: Colors.grey.shade800,
                          child: Text('${entry.key + 1}'),
                        ),
                        label: Text('${entry.value}'),
                      );
                    }).toList()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
