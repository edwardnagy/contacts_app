part of 'contact_editing_bloc.dart';

sealed class ContactEditingEvent extends Equatable {
  const ContactEditingEvent();

  @override
  List<Object?> get props => [];
}

final class ContactEditingExistingDataRequested extends ContactEditingEvent {
  const ContactEditingExistingDataRequested();
}

final class ContactEditingFirstNameChanged extends ContactEditingEvent {
  const ContactEditingFirstNameChanged(this.firstName);

  final String firstName;

  @override
  List<Object> get props => [firstName];
}

final class ContactEditingLastNameChanged extends ContactEditingEvent {
  const ContactEditingLastNameChanged(this.lastName);

  final String lastName;

  @override
  List<Object> get props => [lastName];
}

final class ContactEditingPhoneNumbersChanged extends ContactEditingEvent {
  const ContactEditingPhoneNumbersChanged(this.phoneNumbers);

  final List<PhoneNumber> phoneNumbers;

  @override
  List<Object> get props => [phoneNumbers];
}

final class ContactEditingAddressesChanged extends ContactEditingEvent {
  const ContactEditingAddressesChanged(this.addresses);

  final List<Address> addresses;

  @override
  List<Object> get props => [addresses];
}

final class ContactEditingSaveRequested extends ContactEditingEvent {
  const ContactEditingSaveRequested();
}

final class ContactEditingDeleteRequested extends ContactEditingEvent {
  const ContactEditingDeleteRequested();
}
