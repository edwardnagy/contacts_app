part of 'contact_detail_bloc.dart';

sealed class ContactDetailEvent extends Equatable {
  const ContactDetailEvent();

  @override
  List<Object> get props => [];
}

final class ContactDetailRequested extends ContactDetailEvent {
  const ContactDetailRequested();
}
