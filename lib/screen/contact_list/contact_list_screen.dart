import 'package:contacts_app/l10n/app_localizations.dart';
import 'package:contacts_app/model/contact_sort_field.dart';
import 'package:contacts_app/model/contact_summary.dart';
import 'package:contacts_app/router/routes.dart';
import 'package:contacts_app/screen/contact_list/contact_list_item.dart';
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
                      ContactListItem(
                        contact: contact,
                        onTap: () {
                          // TODO: Open contact details.
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
