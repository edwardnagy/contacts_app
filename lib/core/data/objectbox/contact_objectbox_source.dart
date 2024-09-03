import 'package:collection/collection.dart';
import 'package:contacts_app/core/data/objectbox/contact_objectbox_mappers.dart';
import 'package:contacts_app/core/data/objectbox/entity/address_entity.dart';
import 'package:contacts_app/core/data/objectbox/entity/contact_entity.dart';
import 'package:contacts_app/core/data/objectbox/entity/contact_metadata_entity.dart';
import 'package:contacts_app/core/data/objectbox/entity/phone_number_entity.dart';
import 'package:contacts_app/core/data/objectbox/generated/objectbox.g.dart';
import 'package:contacts_app/core/model/contact_create.dart';
import 'package:contacts_app/core/model/contact_detail.dart';
import 'package:contacts_app/core/model/contact_sort_field_type.dart';
import 'package:contacts_app/core/model/contact_summary.dart';
import 'package:contacts_app/core/model/contact_update.dart';
import 'package:uuid/uuid.dart';

final class ContactObjectboxSource {
  final Store _store;

  Box<ContactEntity> get _contactBox => _store.box();
  Box<ContactMetadataEntity> get _contactMetadataBox => _store.box();
  Box<PhoneNumberEntity> get _phoneNumberBox => _store.box();
  Box<AddressEntity> get _addressBox => _store.box();

  ContactObjectboxSource(
    this._store,
  );

  Future<bool> isInitialContactsAdded() async {
    final contactMetadata = _contactMetadataBox.getAll().firstOrNull;
    final isAdded = contactMetadata?.isInitialContactsAdded == true;
    return isAdded;
  }

  Future<void> addInitialContacts(List<ContactCreate> contacts) async {
    void saveInitialContactsTransaction() {
      // Save the contacts
      final contactEntities = contacts
          .map((contact) => contact.toEntity(guid: const Uuid().v4()))
          .toList();
      _contactBox.putMany(contactEntities);
      // Update the metadata
      final contactMetadata =
          ContactMetadataEntity(isInitialContactsAdded: true);
      _contactMetadataBox
        ..removeAll()
        ..put(contactMetadata);
    }

    _store.runInTransaction(TxMode.write, saveInitialContactsTransaction);
  }

  /// The contacts are sorted by the first non-empty sort field found for each
  /// contact, based on the provided field types in [sortFieldTypes].
  ///
  /// Contacts without a sort field will be placed at the end of the list.
  Stream<List<ContactSummary>> watchContacts({
    required List<ContactSortFieldType> sortFieldTypes,
  }) {
    return _contactBox
        .query()
        .watch(triggerImmediately: true)
        .map((query) => query.find())
        .map((contactEntities) {
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

  Future<ContactDetail> getContact(String id) async {
    final contactEntity =
        _contactBox.query(ContactEntity_.guid.equals(id)).build().findFirst()!;

    final contactDetail = contactEntity.toDetail();
    return contactDetail;
  }

  Stream<ContactDetail> watchContactDetail(String contactId) {
    return _contactBox
        .query(ContactEntity_.guid.equals(contactId))
        .watch(triggerImmediately: true)
        .map((query) => query.findFirst()!)
        .map((contactEntity) => contactEntity.toDetail());
  }

  Future<String> createContact(ContactCreate contact) async {
    final guid = const Uuid().v4();
    final contactEntity = contact.toEntity(guid: guid);
    _contactBox.put(contactEntity);
    return guid;
  }

  Future<void> updateContact(ContactUpdate updatedContact) async {
    final contactEntity = _contactBox
        .query(ContactEntity_.guid.equals(updatedContact.id))
        .build()
        .findFirst()!;

    void updateContactTransaction() {
      // Replace the existing phone numbers and addresses with the updated ones
      final phoneNumberIdsToDelete =
          contactEntity.phoneNumbers.map((e) => e.id).toList();
      _phoneNumberBox.removeMany(phoneNumberIdsToDelete);
      final newPhoneNumberEntities = updatedContact.phoneNumbers
          .map((phoneNumber) => phoneNumber.toEntity(contactEntity))
          .toList();
      _phoneNumberBox.putMany(newPhoneNumberEntities);

      final addressIdsToDelete =
          contactEntity.addresses.map((e) => e.id).toList();
      _addressBox.removeMany(addressIdsToDelete);
      final newAddressEntities = updatedContact.addresses
          .map((address) => address.toEntity(contactEntity))
          .toList();
      _addressBox.putMany(newAddressEntities);

      contactEntity
        ..firstName = updatedContact.firstName
        ..lastName = updatedContact.lastName
        ..phoneNumbers.addAll(newPhoneNumberEntities)
        ..addresses.addAll(newAddressEntities);
      _contactBox.put(contactEntity, mode: PutMode.update);
    }

    _store.runInTransaction(TxMode.write, updateContactTransaction);
  }

  Future<void> deleteContact(String contactId) async {
    final contactEntity = _contactBox
        .query(ContactEntity_.guid.equals(contactId))
        .build()
        .findFirst()!;

    void deleteContactAndRelatedEntitiesTransaction() {
      final phoneNumberIdsToDelete =
          contactEntity.phoneNumbers.map((e) => e.id).toList();
      _phoneNumberBox.removeMany(phoneNumberIdsToDelete);
      final addressIdsToDelete =
          contactEntity.addresses.map((e) => e.id).toList();
      _addressBox.removeMany(addressIdsToDelete);
      _contactBox.remove(contactEntity.id);
    }

    _store.runInTransaction(
      TxMode.write,
      deleteContactAndRelatedEntitiesTransaction,
    );
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
