import 'package:collection/collection.dart';
import 'package:contacts_app/l10n/app_localizations.dart';
import 'package:contacts_app/model/phone_number.dart';
import 'package:contacts_app/shared/constants/phone_labels.dart';
import 'package:contacts_app/shared/contact_data_form/animated_list_form_section.dart';
import 'package:contacts_app/shared/contact_data_form/phone_number_form_field.dart';
import 'package:flutter/cupertino.dart';

/// A form section that allows the user to add and remove phone numbers.
class PhoneNumberFormSection extends StatefulWidget {
  const PhoneNumberFormSection({
    super.key,
    required this.initialPhoneNumbers,
    required this.onPhoneNumbersChanged,
  });

  final List<PhoneNumber> initialPhoneNumbers;
  final ValueChanged<List<PhoneNumber>> onPhoneNumbersChanged;

  @override
  State<PhoneNumberFormSection> createState() => _PhoneNumberFormSectionState();
}

class _PhoneNumberFormSectionState extends State<PhoneNumberFormSection> {
  late var _phoneNumbers = widget.initialPhoneNumbers;
  late final _focusNodes = List.generate(
    _phoneNumbers.length,
    (_) => FocusNode(),
  );

  void _onNewPhoneNumberAdded(BuildContext context) {
    // Determine the label for the new phone number. If the last phone number
    // has a label, use the next label in the list. Otherwise, use the first
    // label in the list.
    final phoneLabels = getPredefinedPhoneLabels(context);
    final lastUsedPhoneLabelIndex =
        phoneLabels.indexOf(_phoneNumbers.lastOrNull?.label ?? '');
    final newPhoneLabel =
        phoneLabels[(lastUsedPhoneLabelIndex + 1) % phoneLabels.length];
    final newPhoneNumber = PhoneNumber(
      number: '', // empty number
      label: newPhoneLabel,
    );

    final updatedPhoneNumbers = [..._phoneNumbers, newPhoneNumber];
    _phoneNumbers = updatedPhoneNumbers;
    widget.onPhoneNumbersChanged(updatedPhoneNumbers);

    // Create a new focus node for the new phone number.
    final newFocusNode = FocusNode();
    _focusNodes.add(newFocusNode);
    newFocusNode.requestFocus();
  }

  void _onPhoneNumberChanged(int index, PhoneNumber phoneNumber) {
    final updatedPhoneNumbers = List<PhoneNumber>.from(_phoneNumbers)
      ..[index] = phoneNumber;
    _phoneNumbers = updatedPhoneNumbers;
    widget.onPhoneNumbersChanged(updatedPhoneNumbers);
  }

  void _onPhoneNumberRemoved(int index) {
    final updatedPhoneNumbers = List<PhoneNumber>.from(_phoneNumbers)
      ..removeAt(index);
    _phoneNumbers = updatedPhoneNumbers;
    widget.onPhoneNumbersChanged(updatedPhoneNumbers);

    // Remove the focus node for the removed phone number.
    final removedFocusNode = _focusNodes.removeAt(index);
    removedFocusNode.dispose();
  }

  @override
  void dispose() {
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedListFormSection(
      initialItemCount: _phoneNumbers.length,
      itemBuilder: (context, index) {
        return PhoneNumberFormField(
          focusNode: _focusNodes[index],
          initialPhoneNumber: _phoneNumbers[index],
          onPhoneNumberChanged: (phoneNumber) {
            _onPhoneNumberChanged(index, phoneNumber);
          },
        );
      },
      addItemButtonLabel: AppLocalizations.of(context).addPhone,
      onItemAdded: () {
        _onNewPhoneNumberAdded(context);
      },
      onItemRemoved: _onPhoneNumberRemoved,
    );
  }
}
