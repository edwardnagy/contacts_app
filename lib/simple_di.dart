import 'package:contacts_app/data/contact_local_source.dart';
import 'package:contacts_app/objectbox/object_box.dart';
import 'package:contacts_app/objectbox/objectbox.g.dart';
import 'package:contacts_app/repository/contact_repository.dart';
import 'package:logger/logger.dart';

/// A simple dependency injection container.
class SimpleDi {
  const SimpleDi._();

  static Logger get logger => Logger();

  static Store get store => ObjectBox.instance.store;

  static ContactLocalSource get contactLocalSource => ContactLocalSource(store);

  static final ContactRepository contactRepository =
      ContactRepository(logger, contactLocalSource);
}
