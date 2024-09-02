import 'package:collection/collection.dart';
import 'package:contacts_app/l10n/app_localizations.dart';
import 'package:contacts_app/model/address.dart';
import 'package:contacts_app/model/contact_detail.dart';
import 'package:contacts_app/model/phone_number.dart';
import 'package:contacts_app/router/routes.dart';
import 'package:contacts_app/style/app_text_style.dart';
import 'package:contacts_app/style/spacing.dart';
import 'package:flutter/cupertino.dart';

class ContactDetailScreen extends StatelessWidget {
  const ContactDetailScreen({
    super.key,
    required this.contactId,
  });

  final String contactId;

  CupertinoListTile _phoneNumberTile(
    BuildContext context,
    PhoneNumber phoneNumber,
  ) {
    return CupertinoListTile.notched(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.x_2_5,
        vertical: Spacing.x1_5,
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            phoneNumber.label,
            style: AppTextStyle.label(context),
          ),
          const SizedBox(height: Spacing.x0_5),
          Text(
            phoneNumber.number,
            style: CupertinoTheme.of(context).textTheme.actionTextStyle,
          ),
        ],
      ),
    );
  }

  CupertinoListTile _addressTile(
    BuildContext context,
    Address address,
  ) {
    final (street1, street2, city, state, zipCode) = (
      address.street1,
      address.street2,
      address.city,
      address.state,
      address.zipCode
    );
    final addressText = [
      street1,
      street2,
      [
        [city, state].whereNotNull().joinIfNotEmpty(', '),
        zipCode,
      ].whereNotNull().joinIfNotEmpty(' '),
    ].whereNotNull().join('\n');
    return CupertinoListTile.notched(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.x_2_5,
        vertical: Spacing.x1_5,
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            address.label,
            style: AppTextStyle.label(context),
          ),
          const SizedBox(height: Spacing.x0_5),
          ConstrainedBox(
            constraints: BoxConstraints(
                minHeight:
                    3 * (DefaultTextStyle.of(context).style.fontSize ?? 18)),
            child: Text(
              addressText,
              maxLines: 5,
            ),
          ),
          const SizedBox(height: Spacing.x1),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor:
          CupertinoColors.systemGroupedBackground.resolveFrom(context),
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          '${_mockContactDetail.firstName} ${_mockContactDetail.lastName}',
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Text(AppLocalizations.of(context).edit),
          onPressed: () {
            ContactEditingRoute(contactId: contactId).go(context);
          },
        ),
      ),
      child: ListView(
        children: [
          CupertinoListSection.insetGrouped(
            margin: const EdgeInsets.symmetric(
              horizontal: Spacing.x1,
            ).copyWith(
              top: Spacing.x2,
            ),
            additionalDividerMargin: 0,
            children: _mockContactDetail.phoneNumbers
                .map((phoneNumber) => _phoneNumberTile(context, phoneNumber))
                .toList(),
          ),
          CupertinoListSection.insetGrouped(
            margin: const EdgeInsets.symmetric(
              horizontal: Spacing.x1,
            ).copyWith(
              top: Spacing.x2,
            ),
            additionalDividerMargin: 0,
            children: _mockContactDetail.addresses
                .map((address) => _addressTile(context, address))
                .toList(),
          ),
          const SizedBox(height: Spacing.x4),
        ],
      ),
    );
  }
}

extension on Iterable<String> {
  /// Joins the elements of this iterable into a single string with the given
  /// [separator]. If this iterable is empty, returns `null`.
  String? joinIfNotEmpty(String separator) {
    return isNotEmpty ? join(separator) : null;
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
