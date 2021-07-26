import 'package:flutter/material.dart';
import 'package:trainingpods/theme.dart';

class CustomSnackBar {
  CustomSnackBar(BuildContext context, Widget content,
      { SnackBarAction? snackBarAction, Color backgroundColor = CustomTheme.paleRed}) {
    final SnackBar snackBar = SnackBar(
        action: snackBarAction,
        backgroundColor: backgroundColor,
        content: content,
        behavior: SnackBarBehavior.floating);

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
