import 'package:flutter/material.dart';

class GenerationScreen extends StatelessWidget {
  final String generateMnemonic =
      'limit boost flip evil regret shy alert always shine cabin unique angry';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Geneation Mnemonic',
                style: TextStyle(fontSize: 24.0),
              ),
              Wrap(
                spacing: 4.0,
                children: generateMnemonic.split(' ').map((s) {
                  return Chip(
                    label: Text('$s'),
                    backgroundColor: Colors.indigoAccent,
                  );
                }).toList(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
