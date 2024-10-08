import 'package:contacts_app/presentation/l10n/app_localizations.dart';
import 'package:contacts_app/core/model/address.dart';
import 'package:contacts_app/core/model/phone_number.dart';
import 'package:contacts_app/presentation/shared/contact_data_form/address_form_section.dart';
import 'package:contacts_app/presentation/shared/contact_data_form/phone_number_form_section.dart';
import 'package:contacts_app/presentation/style/spacing.dart';
import 'package:flutter/cupertino.dart';

class ContactDataForm extends StatefulWidget {
  const ContactDataForm({
    super.key,
    required this.firstName,
    required this.onFirstNameChanged,
    required this.lastName,
    required this.onLastNameChanged,
    required this.phoneNumbers,
    required this.onPhoneNumbersChanged,
    required this.addresses,
    required this.onAddressesChanged,
    this.onDeletePressed,
    this.autofocus = false,
  });

  final String? firstName;
  final ValueChanged<String> onFirstNameChanged;
  final String? lastName;
  final ValueChanged<String> onLastNameChanged;
  final List<PhoneNumber>? phoneNumbers;
  final ValueChanged<List<PhoneNumber>> onPhoneNumbersChanged;
  final List<Address>? addresses;
  final ValueChanged<List<Address>> onAddressesChanged;

  /// Callback when the delete button is pressed. If null, the delete button is
  /// not shown.
  final VoidCallback? onDeletePressed;
  final bool autofocus;

  @override
  State<ContactDataForm> createState() => _ContactDataFormState();
}

class _ContactDataFormState extends State<ContactDataForm> {
  final _namesFocusScopeNode = FocusScopeNode(
    debugLabel: 'names',
    traversalEdgeBehavior: TraversalEdgeBehavior.parentScope,
  );

  @override
  void initState() {
    super.initState();
    if (widget.autofocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _namesFocusScopeNode.nextFocus();
      });
    }
  }

  @override
  void dispose() {
    _namesFocusScopeNode.dispose();
    super.dispose();
  }

  Widget _nameField(
    BuildContext context, {
    required String placeholder,
    required String? initialValue,
    required ValueChanged<String> onChanged,
  }) {
    return CupertinoTextFormFieldRow(
      padding: const EdgeInsetsDirectional.symmetric(
        vertical: 6.0, // 6.0 is the default vertical padding
      ).copyWith(start: Spacing.firstKeyline),
      placeholder: placeholder,
      placeholderStyle: TextStyle(
        color: CupertinoColors.secondaryLabel.resolveFrom(context),
      ),
      textCapitalization: TextCapitalization.words,
      textInputAction: TextInputAction.unspecified,
      onEditingComplete: _namesFocusScopeNode.nextFocus,
      enableSuggestions: false,
      // On iOS, auto suggestions can only be disabled by disabling autocorrect.
      autocorrect: false,
      initialValue: initialValue,
      onChanged: onChanged,
    );
  }

  CupertinoFormSection _deleteContactButton(BuildContext context) {
    return CupertinoFormSection(
      children: [
        CupertinoListTile(
          onTap: widget.onDeletePressed,
          title: CupertinoFormRow(
            padding: EdgeInsetsDirectional.zero,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                AppLocalizations.of(context).deleteContact,
                style: TextStyle(
                  color: CupertinoColors.destructiveRed.resolveFrom(context),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    const sectionSpacing = Spacing.x2;

    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      children: [
        FocusScope(
          node: _namesFocusScopeNode,
          child: CupertinoFormSection(
            children: [
              _nameField(
                context,
                placeholder: AppLocalizations.of(context).firstNamePlaceholder,
                initialValue: widget.firstName,
                onChanged: widget.onFirstNameChanged,
              ),
              _nameField(
                context,
                placeholder: AppLocalizations.of(context).lastNamePlaceholder,
                initialValue: widget.lastName,
                onChanged: widget.onLastNameChanged,
              ),
            ],
          ),
        ),
        const SizedBox(height: sectionSpacing),
        PhoneNumberFormSection(
          initialPhoneNumbers: widget.phoneNumbers,
          onPhoneNumbersChanged: widget.onPhoneNumbersChanged,
        ),
        const SizedBox(height: sectionSpacing),
        AddressFormSection(
          initialAddresses: widget.addresses,
          onAddressesChanged: widget.onAddressesChanged,
        ),
        const SizedBox(height: sectionSpacing),
        if (widget.onDeletePressed != null) _deleteContactButton(context),
        const SizedBox(height: sectionSpacing),
      ],
    );
  }
}
