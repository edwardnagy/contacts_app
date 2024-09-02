import 'package:contacts_app/data/contact_local_source.dart';
import 'package:contacts_app/data/objectbox/contact_box_dao.dart';
import 'package:contacts_app/data/objectbox/contact_metadata_box_dao.dart';
import 'package:contacts_app/l10n/app_localizations.dart';
import 'package:contacts_app/model/contact_sort_field_type.dart';
import 'package:contacts_app/objectbox/object_box.dart';
import 'package:contacts_app/repository/contact_repository.dart';
import 'package:contacts_app/router/routes.dart';
import 'package:contacts_app/screen/contact_list/contact_list_item.dart';
import 'package:contacts_app/shared/widgets/divider.dart';
import 'package:contacts_app/style/app_text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';

class ContactListScreen extends StatefulWidget {
  const ContactListScreen({super.key});

  @override
  State<ContactListScreen> createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  final _contactRepository = ContactRepository(
    Logger(),
    ContactLocalSource(
      ObjectBox.instance.store,
      ContactBoxDao(ObjectBox.instance.store),
      ContactMetadataBoxDao(ObjectBox.instance.store),
    ),
  );

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
                ContactCreationRoute().go(context);
              },
            ),
          ),
          StreamBuilder(
            stream: _contactRepository.watchContacts([
              ContactSortFieldType.lastName,
              ContactSortFieldType.firstName,
              ContactSortFieldType.phoneNumber,
            ]),
            builder: (context, snapshot) {
              final contacts = snapshot.data;
              if (contacts == null) {
                return const SliverFillRemaining(
                  child: Center(
                    child: CupertinoActivityIndicator(),
                  ),
                );
              }
              if (contacts.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context).noContacts,
                      style: AppTextStyle.titleMedium(context),
                    ),
                  ),
                );
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  childCount: contacts.length,
                  (context, index) {
                    final contact = contacts[index];
                    return Column(
                      children: [
                        ContactListItem(
                          contact: contact,
                          onTap: () {
                            ContactDetailRoute(contactId: contact.id)
                                .go(context);
                          },
                        ),
                        const Divider(),
                      ],
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
