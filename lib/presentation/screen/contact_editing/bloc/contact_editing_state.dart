part of 'contact_editing_bloc.dart';

@immutable
final class ContactEditingState with EquatableMixin {
  const ContactEditingState({
    required this.loadStatus,
    required this.initialFirstName,
    required this.firstName,
    required this.initialLastName,
    required this.lastName,
    required this.initialPhoneNumbers,
    required this.phoneNumbers,
    required this.initialAddresses,
    required this.addresses,
    required this.updateStatus,
    required this.deletionStatus,
  });

  const ContactEditingState.initial()
      : loadStatus = ContactLoadStatus.initial,
        initialFirstName = '',
        firstName = '',
        initialLastName = '',
        lastName = '',
        initialPhoneNumbers = const [],
        phoneNumbers = const [],
        initialAddresses = const [],
        addresses = const [],
        updateStatus = ContactUpdateStatus.initial,
        deletionStatus = ContactDeletionStatus.initial;

  /// The status of the contact loading process (initial data).
  final ContactLoadStatus loadStatus;
  final String initialFirstName;
  final String firstName;
  final String initialLastName;
  final String lastName;
  final List<PhoneNumber> initialPhoneNumbers;
  final List<PhoneNumber> phoneNumbers;
  final List<Address> initialAddresses;
  final List<Address> addresses;
  final ContactUpdateStatus updateStatus;
  final ContactDeletionStatus deletionStatus;

  bool get _isAnyChangeMade {
    return initialFirstName != firstName ||
        initialLastName != lastName ||
        !const ListEquality().equals(initialPhoneNumbers, phoneNumbers) ||
        !const ListEquality().equals(initialAddresses, addresses);
  }

  bool get _isAnyFieldFilled {
    return firstName.isNotEmpty ||
        lastName.isNotEmpty ||
        phoneNumbers.any((phoneNumber) => phoneNumber.isNotEmpty) ||
        addresses.any((address) => address.isNotEmpty);
  }

  bool get isSavingEnabled => _isAnyChangeMade && _isAnyFieldFilled;

  ContactEditingState copyWith({
    ContactLoadStatus? loadStatus,
    String? initialFirstName,
    String? firstName,
    String? initialLastName,
    String? lastName,
    List<PhoneNumber>? initialPhoneNumbers,
    List<PhoneNumber>? phoneNumbers,
    List<Address>? initialAddresses,
    List<Address>? addresses,
    ContactUpdateStatus? updateStatus,
    ContactDeletionStatus? deletionStatus,
  }) {
    return ContactEditingState(
      loadStatus: loadStatus ?? this.loadStatus,
      initialFirstName: initialFirstName ?? this.initialFirstName,
      firstName: firstName ?? this.firstName,
      initialLastName: initialLastName ?? this.initialLastName,
      lastName: lastName ?? this.lastName,
      initialPhoneNumbers: initialPhoneNumbers ?? this.initialPhoneNumbers,
      phoneNumbers: phoneNumbers ?? this.phoneNumbers,
      initialAddresses: initialAddresses ?? this.initialAddresses,
      addresses: addresses ?? this.addresses,
      updateStatus: updateStatus ?? this.updateStatus,
      deletionStatus: deletionStatus ?? this.deletionStatus,
    );
  }

  @override
  List<Object> get props => [
        loadStatus,
        initialFirstName,
        firstName,
        initialLastName,
        lastName,
        initialPhoneNumbers,
        phoneNumbers,
        initialAddresses,
        addresses,
        updateStatus,
        deletionStatus,
      ];
}

enum ContactLoadStatus { initial, inProgress, success, failure }

enum ContactUpdateStatus { initial, inProgress, success, failure }

enum ContactDeletionStatus { initial, inProgress, success, failure }
