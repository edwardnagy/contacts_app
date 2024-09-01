import 'package:contacts_app/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';

List<String> getPredefinedAddressLabels(BuildContext context) => [
      AppLocalizations.of(context).labelHome,
      AppLocalizations.of(context).labelWork,
      AppLocalizations.of(context).labelOther,
    ];
