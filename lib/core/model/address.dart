import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
final class Address with EquatableMixin {
  final String street1;
  final String street2;
  final String city;
  final String state;
  final String zipCode;
  final String label;

  const Address({
    required this.street1,
    required this.street2,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.label,
  });

  const Address.empty({
    required this.label,
  })  : street1 = '',
        street2 = '',
        city = '',
        state = '',
        zipCode = '';

  Address copyWith({
    String? street1,
    String? street2,
    String? city,
    String? state,
    String? zipCode,
    String? label,
  }) {
    return Address(
      street1: street1 ?? this.street1,
      street2: street2 ?? this.street2,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      label: label ?? this.label,
    );
  }

  @override
  List<Object?> get props => [street1, street2, city, state, zipCode, label];
}
