import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'src/application.dart';
import 'src/blocs/app_bloc_delegate.dart';
import 'src/blocs/mnemonic/mnemonic_bloc.dart';
import 'src/blocs/mnemonic/mnemonic_event.dart';

void main() {
  BlocSupervisor.delegate = AppBlocDelegate();
  runApp(
    BlocProvider(
      create: (context) {
        return MnemonicBloc(
          secureStorage: const FlutterSecureStorage(),
        )..add(LoadMnemonic());
      },
      child: Application(),
    ),
  );
}
