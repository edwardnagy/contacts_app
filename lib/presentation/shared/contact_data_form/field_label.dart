import 'dart:math';

import 'package:contacts_app/presentation/shared/contact_data_form/label_picker_screen.dart';
import 'package:contacts_app/presentation/style/spacing.dart';
import 'package:flutter/cupertino.dart';

/// A button that displays the label associated with a field in a form, and
/// allows the user to change it.
class FieldLabel extends StatelessWidget {
  const FieldLabel({
    super.key,
    required this.currentLabel,
    required this.labels,
    required this.onLabelChanged,
  });

  final String currentLabel;
  final List<String> labels;
  final ValueChanged<String> onLabelChanged;

  @override
  Widget build(BuildContext context) {
    final labelMaxWidth = MediaQuery.sizeOf(context).width / 3;
    return Focus(
      descendantsAreFocusable: false,
      canRequestFocus: false,
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () async {
          final selectedLabel = await LabelPickerScreen.show(
            context,
            initialLabel: currentLabel,
            labels: labels,
          );
          if (selectedLabel != null) {
            onLabelChanged(selectedLabel);
          }
        },
        child: Row(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: min(
                  // Eye-balled value to align phone labels to the end.
                  MediaQuery.textScalerOf(context).scale(52),
                  labelMaxWidth,
                ),
                maxWidth: labelMaxWidth,
              ),
              child: Text(
                currentLabel,
                textAlign: TextAlign.end,
                style: TextStyle(
                  color: CupertinoColors.activeBlue.resolveFrom(context),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: Spacing.x0_5,
              ),
              child: Icon(
                CupertinoIcons.chevron_forward,
                size: CupertinoTheme.of(context).textTheme.textStyle.fontSize,
                color: CupertinoColors.systemGrey2.resolveFrom(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
