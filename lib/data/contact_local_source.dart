import 'package:collection/collection.dart';
import 'package:contacts_app/data/contact_mappers.dart';
import 'package:contacts_app/data/objectbox/contact_box_dao.dart';
import 'package:contacts_app/data/objectbox/contact_metadata_box_dao.dart';
import 'package:contacts_app/data/objectbox/entity/contact_entity.dart';
import 'package:contacts_app/data/objectbox/entity/contact_metadata_entity.dart';
import 'package:contacts_app/model/contact_create.dart';
import 'package:contacts_app/model/contact_detail.dart';
import 'package:contacts_app/model/contact_sort_field_type.dart';
import 'package:contacts_app/model/contact_summary.dart';
import 'package:objectbox/objectbox.dart';

class ContactLocalSource {
  final Store _store;
  final ContactBoxDao _contactBoxDao;
  final ContactMetadataBoxDao _contactMetadataBoxDao;

  ContactLocalSource(
    this._store,
    this._contactBoxDao,
    this._contactMetadataBoxDao,
  );

  Future<bool> isInitialContactsAdded() {
    final contactMetadata = _contactMetadataBoxDao.getContactMetadata();
    final isAdded = contactMetadata?.isInitialContactsAdded == true;
    return Future.value(isAdded);
  }

  Future<void> addInitialContacts(List<ContactCreate> contacts) {
    void saveInitialContactsTransaction() {
      final contactEntities =
          contacts.map((contact) => contact.toEntity()).toList();
      _contactBoxDao.saveContacts(contactEntities);

      final contactMetadata =
          ContactMetadataEntity(isInitialContactsAdded: true);
      _contactMetadataBoxDao.saveContactMetadata(contactMetadata);
    }

    _store.runInTransaction(TxMode.write, saveInitialContactsTransaction);
    return Future.value();
  }

  /// The contacts are sorted by the first non-empty sort field found for each
  /// contact, based on the provided field types in [sortFieldTypes].
  ///
  /// Contacts without a sort field will be placed at the end of the list.
  Stream<List<ContactSummary>> watchContacts({
    required List<ContactSortFieldType> sortFieldTypes,
  }) {
    return _contactBoxDao.watchContacts().map((contactEntities) {
      // Map each contact's ID to the first non-empty sort field
      final sortFieldByContactId = <int, _ContactSortField?>{
        for (var contactEntity in contactEntities)
          contactEntity.id: sortFieldTypes
              .map((fieldType) => (
                    type: fieldType,
                    value: contactEntity.getSortField(fieldType) ?? '',
                  ))
              .firstWhereOrNull(
                  (sortField) => sortField.value.trim().isNotEmpty),
      };

      // Sort the contact entities based on the sort fields
      final sortedEntities = contactEntities.sorted((a, b) {
        final aSortField = sortFieldByContactId[a.id];
        final bSortField = sortFieldByContactId[b.id];

        // Contacts without a sort field will be placed at the end of the list
        if (aSortField == null) return 1;
        if (bSortField == null) return -1;

        // Next, contacts with only a phone number will be placed at the end
        if (aSortField.type == ContactSortFieldType.phoneNumber) return 1;
        if (bSortField.type == ContactSortFieldType.phoneNumber) return -1;

        return aSortField.value.compareTo(bSortField.value);
      });

      // Map sorted entities to summaries
      final summaries = sortedEntities
          .map((contactEntity) => contactEntity.toSummary(
                sortFieldType: sortFieldByContactId[contactEntity.id]?.type,
              ))
          .toList();

      return summaries;
    });
  }

  Stream<ContactDetail> watchContactDetail(String contactId) {
    return _contactBoxDao
        .watchContactDetail(contactId)
        .map((contactEntity) => contactEntity.toDetail());
  }
}

typedef _ContactSortField = ({ContactSortFieldType type, String value});

extension on ContactEntity {
  String? getSortField(ContactSortFieldType sortField) => switch (sortField) {
        ContactSortFieldType.firstName => firstName,
        ContactSortFieldType.lastName => lastName,
        ContactSortFieldType.phoneNumber => phoneNumbers.firstOrNull?.number
      };
}
