import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
final class PhoneNumber with EquatableMixin {
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

  @override
  List<Object?> get props => [number, label];
}
