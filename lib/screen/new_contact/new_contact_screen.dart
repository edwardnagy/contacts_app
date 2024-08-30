import 'package:contacts_app/l10n/app_localizations.dart';
import 'package:contacts_app/shared/constants/spacing.dart';
import 'package:flutter/cupertino.dart';

class NewContactScreen extends StatefulWidget {
  const NewContactScreen({super.key});

  @override
  State<NewContactScreen> createState() => _NewContactScreenState();
}

class _NewContactScreenState extends State<NewContactScreen> {
  final _firstNameFocusNode = FocusNode();
  final _lastNameFocusNode = FocusNode();

  @override
  void dispose() {
    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor:
          CupertinoColors.systemGroupedBackground.resolveFrom(context),
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          AppLocalizations.of(context).newContact,
        ),
      ),
      child: ListView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          CupertinoListSection(
            hasLeading: false,
            children: [
              CupertinoTextFormFieldRow(
                padding: const EdgeInsets.symmetric(
                  vertical: 6.0, // 6.0 is the default vertical padding
                  horizontal: Spacing.firstKeyline,
                ),
                autofocus: true,
                focusNode: _firstNameFocusNode,
                placeholder: AppLocalizations.of(context).firstNamePlaceholder,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.unspecified,
                enableSuggestions: false,
                // On iOS, auto suggestions can only be disabled by disabling autocorrect.
                autocorrect: false,
                onFieldSubmitted: (_) => _lastNameFocusNode.requestFocus(),
              ),
              CupertinoTextFormFieldRow(
                padding: const EdgeInsets.symmetric(
                  vertical: 6.0, // 6.0 is the default vertical padding
                  horizontal: Spacing.firstKeyline,
                ),
                focusNode: _lastNameFocusNode,
                placeholder: AppLocalizations.of(context).lastNamePlaceholder,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.unspecified,
                enableSuggestions: false,
                // On iOS, auto suggestions can only be disabled by disabling autocorrect.
                autocorrect: false,
                // Imitate the iOS native Contacts app behavior by focusing on the initial field in the group
                onFieldSubmitted: (_) => _firstNameFocusNode.requestFocus(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
