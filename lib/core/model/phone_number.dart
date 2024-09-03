import 'package:meta/meta.dart';

@immutable
class PhoneNumber {
  final String number;
  final String label;

  const PhoneNumber({
    required this.number,
    required this.label,
  });

  PhoneNumber copyWith({
    String? number,
    String? label,
  }) {
    return PhoneNumber(
      number: number ?? this.number,
      label: label ?? this.label,
    );
  }
}
