import 'package:contacts_app/core/data/objectbox/contact_objectbox_source.dart';
import 'package:contacts_app/core/data/objectbox/generated/objectbox.g.dart';
import 'package:contacts_app/core/data/objectbox/objectbox.dart';
import 'package:contacts_app/core/repository/contact_repository.dart';
import 'package:logger/logger.dart';

/// A simple dependency injection container.
class SimpleDi {
  const SimpleDi._();

  static Logger get logger => Logger();

  static Store get store => ObjectBox.instance.store;

  static ContactObjectboxSource get contactLocalSource =>
      ContactObjectboxSource(store);

  static final ContactRepository contactRepository =
      ContactRepository(logger, contactLocalSource);
}
