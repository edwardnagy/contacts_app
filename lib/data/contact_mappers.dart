import 'package:contacts_app/data/objectbox/entity/address_entity.dart';
import 'package:contacts_app/data/objectbox/entity/contact_entity.dart';
import 'package:contacts_app/data/objectbox/entity/phone_number_entity.dart';
import 'package:contacts_app/model/address.dart';
import 'package:contacts_app/model/contact_create.dart';
import 'package:contacts_app/model/contact_detail.dart';
import 'package:contacts_app/model/contact_sort_field_type.dart';
import 'package:contacts_app/model/contact_summary.dart';
import 'package:contacts_app/model/phone_number.dart';
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

  ContactDetail toDetail() {
    return ContactDetail(
      id: guid,
      firstName: firstName,
      lastName: lastName,
      phoneNumbers:
          phoneNumbers.map((phoneNumber) => phoneNumber.toModel()).toList(),
      addresses: addresses.map((address) => address.toModel()).toList(),
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
      final phoneNumberEntities = phoneNumbers
          .map((phoneNumber) => phoneNumber.toEntity(contactEntity))
          .toList();
      contactEntity.phoneNumbers.addAll(phoneNumberEntities);
    }

    if (addresses case final addresses?) {
      final addressEntities =
          addresses.map((address) => address.toEntity(contactEntity)).toList();
      contactEntity.addresses.addAll(addressEntities);
    }

    return contactEntity;
  }
}

extension on PhoneNumberEntity {
  PhoneNumber toModel() {
    return PhoneNumber(
      number: number,
      label: label,
    );
  }
}

extension on AddressEntity {
  Address toModel() {
    return Address(
      street1: street1,
      street2: street2,
      city: city,
      state: state,
      zipCode: zipCode,
      label: label,
    );
  }
}

extension on PhoneNumber {
  PhoneNumberEntity toEntity(ContactEntity contactEntity) {
    return PhoneNumberEntity(
      number: number,
      label: label,
    )..contact.target = contactEntity;
  }
}

extension on Address {
  AddressEntity toEntity(ContactEntity contactEntity) {
    return AddressEntity(
      street1: street1,
      street2: street2,
      city: city,
      state: state,
      zipCode: zipCode,
      label: label,
    )..contact.target = contactEntity;
  }
}
