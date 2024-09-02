import 'package:contacts_app/model/address.dart';
import 'package:contacts_app/model/phone_number.dart';
import 'package:flutter/foundation.dart';

@immutable
class ContactDetail {
  final String id;
  final String? firstName;
  final String? lastName;
  final List<PhoneNumber>? phoneNumbers;
  final List<Address>? addresses;

  const ContactDetail({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumbers,
    required this.addresses,
  });
}
