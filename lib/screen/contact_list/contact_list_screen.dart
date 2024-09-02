import 'package:contacts_app/l10n/app_localizations.dart';
import 'package:contacts_app/model/contact_sort_field.dart';
import 'package:contacts_app/model/contact_summary.dart';
import 'package:contacts_app/router/routes.dart';
import 'package:contacts_app/screen/contact_list/contact_list_item.dart';
import 'package:contacts_app/style/app_text_style.dart';
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
            backgroundColor: CupertinoColors.systemBackground,
            largeTitle: Text(
              AppLocalizations.of(context).contacts,
            ),
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              child: Icon(
                CupertinoIcons.add,
                size: IconTheme.of(context).size,
              ),
              onPressed: () {
                NewContactRoute().go(context);
              },
            ),
          ),
          if (_mockContacts.isEmpty) ...[
            SliverFillRemaining(
              child: Center(
                child: Text(
                  AppLocalizations.of(context).noContacts,
                  style: AppTextStyle.titleMedium(context),
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
                      ContactListItem(
                        contact: contact,
                        onTap: () {
                          ContactDetailRoute(contactId: contact.id).go(context);
                        },
                      ),
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
}

const _mockContacts = [
  ContactSummary(
    id: '1',
    firstName: "John",
    lastName: "Appleseed",
    phoneNumber: "8885555512",
    sortedField: ContactSortField.lastName,
  ),
  ContactSummary(
    id: '2',
    firstName: "Kate",
    lastName: "Bell",
    phoneNumber: "8885555513",
    sortedField: ContactSortField.lastName,
  ),
  ContactSummary(
    id: '3',
    firstName: "Anna",
    lastName: "Haro",
    phoneNumber: "8885555514",
    sortedField: ContactSortField.lastName,
  ),
  ContactSummary(
    id: '4',
    firstName: "Daniel",
    lastName: "Higgins",
    phoneNumber: "8885555515",
    sortedField: ContactSortField.lastName,
  ),
  ContactSummary(
    id: '5',
    firstName: "R",
    lastName: null,
    phoneNumber: null,
    sortedField: ContactSortField.firstName,
  ),
  ContactSummary(
    id: '6',
    firstName: "David",
    lastName: "Taylor",
    phoneNumber: "8885555516",
    sortedField: ContactSortField.lastName,
  ),
  ContactSummary(
    id: '7',
    firstName: "Hank",
    lastName: "Zakroff",
    phoneNumber: "8885555517",
    sortedField: ContactSortField.lastName,
  ),
  ContactSummary(
    id: '8',
    firstName: null,
    lastName: null,
    phoneNumber: null,
    sortedField: null,
  ),
  ContactSummary(
    id: '9',
    firstName: null,
    lastName: null,
    phoneNumber: "8885555518",
    sortedField: ContactSortField.phoneNumber,
  ),
];
