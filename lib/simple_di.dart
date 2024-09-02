import 'package:contacts_app/core/data/contact_local_source.dart';
import 'package:contacts_app/core/data/objectbox/object_box.dart';
import 'package:contacts_app/core/data/objectbox/objectbox.g.dart';
import 'package:contacts_app/core/repository/contact_repository.dart';
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
