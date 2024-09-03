part of 'contact_list_bloc.dart';

enum ContactListStatus { idle, loading, success, failure }

final class ContactListState with EquatableMixin {
  const ContactListState({
    this.status = ContactListStatus.idle,
    this.contacts = const <ContactSummary>[],
  });

  final ContactListStatus status;
  final List<ContactSummary> contacts;

  ContactListState copyWith({
    ContactListStatus? status,
    List<ContactSummary>? contacts,
  }) {
    return ContactListState(
      status: status ?? this.status,
      contacts: contacts ?? this.contacts,
    );
  }

  @override
  List<Object> get props => [status, contacts];
}
