import 'package:contacts_app/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';

class NewContactScreen extends StatelessWidget {
  const NewContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          AppLocalizations.of(context).newContact,
        ),
      ),
      child: const Placeholder(),
    );
  }
}
