import 'package:flutter/material.dart';
import 'package:flutter_fundamental/src/widgets/widgets.dart';

class VerificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<String> args = ModalRoute.of(context).settings.arguments;
    assert(args.length != null);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              children: <Widget>[
                Text('Verification', style: TextStyle(fontSize: 24.0)),
                Text(
                  '* Please type 1, 5, 12 words for verification',
                  style: TextStyle(color: Colors.red),
                ),
                Wrap(
                  spacing: 8.0,
                  children: <Widget>[
                    Text('1')
                  ],
                ),
                CustomButton(
                  child: Text('Verify'),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
