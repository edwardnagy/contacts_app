part of 'contact_creation_bloc.dart';

@immutable
sealed class ContactCreationEvent with EquatableMixin {
  const ContactCreationEvent();
}

class ContactCreationFirstNameChanged extends ContactCreationEvent {
  const ContactCreationFirstNameChanged(this.firstName);

  final String firstName;

  @override
  List<Object> get props => [firstName];
}

class ContactCreationLastNameChanged extends ContactCreationEvent {
  const ContactCreationLastNameChanged(this.lastName);

  final String lastName;

  @override
  List<Object> get props => [lastName];
}

class ContactCreationPhoneNumbersChanged extends ContactCreationEvent {
  const ContactCreationPhoneNumbersChanged(this.phoneNumbers);

  final List<PhoneNumber> phoneNumbers;

  @override
  List<Object> get props => [phoneNumbers];
}

class ContactCreationAddressesChanged extends ContactCreationEvent {
  const ContactCreationAddressesChanged(this.addresses);

  final List<Address> addresses;

  @override
  List<Object> get props => [addresses];
}

class ContactCreationSaveRequested extends ContactCreationEvent {
  const ContactCreationSaveRequested();

  @override
  List<Object?> get props => [];
}
