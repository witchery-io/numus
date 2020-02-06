import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
//    print('On Event: -->');
//    print('$bloc');
//    print('$event');
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    print('On Error: -->');
//    print('$bloc');
//    print('$error');
//    print('$stacktrace');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
//    print('On Transition: -->');
//    print('$bloc');
//    print('$transition');
  }
}
