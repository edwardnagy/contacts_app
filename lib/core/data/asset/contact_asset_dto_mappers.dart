import 'package:contacts_app/core/data/asset/dto/address_asset_dto.dart';
import 'package:contacts_app/core/data/asset/dto/contact_asset_dto.dart';
import 'package:contacts_app/core/data/asset/dto/phone_number_asset_dto.dart';
import 'package:contacts_app/core/model/address.dart';
import 'package:contacts_app/core/model/contact_create.dart';
import 'package:contacts_app/core/model/phone_number.dart';

extension ContactAssetDtoMappers on ContactAssetDto {
  ContactCreate toContactCreate() {
    return ContactCreate(
      firstName: firstName,
      lastName: lastName,
      phoneNumbers: phoneNumbers
          .map((phoneNumber) => phoneNumber.toPhoneNumber())
          .toList(),
      addresses: addresses.map((address) => address.toAddress()).toList(),
    );
  }
}

extension on PhoneNumberAssetDto {
  PhoneNumber toPhoneNumber() {
    return PhoneNumber(
      number: number,
      label: label,
    );
  }
}

extension on AddressAssetDto {
  Address toAddress() {
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
