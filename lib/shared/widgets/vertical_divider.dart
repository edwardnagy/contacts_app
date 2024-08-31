import 'package:flutter/cupertino.dart';

class VerticalDivider extends StatelessWidget {
  const VerticalDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final dividerWidth = 1.0 / MediaQuery.devicePixelRatioOf(context);

    return Container(
      width: dividerWidth,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            CupertinoColors.separator.resolveFrom(context),
            CupertinoColors.separator.resolveFrom(context),
            CupertinoColors.transparent,
          ],
          stops: const [0.0, 0.3, 1.0],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
    );
  }
}
