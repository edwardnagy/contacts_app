import 'package:meta/meta.dart';

@immutable
final class PhoneNumberAssetDto {
  final String number;
  final String label;

  const PhoneNumberAssetDto({
    required this.number,
    required this.label,
  });

  factory PhoneNumberAssetDto.fromJson(Map<String, dynamic> json) {
    return PhoneNumberAssetDto(
      number: json['number'] as String,
      label: json['label'] as String,
    );
  }
}
