part of 'contact_creation_bloc.dart';

@immutable
final class ContactCreationState with EquatableMixin {
  const ContactCreationState({
    required this.firstName,
    required this.lastName,
    required this.phoneNumbers,
    required this.addresses,
    required this.creationStatus,
  });

  const ContactCreationState.initial()
      : firstName = '',
        lastName = '',
        phoneNumbers = const [],
        addresses = const [],
        creationStatus = const ContactCreationInitial();

  final String firstName;
  final String lastName;
  final List<PhoneNumber> phoneNumbers;
  final List<Address> addresses;
  final ContactCreationStatus creationStatus;

  bool get isAnyFieldFilled =>
      firstName.isNotEmpty ||
      lastName.isNotEmpty ||
      phoneNumbers.any((phoneNumber) => phoneNumber.isNotEmpty) ||
      addresses.any((address) => address.isNotEmpty);

  ContactCreationState copyWith({
    String? firstName,
    String? lastName,
    List<PhoneNumber>? phoneNumbers,
    List<Address>? addresses,
    ContactCreationStatus? creationStatus,
  }) {
    return ContactCreationState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumbers: phoneNumbers ?? this.phoneNumbers,
      addresses: addresses ?? this.addresses,
      creationStatus: creationStatus ?? this.creationStatus,
    );
  }

  @override
  List<Object?> get props =>
      [firstName, lastName, phoneNumbers, addresses, creationStatus];
}

@immutable
sealed class ContactCreationStatus with EquatableMixin {
  const ContactCreationStatus();

  @override
  List<Object?> get props => [];
}

final class ContactCreationInitial extends ContactCreationStatus {
  const ContactCreationInitial();
}

final class ContactCreationInProgress extends ContactCreationStatus {
  const ContactCreationInProgress();
}

final class ContactCreationSuccess extends ContactCreationStatus {
  const ContactCreationSuccess({required this.contactId});

  final String contactId;

  @override
  List<Object?> get props => [contactId];
}

final class ContactCreationFailure extends ContactCreationStatus {
  const ContactCreationFailure(this.error);

  final Object error;

  @override
  List<Object?> get props => [error];
}
