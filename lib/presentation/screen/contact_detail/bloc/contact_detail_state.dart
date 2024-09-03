part of 'contact_detail_bloc.dart';

sealed class ContactDetailState extends Equatable {
  const ContactDetailState();

  @override
  List<Object> get props => [];
}

final class ContactDetailInitial extends ContactDetailState {
  const ContactDetailInitial();
}

final class ContactDetailLoadInProgress extends ContactDetailState {
  const ContactDetailLoadInProgress();
}

final class ContactDetailLoadSuccess extends ContactDetailState {
  const ContactDetailLoadSuccess(this.contact);

  final ContactDetail contact;

  @override
  List<Object> get props => [contact];
}

final class ContactDetailLoadFailure extends ContactDetailState {
  const ContactDetailLoadFailure();
}
