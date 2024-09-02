import 'package:contacts_app/presentation/l10n/app_localizations.dart';
import 'package:contacts_app/core/model/phone_number.dart';
import 'package:contacts_app/presentation/shared/constants/phone_labels.dart';
import 'package:contacts_app/presentation/shared/contact_data_form/field_label.dart';
import 'package:contacts_app/presentation/shared/widgets/vertical_field_divider.dart';
import 'package:contacts_app/presentation/style/spacing.dart';
import 'package:flutter/cupertino.dart';

class PhoneNumberFormField extends StatelessWidget {
  const PhoneNumberFormField({
    super.key,
    required this.initialPhoneNumber,
    required this.onPhoneNumberChanged,
  });

  final PhoneNumber initialPhoneNumber;
  final ValueChanged<PhoneNumber> onPhoneNumberChanged;

  @override
  Widget build(BuildContext context) {
    return CupertinoTextFormFieldRow(
      padding: EdgeInsetsDirectional.zero,
      prefix: Row(
        children: [
          FieldLabel(
            currentLabel: initialPhoneNumber.label,
            labels: getPredefinedPhoneLabels(context),
            onLabelChanged: (label) {
              onPhoneNumberChanged(
                initialPhoneNumber.copyWith(label: label),
              );
            },
          ),
          const VerticalFieldDivider(),
          const SizedBox(width: Spacing.x1),
        ],
      ),
      placeholder: AppLocalizations.of(context).phonePlaceholder,
      placeholderStyle: TextStyle(
        color: CupertinoColors.secondaryLabel.resolveFrom(context),
      ),
      keyboardType: TextInputType.phone,
      initialValue: initialPhoneNumber.number,
      onChanged: (value) {
        onPhoneNumberChanged(
          initialPhoneNumber.copyWith(number: value),
        );
      },
    );
  }
}
