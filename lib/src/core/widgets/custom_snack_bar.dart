import 'package:flutter/material.dart';

class CustomSnackBar {
  static void showSnackBar(
    BuildContext context, {
    required Widget content,
    Duration? duration,
    Color? backgroundColor,
  }) {
    final SnackBar snackBar = SnackBar(
      content: content,
      duration: duration ?? Duration(seconds: 4),
      backgroundColor: backgroundColor,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
