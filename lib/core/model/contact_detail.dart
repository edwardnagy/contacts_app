import 'package:contacts_app/core/model/address.dart';
import 'package:contacts_app/core/model/phone_number.dart';
import 'package:meta/meta.dart';

@immutable
final class ContactDetail {
  final String id;
  final String firstName;
  final String lastName;
  final List<PhoneNumber> phoneNumbers;
  final List<Address> addresses;

  const ContactDetail({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumbers,
    required this.addresses,
  });
}
