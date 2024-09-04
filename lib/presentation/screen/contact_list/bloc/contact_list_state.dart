part of 'contact_list_bloc.dart';

final class ContactListState with EquatableMixin {
  const ContactListState({
    this.loadStatus = ContactListStatus.idle,
    this.contacts = const <ContactSummary>[],
    this.searchQuery = '',
  });

  final ContactListStatus loadStatus;
  final List<ContactSummary> contacts;
  final String searchQuery;

  ContactListState copyWith({
    ContactListStatus? loadStatus,
    List<ContactSummary>? contacts,
    String? searchQuery,
  }) {
    return ContactListState(
      loadStatus: loadStatus ?? this.loadStatus,
      contacts: contacts ?? this.contacts,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object> get props => [loadStatus, contacts, searchQuery];
}

enum ContactListStatus { idle, loading, success, failure }
