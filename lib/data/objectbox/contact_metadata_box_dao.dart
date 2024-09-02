import 'package:contacts_app/data/objectbox/entity/contact_metadata_entity.dart';
import 'package:objectbox/objectbox.dart';

class ContactMetadataBoxDao {
  final Store _store;
  Box<ContactMetadataEntity> get _contactMetadataBox => _store.box();

  ContactMetadataBoxDao(this._store);

  ContactMetadataEntity? getContactMetadata() {
    return _contactMetadataBox.getAll().firstOrNull;
  }

  void saveContactMetadata(ContactMetadataEntity contactMetadata) {
    _store.runInTransaction(TxMode.write, () {
      _contactMetadataBox
        ..removeAll()
        ..put(contactMetadata);
    });
  }
}
