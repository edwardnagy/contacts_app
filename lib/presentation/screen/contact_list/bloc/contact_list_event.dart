part of 'contact_list_bloc.dart';

sealed class ContactListEvent with EquatableMixin {
  const ContactListEvent();

  @override
  List<Object> get props => [];
}

final class ContactListSubscriptionRequested extends ContactListEvent {
  const ContactListSubscriptionRequested();
}
