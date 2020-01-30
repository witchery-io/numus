import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fundamental/core/core.dart';
import 'package:flutter_fundamental/src/blocs/tab/bloc.dart';
import 'package:flutter_fundamental/src/screens/screens.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'blocs/mnemonic/bloc.dart';
import 'localization.dart';

class Application extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: FlutterBlocLocalizations().appTitle,
      theme: WalletTheme.theme,
      localizationsDelegates: [
        FlutterBlocLocalizationsDelegate(),
      ],
      initialRoute: Router.initial,
      onGenerateRoute: (settings) {
        final String type = settings.name;
        switch (type) {
          case "/verificationOrRecover":
            final VerificationOrRecoverArg args = settings.arguments;
            return MaterialPageRoute(
                builder: (_) => VerificationOrRecoverScreen(args.mnemonic));
        }

        return null;
      },
      routes: {
        Router.initial: (context) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<TabBloc>(create: (context) => TabBloc()),
              BlocProvider<MnemonicBloc>(
                  create: (_) =>
                      MnemonicBloc(secureStorage: const FlutterSecureStorage())
                        ..add(LoadMnemonic()))
            ],
            child: InitialScreen(),
          );
        },
        Router.generation: (context) => GenerationScreen(),
      },
    );
  }
}
