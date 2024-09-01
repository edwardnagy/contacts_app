import 'package:flutter/cupertino.dart';

class VerticalFieldDivider extends StatelessWidget {
  const VerticalFieldDivider({
    super.key,
    this.height = 46.0, // the height of a CupertinoTextFormFieldRow
  });

  final double height;

  @override
  Widget build(BuildContext context) {
    final dividerWidth = 1.0 / MediaQuery.devicePixelRatioOf(context);

    return Container(
      width: dividerWidth,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            CupertinoColors.systemGrey2.resolveFrom(context),
            CupertinoColors.separator.resolveFrom(context),
            CupertinoColors.transparent,
          ],
          stops: const [0, 0.6, 1.0],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
    );
  }
}
