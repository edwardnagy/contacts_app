import 'package:contacts_app/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';

List<String> getPredefinedPhoneLabels(BuildContext context) => [
      AppLocalizations.of(context).phoneLabelMobile,
      AppLocalizations.of(context).phoneLabelHome,
      AppLocalizations.of(context).phoneLabelWork,
      AppLocalizations.of(context).phoneLabelOther,
    ];
