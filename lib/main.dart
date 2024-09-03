import 'package:contacts_app/core/data/objectbox/objectbox.dart';
import 'package:contacts_app/presentation/l10n/app_localizations.dart';
import 'package:contacts_app/presentation/router/router.dart';
import 'package:contacts_app/simple_di.dart';
import 'package:flutter/cupertino.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ObjectBox.initialize();
  SimpleDi.instance.initialize();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp.router(
      routerConfig: appRouter,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
