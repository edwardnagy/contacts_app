import 'package:contacts_app/core/data/objectbox/objectbox.dart';
import 'package:contacts_app/presentation/app_widget.dart';
import 'package:contacts_app/presentation/shared/logger_bloc_observer.dart';
import 'package:contacts_app/simple_di.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ObjectBox.initialize();
  SimpleDi.instance.initialize();
  EquatableConfig.stringify = true;
  Bloc.observer = LoggerBlocObserver();

  runApp(const AppWidget());
}
