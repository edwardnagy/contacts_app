import 'package:flutter/cupertino.dart';

class AppTextStyle {
  AppTextStyle._();

  static TextStyle titleMedium(BuildContext context) {
    return const TextStyle(
      fontSize: 24,
      color: CupertinoColors.secondaryLabel,
    );
  }

  static TextStyle label(BuildContext context) {
    return const TextStyle(
      fontSize: 14,
    );
  }
}
