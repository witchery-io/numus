import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:games.fair.wallet/src/models/models.dart';

import './bloc.dart';

class TabBloc extends Bloc<TabEvent, AppTab> {
  @override
  AppTab get initialState => AppTab.general;

  @override
  Stream<AppTab> mapEventToState(TabEvent event) async* {
    if (event is UpdateTab) {
      yield event.tab;
    }
  }
}
