import 'package:contacts_app/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';

class ContactListScreen extends StatelessWidget {
  const ContactListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          AppLocalizations.of(context).contacts,
        ),
      ),
      child: const Placeholder(),
    );
  }
}
