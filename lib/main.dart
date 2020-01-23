import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'src/application.dart';
import 'src/blocs/app_bloc_delegate.dart';

void main() {
  BlocSupervisor.delegate = AppBlocDelegate();
  runApp(Application());
}
