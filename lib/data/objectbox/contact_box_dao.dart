import 'package:contacts_app/data/objectbox/entity/contact_entity.dart';
import 'package:contacts_app/objectbox/objectbox.g.dart';

class ContactBoxDao {
  final Box<ContactEntity> _contactBox;

  ContactBoxDao(Store store) : _contactBox = store.box();

  Stream<List<ContactEntity>> watchContacts() {
    return _contactBox
        .query()
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  void saveContacts(List<ContactEntity> map) {
    _contactBox.putMany(map);
  }

  Stream<ContactEntity> watchContactDetail(String contactGuid) {
    return _contactBox
        .query(ContactEntity_.guid.equals(contactGuid))
        .watch(triggerImmediately: true)
        .map((query) => query.findFirst()!);
  }
}
