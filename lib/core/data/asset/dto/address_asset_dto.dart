import 'package:meta/meta.dart';

@immutable
final class AddressAssetDto {
  final String street1;
  final String street2;
  final String city;
  final String state;
  final String zipCode;
  final String label;

  const AddressAssetDto({
    required this.street1,
    required this.street2,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.label,
  });

  factory AddressAssetDto.fromJson(Map<String, dynamic> json) {
    return AddressAssetDto(
      street1: json['street1'] as String,
      street2: json['street2'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      zipCode: json['zipCode'] as String,
      label: json['label'] as String,
    );
  }
}
