import 'package:contacts_app/l10n/app_localizations.dart';
import 'package:contacts_app/model/contact_sort_field_type.dart';
import 'package:contacts_app/model/contact_summary.dart';
import 'package:flutter/cupertino.dart';

class ContactListItem extends StatelessWidget {
  const ContactListItem({
    super.key,
    required this.contact,
    required this.onTap,
  });

  final ContactSummary contact;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final (firstName, lastName, phoneNumber) =
        (contact.firstName, contact.lastName, contact.phoneNumber);
    return CupertinoListTile(
      onTap: onTap,
      title: Text.rich(
        TextSpan(
          children: [
            // Name is preferred over phone number.
            if (firstName != null) ...[
              TextSpan(
                text: firstName,
                style: TextStyle(
                  fontWeight:
                      contact.sortFieldType == ContactSortFieldType.firstName
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
                  fontWeight:
                      contact.sortFieldType == ContactSortFieldType.lastName
                          ? FontWeight.bold
                          : FontWeight.normal,
                ),
              ),
            ],
            if (firstName == null && lastName == null) ...[
              // Phone number is used as a fallback.
              if (phoneNumber != null) ...[
                TextSpan(
                  text: phoneNumber,
                  style: TextStyle(
                    fontWeight: contact.sortFieldType ==
                            ContactSortFieldType.phoneNumber
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                )
              ] else ...[
                // No name or phone number available, show a placeholder.
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
