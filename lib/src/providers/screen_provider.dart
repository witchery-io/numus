import 'package:flutter/widgets.dart';

class ScreenProvider extends InheritedWidget {
  final Widget child;

  const ScreenProvider({Key key, this.child}) : super(key: key, child: child);

  static ScreenProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ScreenProvider>();
  }

  @override
  bool updateShouldNotify(ScreenProvider oldWidget) {
    return true;
  }
}
