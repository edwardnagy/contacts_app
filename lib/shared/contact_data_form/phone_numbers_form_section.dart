import 'package:collection/collection.dart';
import 'package:contacts_app/l10n/app_localizations.dart';
import 'package:contacts_app/model/phone_number.dart';
import 'package:contacts_app/shared/constants/phone_labels.dart';
import 'package:contacts_app/shared/contact_data_form/phone_number_edit_field.dart';
import 'package:contacts_app/shared/widgets/divider.dart';
import 'package:contacts_app/style/animation_duration.dart';
import 'package:contacts_app/style/spacing.dart';
import 'package:flutter/cupertino.dart';

class PhoneNumbersFormSection extends StatefulWidget {
  const PhoneNumbersFormSection({
    super.key,
    required this.phoneNumbers,
    required this.onPhoneNumbersChanged,
  });

  final List<PhoneNumber> phoneNumbers;
  final ValueChanged<List<PhoneNumber>> onPhoneNumbersChanged;

  @override
  State<PhoneNumbersFormSection> createState() =>
      _PhoneNumbersFormSectionState();
}

class _PhoneNumbersFormSectionState extends State<PhoneNumbersFormSection> {
  late var _phoneNumbers = widget.phoneNumbers;

  @override
  void didUpdateWidget(covariant PhoneNumbersFormSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    _phoneNumbers = widget.phoneNumbers;
  }

  void _onNewPhoneNumberAdded(BuildContext context) {
    // Determine the phone label for the new phone number. If the last phone
    // number has a label, use the next label in the list. Otherwise, use the
    // first label in the list.
    final phoneLabels = getPredefinedPhoneLabels(context);
    final lastUsedPhoneLabelIndex =
        phoneLabels.indexOf(_phoneNumbers.lastOrNull?.label ?? '');
    final newPhoneLabel =
        phoneLabels[(lastUsedPhoneLabelIndex + 1) % phoneLabels.length];
    // Set the new phone number.
    final newPhoneNumber = PhoneNumber(
      number: '', // Empty phone number.
      label: newPhoneLabel,
    );

    final updatedPhoneNumbers = [..._phoneNumbers, newPhoneNumber];
    _phoneNumbers = updatedPhoneNumbers;
    widget.onPhoneNumbersChanged(updatedPhoneNumbers);
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
  }

  Widget _addPhoneNumberButton(
    BuildContext context, {
    required VoidCallback onPressed,
  }) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
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
    final divider = Divider(
      leadingIndent: Spacing.firstKeyline +
          (IconTheme.of(context).size ?? 0) +
          Spacing.firstKeyline,
    );
    return CupertinoListSection(
      children: [
        AnimatedList.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          // Add one to the item count to account for the add button.
          initialItemCount: _phoneNumbers.length + 1,
          itemBuilder: (context, index, animation) {
            if (index == _phoneNumbers.length) {
              return _addPhoneNumberButton(
                context,
                onPressed: () {
                  _onNewPhoneNumberAdded(context);
                  AnimatedList.of(context).insertItem(
                    _phoneNumbers.length - 1, // Insert before the add button.
                    duration: AnimationDuration.short,
                  );
                },
              );
            }

            Widget removedItemBuilder(
              BuildContext context,
              Animation<double> animation,
              PhoneNumber phoneNumber,
            ) {
              return SlideTransition(
                // Slide the item to the left when removed.
                position: Tween<Offset>(
                  begin: const Offset(-1, 0),
                  end: const Offset(0, 0),
                ).animate(animation),
                child: SizeTransition(
                  sizeFactor: animation,
                  child: PhoneNumberEditField(
                    phoneNumber: phoneNumber,
                    onPhoneNumberRemoved: () {},
                    onPhoneNumberChanged: (_) {},
                  ),
                ),
              );
            }

            final phoneNumber = _phoneNumbers[index];
            return SizeTransition(
              sizeFactor: animation,
              child: PhoneNumberEditField(
                phoneNumber: phoneNumber,
                onPhoneNumberRemoved: () {
                  _onPhoneNumberRemoved(index);
                  AnimatedList.of(context).removeItem(
                    index,
                    duration: AnimationDuration.short,
                    (context, animation) =>
                        removedItemBuilder(context, animation, phoneNumber),
                  );
                },
                onPhoneNumberChanged: (phoneNumber) {
                  _onPhoneNumberChanged(index, phoneNumber);
                },
              ),
            );
          },
          separatorBuilder: (context, index, animation) => divider,
          removedSeparatorBuilder: (context, index, animation) => divider,
        ),
      ],
    );
  }
}
