import 'package:contacts_app/data/contact_local_source.dart';
import 'package:contacts_app/data/objectbox/contact_box_dao.dart';
import 'package:contacts_app/data/objectbox/contact_metadata_box_dao.dart';
import 'package:contacts_app/objectbox/object_box.dart';
import 'package:contacts_app/objectbox/objectbox.g.dart';
import 'package:contacts_app/repository/contact_repository.dart';
import 'package:logger/logger.dart';

/// A simple dependency injection container.
class SimpleDi {
  const SimpleDi._();

  static Logger get logger => Logger();

  static Store get store => ObjectBox.instance.store;

  static ContactBoxDao get contactBoxDao => ContactBoxDao(store);
  static ContactMetadataBoxDao get contactMetadataBoxDao =>
      ContactMetadataBoxDao(store);

  static ContactLocalSource get contactLocalSource =>
      ContactLocalSource(store, contactBoxDao, contactMetadataBoxDao);

  static final ContactRepository contactRepository =
      ContactRepository(logger, contactLocalSource);
}
