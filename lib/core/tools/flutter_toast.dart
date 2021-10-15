import 'package:toast/toast.dart';
import 'package:flutter/material.dart';

class FlutterToast {
  static void show({String message, BuildContext context}) {
    Toast.show(
      message,
      context,
      duration: Toast.LENGTH_LONG,
      gravity: Toast.BOTTOM,
    );
  }

  static void showErrorToast({
    String message,
    BuildContext context,
    int gravity = 0,
  }) {
    Toast.show(
      message,
      context,
      duration: Toast.LENGTH_LONG,
      gravity: gravity,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  static void showSuccess({String message, BuildContext context}) {
    Toast.show(
      message,
      context,
      duration: Toast.LENGTH_LONG,
      gravity: Toast.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }
}
