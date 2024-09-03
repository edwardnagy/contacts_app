import 'package:contacts_app/core/model/contact_sort_field_type.dart';
import 'package:meta/meta.dart';

@immutable
final class ContactSummary {
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
