import 'package:flutter/cupertino.dart';

class AppTextStyle {
  AppTextStyle._();

  static TextStyle emptyLabel(BuildContext context) {
    return DefaultTextStyle.of(context).style.copyWith(
          fontSize: 24,
          color: CupertinoColors.secondaryLabel,
        );
  }
}
