import 'package:contacts_app/presentation/l10n/app_localizations.dart';
import 'package:contacts_app/presentation/router/routes.dart';
import 'package:contacts_app/presentation/shared/contact_data_form/contact_data_form.dart';
import 'package:flutter/cupertino.dart';

class ContactCreationScreen extends StatelessWidget {
  const ContactCreationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const didInsertContactData = false;
    return CupertinoPageScaffold(
      backgroundColor:
          CupertinoColors.systemGroupedBackground.resolveFrom(context),
      navigationBar: CupertinoNavigationBar(
        middle: Text(AppLocalizations.of(context).newContact),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            Navigator.of(context).maybePop();
          },
          child: Text(AppLocalizations.of(context).cancel),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: didInsertContactData
              ? () {
                  const newContactId =
                      'newContactId'; // TODO: get new contact ID
                  const ContactDetailRoute(
                    contactId: newContactId,
                    firstName: null,
                    lastName: null,
                  ).go(context);
                }
              : null,
          child: Text(AppLocalizations.of(context).done),
        ),
      ),
      child: ContactDataForm(
        autofocus: true,
        firstName: '',
        onFirstNameChanged: (value) {}, // TODO: onFirstNameChanged
        lastName: '',
        onLastNameChanged: (value) {}, // TODO: onLastNameChanged
        phoneNumbers: const [],
        onPhoneNumbersChanged: (value) {}, // TODO: onPhoneNumbersChanged
        addresses: const [],
        onAddressesChanged: (value) {}, // TODO: onAddressesChanged
      ),
    );
  }
}
