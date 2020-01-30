import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fundamental/src/blocs/mnemonic/bloc.dart';
import 'package:flutter_fundamental/src/widgets/widgets.dart';

class ExistingScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ///
          CustomButton(child: Text('Unlock'), onPressed: () {
            /// get pin screen
          }),
          CustomButton(child: Text('Logout'), onPressed: () {
            BlocProvider.of<MnemonicBloc>(context).add(RemoveMnemonic());
          }),
        ],
      ),
    );
  }


}