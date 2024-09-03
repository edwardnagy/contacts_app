import 'package:contacts_app/presentation/l10n/app_localizations.dart';
import 'package:contacts_app/presentation/router/router.dart';
import 'package:flutter/cupertino.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp.router(
      routerConfig: appRouter,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
