import 'dart:math';

import 'package:contacts_app/l10n/app_localizations.dart';
import 'package:contacts_app/model/phone_number.dart';
import 'package:contacts_app/shared/contact_data_form/phone_label_picker_screen.dart';
import 'package:contacts_app/shared/widgets/vertical_divider.dart';
import 'package:contacts_app/style/spacing.dart';
import 'package:flutter/cupertino.dart';

class PhoneNumberFormField extends StatelessWidget {
  const PhoneNumberFormField({
    super.key,
    required this.phoneNumber,
    required this.onPhoneNumberChanged,
  });

  final PhoneNumber phoneNumber;
  final ValueChanged<PhoneNumber> onPhoneNumberChanged;

  Future<void> _onPhoneLabelPressed(BuildContext context) async {
    final selectedPhoneLabel = await PhoneLabelPickerScreen.show(
      context,
      initialLabel: phoneNumber.label,
    );
    if (selectedPhoneLabel != null) {
      onPhoneNumberChanged(
        phoneNumber.copyWith(label: selectedPhoneLabel),
      );
    }
  }

  Widget _phoneLabelButton(BuildContext context) {
    final labelMaxWidth = MediaQuery.sizeOf(context).width / 3;
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () => _onPhoneLabelPressed(context),
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
              phoneNumber.label,
              textAlign: TextAlign.end,
              style: TextStyle(
                color: CupertinoColors.activeBlue.resolveFrom(context),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsetsDirectional.symmetric(horizontal: Spacing.x1),
            child: CupertinoListTileChevron(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // the normal height of a CupertinoTextFormFieldRow
    const fieldHeight = 46.0;

    return CupertinoTextFormFieldRow(
      padding: EdgeInsetsDirectional.zero,
      prefix: Row(
        children: [
          _phoneLabelButton(context),
          const SizedBox(
            height: fieldHeight,
            child: VerticalDivider(),
          ),
          const SizedBox(width: Spacing.x1),
        ],
      ),
      placeholder: AppLocalizations.of(context).phonePlaceholder,
      placeholderStyle: TextStyle(
        color: CupertinoColors.secondaryLabel.resolveFrom(context),
      ),
      keyboardType: TextInputType.phone,
      onChanged: (value) {
        onPhoneNumberChanged(
          phoneNumber.copyWith(number: value),
        );
      },
    );
  }
}
