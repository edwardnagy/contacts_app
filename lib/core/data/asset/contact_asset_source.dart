import 'dart:convert';

import 'package:contacts_app/core/data/asset/contact_asset_dto_mappers.dart';
import 'package:contacts_app/core/data/asset/dto/contacts_asset_dto.dart';
import 'package:contacts_app/core/model/contact_create.dart';
import 'package:flutter/services.dart';

class ContactAssetSource {
  static const _initialContactsAssetPath = 'assets/initial_contacts.json';

  Future<List<ContactCreate>> getInitialContacts() async {
    final jsonString = await rootBundle.loadString(_initialContactsAssetPath);
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    final contactsAssets = ContactsAssetDto.fromJson(json).contacts;
    final contacts =
        contactsAssets.map((contact) => contact.toContactCreate()).toList();
    return contacts;
  }
}
