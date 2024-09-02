import 'package:contacts_app/l10n/app_localizations.dart';
import 'package:contacts_app/model/address.dart';
import 'package:contacts_app/model/contact_detail.dart';
import 'package:contacts_app/model/phone_number.dart';
import 'package:contacts_app/router/routes.dart';
import 'package:contacts_app/shared/contact_data_form/contact_data_form.dart';
import 'package:flutter/cupertino.dart';

class ContactEditingScreen extends StatelessWidget {
  const ContactEditingScreen({super.key, required this.contactId});

  final String contactId;

  @override
  Widget build(BuildContext context) {
    const didChangeContactData = false;
    return CupertinoPageScaffold(
      backgroundColor:
          CupertinoColors.systemGroupedBackground.resolveFrom(context),
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            Navigator.of(context).maybePop();
          },
          child: Text(AppLocalizations.of(context).cancel),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: didChangeContactData
              ? () {
                  ContactDetailRoute(contactId: contactId).go(context);
                }
              : null,
          child: Text(AppLocalizations.of(context).done),
        ),
      ),
      child: ContactDataForm(
        firstName: _mockContactDetail.firstName,
        onFirstNameChanged: (value) {}, // TODO: onFirstNameChanged
        lastName: _mockContactDetail.lastName,
        onLastNameChanged: (value) {}, // TODO: onLastNameChanged
        phoneNumbers: _mockContactDetail.phoneNumbers,
        onPhoneNumbersChanged: (value) {}, // TODO: onPhoneNumbersChanged
        addresses: _mockContactDetail.addresses,
        onAddressesChanged: (value) {}, // TODO: onAddressesChanged
      ),
    );
  }
}

const _mockContactDetail = ContactDetail(
  id: '1',
  firstName: 'John',
  lastName: 'Appleseed',
  phoneNumbers: [
    PhoneNumber(
      number: '5555648583',
      label: 'mobile',
    ),
    PhoneNumber(
      number: '+555-555-5555',
      label: 'home',
    ),
    PhoneNumber(
      number: '555-555-5555',
      label: 'work',
    ),
  ],
  addresses: [
    Address(
      street1: '165 Davis Street',
      street2: null,
      city: 'Hillsborough',
      state: 'CA',
      zipCode: '94010',
      label: 'home',
    ),
    Address(
      street1: '1 Apple Park Way',
      street2: 'Cupertino',
      city: 'Cupertino',
      state: 'CA',
      zipCode: '95014',
      label: 'work',
    ),
    Address(
      street1: '1 Infinite Loop',
      street2: 'Cupertino',
      city: null,
      state: null,
      zipCode: '95014',
      label: 'other',
    ),
  ],
);
