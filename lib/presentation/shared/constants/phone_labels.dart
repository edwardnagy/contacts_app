import 'package:contacts_app/presentation/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';

List<String> getPredefinedPhoneLabels(BuildContext context) => [
      AppLocalizations.of(context).labelMobile,
      AppLocalizations.of(context).labelHome,
      AppLocalizations.of(context).labelWork,
      AppLocalizations.of(context).labelOther,
    ];
