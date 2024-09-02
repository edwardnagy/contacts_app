import 'package:contacts_app/core/model/address.dart';
import 'package:contacts_app/core/model/phone_number.dart';
import 'package:flutter/foundation.dart';

@immutable
class ContactCreate {
  final String? firstName;
  final String? lastName;
  final List<PhoneNumber>? phoneNumbers;
  final List<Address>? addresses;

  const ContactCreate({
    required this.firstName,
    required this.lastName,
    required this.phoneNumbers,
    required this.addresses,
  });
}
