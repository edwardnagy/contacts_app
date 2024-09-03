import 'package:contacts_app/core/data/asset/contact_asset_source.dart';
import 'package:contacts_app/core/data/objectbox/contact_objectbox_source.dart';
import 'package:contacts_app/core/data/objectbox/generated/objectbox.g.dart';
import 'package:contacts_app/core/data/objectbox/objectbox.dart';
import 'package:contacts_app/core/repository/contact_repository.dart';
import 'package:logger/logger.dart';

/// A simple dependency injection container.
class SimpleDi {
  SimpleDi._();

  static final instance = SimpleDi._();

  Future<void> initialize() async {
    await contactRepository.initialize();
  }

  Logger get logger => Logger();

  Store get store => ObjectBox.instance.store;
  ContactObjectboxSource get contactLocalSource =>
      ContactObjectboxSource(store);

  ContactAssetSource get contactAssetSource => ContactAssetSource();

  late final ContactRepository contactRepository =
      ContactRepository(logger, contactLocalSource, contactAssetSource);
}
