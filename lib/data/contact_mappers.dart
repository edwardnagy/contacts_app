import 'package:contacts_app/data/objectbox/entity/address_entity.dart';
import 'package:contacts_app/data/objectbox/entity/contact_entity.dart';
import 'package:contacts_app/data/objectbox/entity/phone_number_entity.dart';
import 'package:contacts_app/model/contact_create.dart';
import 'package:contacts_app/model/contact_sort_field_type.dart';
import 'package:contacts_app/model/contact_summary.dart';
import 'package:uuid/uuid.dart';

extension ContactEntityMapper on ContactEntity {
  ContactSummary toSummary({required ContactSortFieldType? sortFieldType}) {
    return ContactSummary(
      id: guid,
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phoneNumbers.firstOrNull?.number,
      sortFieldType: sortFieldType,
    );
  }
}

extension ContactCreateMappers on ContactCreate {
  ContactEntity toEntity() {
    final guid = const Uuid().v4();
    final contactEntity = ContactEntity(
      guid: guid,
      firstName: firstName,
      lastName: lastName,
    );

    if (phoneNumbers case final phoneNumbers?) {
      final phoneNumberEntities = phoneNumbers.map((phoneNumber) {
        return PhoneNumberEntity(
          number: phoneNumber.number,
          label: phoneNumber.label,
        )..contact.target = contactEntity;
      }).toList();
      contactEntity.phoneNumbers.addAll(phoneNumberEntities);
    }

    if (addresses case final addresses?) {
      final addressEntities = addresses.map((address) {
        return AddressEntity(
          street1: address.street1,
          street2: address.street2,
          city: address.city,
          state: address.state,
          zipCode: address.zipCode,
          label: address.label,
        )..contact.target = contactEntity;
      }).toList();
      contactEntity.addresses.addAll(addressEntities);
    }

    return contactEntity;
  }
}
