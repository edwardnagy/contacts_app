part of 'contact_list_bloc.dart';

final class ContactListState with EquatableMixin {
  const ContactListState({
    this.loadStatus = ContactListStatus.idle,
    this.contacts = const <ContactSummary>[],
  });

  final ContactListStatus loadStatus;
  final List<ContactSummary> contacts;

  ContactListState copyWith({
    ContactListStatus? loadStatus,
    List<ContactSummary>? contacts,
  }) {
    return ContactListState(
      loadStatus: loadStatus ?? this.loadStatus,
      contacts: contacts ?? this.contacts,
    );
  }

  @override
  List<Object> get props => [loadStatus, contacts];
}

enum ContactListStatus { idle, loading, success, failure }
