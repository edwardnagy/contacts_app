import 'package:contacts_app/model/contact_sort_field_type.dart';
import 'package:flutter/foundation.dart';

@immutable
class ContactSummary {
  final String id;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;

  /// The field used when this contact was sorted.
  final ContactSortFieldType? sortFieldType;

  const ContactSummary({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.sortFieldType,
  });
}
