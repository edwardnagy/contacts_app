import 'package:contacts_app/l10n/app_localizations.dart';
import 'package:contacts_app/model/contact_sort_field.dart';
import 'package:contacts_app/model/contact_summary.dart';
import 'package:contacts_app/shared/app_text_style.dart';
import 'package:contacts_app/shared/widgets/divider.dart';
import 'package:flutter/cupertino.dart';

class ContactListScreen extends StatelessWidget {
  const ContactListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: <Widget>[
          CupertinoSliverNavigationBar(
            largeTitle: Text(
              AppLocalizations.of(context).contacts,
            ),
            backgroundColor: CupertinoColors.systemBackground,
          ),
          if (_mockContacts.isEmpty) ...[
            SliverFillRemaining(
              child: Center(
                child: Text(
                  AppLocalizations.of(context).noContacts,
                  style: AppTextStyle.emptyLabel(context),
                ),
              ),
            ),
          ] else ...[
            SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: _mockContacts.length,
                (context, index) {
                  final contact = _mockContacts[index];
                  return Column(
                    children: [
                      _contactListItem(context, contact),
                      const Divider(),
                    ],
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _contactListItem(BuildContext context, ContactSummary contact) {
    final (firstName, lastName, phoneNumber) =
        (contact.firstName, contact.lastName, contact.phoneNumber);
    return CupertinoListTile(
      title: Text.rich(
        TextSpan(
          children: [
            // Display the contact's name if available.
            if (firstName != null) ...[
              TextSpan(
                text: firstName,
                style: TextStyle(
                  fontWeight: contact.sortedField == ContactSortField.firstName
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ],
            if (lastName != null) ...[
              if (contact.firstName != null) const TextSpan(text: ' '),
              TextSpan(
                text: lastName,
                style: TextStyle(
                  fontWeight: contact.sortedField == ContactSortField.lastName
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ],
            if (firstName == null && lastName == null) ...[
              // Otherwise, display the phone number if available.
              if (phoneNumber != null) ...[
                TextSpan(
                  text: phoneNumber,
                  style: TextStyle(
                    fontWeight:
                        contact.sortedField == ContactSortField.phoneNumber
                            ? FontWeight.bold
                            : FontWeight.normal,
                  ),
                )
              ] else ...[
                // If the contact has no name or phone number, display a placeholder.
                TextSpan(
                  text: AppLocalizations.of(context).noName,
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

const _mockContacts = [
  ContactSummary(
    firstName: "John",
    lastName: "Appleseed",
    phoneNumber: "8885555512",
    sortedField: ContactSortField.lastName,
  ),
  ContactSummary(
    firstName: "Kate",
    lastName: "Bell",
    phoneNumber: "8885555513",
    sortedField: ContactSortField.lastName,
  ),
  ContactSummary(
    firstName: "Anna",
    lastName: "Haro",
    phoneNumber: "8885555514",
    sortedField: ContactSortField.lastName,
  ),
  ContactSummary(
    firstName: "Daniel",
    lastName: "Higgins",
    phoneNumber: "8885555515",
    sortedField: ContactSortField.lastName,
  ),
  ContactSummary(
    firstName: "R",
    lastName: null,
    phoneNumber: null,
    sortedField: ContactSortField.firstName,
  ),
  ContactSummary(
    firstName: "David",
    lastName: "Taylor",
    phoneNumber: "8885555516",
    sortedField: ContactSortField.lastName,
  ),
  ContactSummary(
    firstName: "Hank",
    lastName: "Zakroff",
    phoneNumber: "8885555517",
    sortedField: ContactSortField.lastName,
  ),
  ContactSummary(
    firstName: null,
    lastName: null,
    phoneNumber: null,
    sortedField: null,
  ),
  ContactSummary(
    firstName: null,
    lastName: null,
    phoneNumber: "8885555518",
    sortedField: ContactSortField.phoneNumber,
  ),
];
