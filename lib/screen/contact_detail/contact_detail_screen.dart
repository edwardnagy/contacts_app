import 'package:collection/collection.dart';
import 'package:contacts_app/l10n/app_localizations.dart';
import 'package:contacts_app/model/address.dart';
import 'package:contacts_app/model/phone_number.dart';
import 'package:contacts_app/router/routes.dart';
import 'package:contacts_app/simple_di.dart';
import 'package:contacts_app/style/app_text_style.dart';
import 'package:contacts_app/style/spacing.dart';
import 'package:flutter/cupertino.dart';

class ContactDetailScreen extends StatefulWidget {
  const ContactDetailScreen({
    super.key,
    required this.contactId,
    required this.firstName,
    required this.lastName,
  });

  final String contactId;

  /// The first name of the contact, required for the animation of the
  /// navigation bar title.
  final String? firstName;

  /// The last name of the contact, required for the animation of the navigation
  /// bar title.
  final String? lastName;

  @override
  State<ContactDetailScreen> createState() => _ContactDetailScreenState();
}

class _ContactDetailScreenState extends State<ContactDetailScreen> {
  // TODO: Use a BLoC with a use case to manage the contacts.
  final _contactRepository = SimpleDi.contactRepository;

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
    return StreamBuilder(
      stream: _contactRepository.watchContactDetail(widget.contactId),
      builder: (context, snapshot) {
        final contact = snapshot.data;
        final (phoneNumbers, addresses) =
            (contact?.phoneNumbers, contact?.addresses);

        return CupertinoPageScaffold(
          backgroundColor:
              CupertinoColors.systemGroupedBackground.resolveFrom(context),
          navigationBar: CupertinoNavigationBar(
            middle: Text(
              [
                contact?.firstName ?? widget.firstName,
                contact?.lastName ?? widget.lastName
              ].whereNotNull().join(' '),
            ),
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              child: Text(AppLocalizations.of(context).edit),
              onPressed: () {
                ContactEditingRoute(contactId: widget.contactId).go(context);
              },
            ),
          ),
          child: ListView(
            children: [
              if (phoneNumbers != null && phoneNumbers.isNotEmpty)
                CupertinoListSection.insetGrouped(
                  margin: const EdgeInsets.symmetric(
                    horizontal: Spacing.x1,
                  ).copyWith(
                    top: Spacing.x2,
                  ),
                  additionalDividerMargin: 0,
                  children: phoneNumbers
                      .map((phoneNumber) =>
                          _phoneNumberTile(context, phoneNumber))
                      .toList(),
                ),
              if (addresses != null && addresses.isNotEmpty)
                CupertinoListSection.insetGrouped(
                  margin: const EdgeInsets.symmetric(
                    horizontal: Spacing.x1,
                  ).copyWith(
                    top: Spacing.x2,
                  ),
                  additionalDividerMargin: 0,
                  children: addresses
                      .map((address) => _addressTile(context, address))
                      .toList(),
                ),
              const SizedBox(height: Spacing.x4),
            ],
          ),
        );
      },
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
