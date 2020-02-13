import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class Message {
  static void show(BuildContext context, String message,
      {duration = 2, gravity = 2}) {
    Toast.show(message, context, duration: duration, gravity: gravity);
  }
}
