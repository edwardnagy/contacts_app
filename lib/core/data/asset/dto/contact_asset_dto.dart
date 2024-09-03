import 'package:contacts_app/core/data/asset/dto/address_asset_dto.dart';
import 'package:contacts_app/core/data/asset/dto/phone_number_asset_dto.dart';
import 'package:meta/meta.dart';

@immutable
final class ContactAssetDto {
  final String firstName;
  final String lastName;
  final List<PhoneNumberAssetDto> phoneNumbers;
  final List<AddressAssetDto> addresses;

  const ContactAssetDto({
    required this.firstName,
    required this.lastName,
    required this.phoneNumbers,
    required this.addresses,
  });

  factory ContactAssetDto.fromJson(Map<String, dynamic> json) {
    return ContactAssetDto(
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      phoneNumbers: (json['phoneNumbers'] as List<dynamic>)
          .map((phoneNumberDto) => PhoneNumberAssetDto.fromJson(
              phoneNumberDto as Map<String, dynamic>))
          .toList(),
      addresses: (json['addresses'] as List<dynamic>)
          .map((addressDto) =>
              AddressAssetDto.fromJson(addressDto as Map<String, dynamic>))
          .toList(),
    );
  }
}
