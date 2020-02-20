import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:uni_links/uni_links.dart';

class LinkProvider extends InheritedWidget {
  final Widget child;

  Stream<String> get linkStream => getLinksStream();

  const LinkProvider({Key key, this.child}) : super(key: key, child: child);

  static LinkProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<LinkProvider>();
  }

  @override
  bool updateShouldNotify(LinkProvider oldWidget) {
    return true;
  }
}
