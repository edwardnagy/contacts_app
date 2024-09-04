part of 'contact_creation_bloc.dart';

@immutable
sealed class ContactCreationEvent with EquatableMixin {
  const ContactCreationEvent();
}

final class ContactCreationFirstNameChanged extends ContactCreationEvent {
  const ContactCreationFirstNameChanged(this.firstName);

  final String firstName;

  @override
  List<Object> get props => [firstName];
}

final class ContactCreationLastNameChanged extends ContactCreationEvent {
  const ContactCreationLastNameChanged(this.lastName);

  final String lastName;

  @override
  List<Object> get props => [lastName];
}

final class ContactCreationPhoneNumbersChanged extends ContactCreationEvent {
  const ContactCreationPhoneNumbersChanged(this.phoneNumbers);

  final List<PhoneNumber> phoneNumbers;

  @override
  List<Object> get props => [phoneNumbers];
}

final class ContactCreationAddressesChanged extends ContactCreationEvent {
  const ContactCreationAddressesChanged(this.addresses);

  final List<Address> addresses;

  @override
  List<Object> get props => [addresses];
}

final class ContactCreationSaveRequested extends ContactCreationEvent {
  const ContactCreationSaveRequested();

  @override
  List<Object?> get props => [];
}
