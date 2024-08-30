import 'package:contacts_app/model/contact_sort_field.dart';
import 'package:flutter/foundation.dart';

@immutable
class ContactSummary {
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;

  /// The field used when this contact was sorted.
  final ContactSortField? sortedField;

  const ContactSummary({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.sortedField,
  });
}
