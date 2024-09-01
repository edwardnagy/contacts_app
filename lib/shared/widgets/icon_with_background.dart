import 'package:contacts_app/style/spacing.dart';
import 'package:flutter/cupertino.dart';

/// A widget that displays an icon with a circular background color.
///
/// This is useful in cases where transparent parts of the icons need to appear
/// filled with a specific color, such as when mimicking the appearance of
/// native icons in dark mode.
/// For example, the 'add' icon should be white in the center instead of
/// transparent.
class IconWithBackground extends StatelessWidget {
  /// Creates a widget that displays an icon with a circular background color.
  const IconWithBackground(
    this.iconData, {
    super.key,
    required this.iconColor,
    required this.backgroundColor,
  });

  final IconData iconData;
  final Color iconColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.all(Spacing.x0_5),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: backgroundColor,
              ),
            ),
          ),
        ),
        Icon(
          iconData,
          color: iconColor,
        ),
      ],
    );
  }
}
