import 'package:flutter/cupertino.dart';

/// Built based on how the divider is implemented in [CupertinoListSection].
class Divider extends StatelessWidget {
  final double leadingIndent;

  const Divider({
    super.key,
    this.leadingIndent = 20,
  });

  @override
  Widget build(BuildContext context) {
    final dividerHeight = 1.0 / MediaQuery.devicePixelRatioOf(context);

    return Container(
      margin: EdgeInsets.only(left: leadingIndent),
      height: dividerHeight,
      color: CupertinoColors.separator,
    );
  }
}
