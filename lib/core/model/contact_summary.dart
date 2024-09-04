import 'package:contacts_app/core/model/contact_sort_field_type.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
final class ContactSummary with EquatableMixin {
  final String id;
  final String firstName;
  final String lastName;
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

  @override
  List<Object?> get props =>
      [id, firstName, lastName, phoneNumber, sortFieldType];
}
