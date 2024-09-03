import 'package:contacts_app/core/data/asset/dto/contact_asset_dto.dart';
import 'package:meta/meta.dart';

@immutable
class ContactsAssetDto {
  final List<ContactAssetDto> contacts;

  const ContactsAssetDto({required this.contacts});

  factory ContactsAssetDto.fromJson(Map<String, dynamic> json) {
    return ContactsAssetDto(
      contacts: (json['contacts'] as List<dynamic>)
          .map((contactDto) =>
              ContactAssetDto.fromJson(contactDto as Map<String, dynamic>))
          .toList(),
    );
  }
}
