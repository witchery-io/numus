import 'package:flutter/widgets.dart';
import 'package:screen_state/screen_state.dart';

class ScreenProvider extends InheritedWidget {
  final Widget child;
  final Screen screen;

  Stream get screenStream => screen.screenStateStream;

  const ScreenProvider({Key key, @required this.screen, this.child})
      : assert(screen != null),
        super(key: key, child: child);

  static ScreenProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ScreenProvider>();
  }

  @override
  bool updateShouldNotify(ScreenProvider oldWidget) {
    return true;
  }
}
