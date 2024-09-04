part of 'contact_list_bloc.dart';

sealed class ContactListEvent with EquatableMixin {
  const ContactListEvent();

  @override
  List<Object> get props => [];
}

final class ContactListRequested extends ContactListEvent {
  const ContactListRequested({this.searchQuery = ''});

  final String searchQuery;

  @override
  List<Object> get props => [searchQuery];
}
