import 'package:collection/collection.dart';
import 'package:contacts_app/l10n/app_localizations.dart';
import 'package:contacts_app/model/phone_number.dart';
import 'package:contacts_app/shared/constants/phone_labels.dart';
import 'package:contacts_app/shared/contact_data_form/phone_number_edit_field.dart';
import 'package:contacts_app/style/spacing.dart';
import 'package:flutter/cupertino.dart';

class PhoneNumbersFormSection extends StatelessWidget {
  const PhoneNumbersFormSection({
    super.key,
    required this.phoneNumbers,
    required this.onPhoneNumbersChanged,
  });

  final List<PhoneNumber> phoneNumbers;
  final ValueChanged<List<PhoneNumber>> onPhoneNumbersChanged;

  void _onNewPhoneNumberAdded(BuildContext context) {
    // Determine the phone label for the new phone number. If the last phone
    // number has a label, use the next label in the list. Otherwise, use the
    // first label in the list.
    final phoneLabels = getPredefinedPhoneLabels(context);
    final lastUsedPhoneLabelIndex =
        phoneLabels.indexOf(phoneNumbers.lastOrNull?.label ?? '');
    final newPhoneLabel =
        phoneLabels[(lastUsedPhoneLabelIndex + 1) % phoneLabels.length];
    // Set the new phone number.
    final newPhoneNumber = PhoneNumber(
      number: '', // Empty phone number.
      label: newPhoneLabel,
    );
    onPhoneNumbersChanged([...phoneNumbers, newPhoneNumber]);
  }

  void _onPhoneNumberChanged(int index, PhoneNumber phoneNumber) {
    final updatedPhoneNumbers = List<PhoneNumber>.from(phoneNumbers);
    updatedPhoneNumbers[index] = phoneNumber;
    onPhoneNumbersChanged(updatedPhoneNumbers);
  }

  void _onPhoneNumberRemoved(int index) {
    final updatedPhoneNumbers = List<PhoneNumber>.from(phoneNumbers);
    updatedPhoneNumbers.removeAt(index);
    onPhoneNumbersChanged(updatedPhoneNumbers);
  }

  Widget _addPhoneNumberButton(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () => _onNewPhoneNumberAdded(context),
      child: CupertinoFormRow(
        padding: EdgeInsetsDirectional.zero,
        prefix: Padding(
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: Spacing.firstKeyline,
          ),
          child: Icon(
            CupertinoIcons.add_circled_solid,
            color: CupertinoColors.systemGreen.resolveFrom(context),
          ),
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            AppLocalizations.of(context).addPhone,
            textAlign: TextAlign.start,
            style: TextStyle(
              color: CupertinoColors.label.resolveFrom(context),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoListSection(
      additionalDividerMargin: Spacing.x3,
      children: [
        ...phoneNumbers.mapIndexed((index, phoneNumber) {
          return PhoneNumberEditField(
            phoneNumber: phoneNumber,
            onPhoneNumberRemoved: () {
              _onPhoneNumberRemoved(index);
            },
            onPhoneNumberChanged: (phoneNumber) {
              _onPhoneNumberChanged(index, phoneNumber);
            },
          );
        }),
        _addPhoneNumberButton(context),
      ],
    );
  }
}
