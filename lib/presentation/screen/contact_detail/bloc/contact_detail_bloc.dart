import 'package:contacts_app/core/model/contact_detail.dart';
import 'package:contacts_app/core/result.dart';
import 'package:contacts_app/core/use_case/watch_contact_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

part 'contact_detail_event.dart';
part 'contact_detail_state.dart';

class ContactDetailBloc extends Bloc<ContactDetailEvent, ContactDetailState> {
  ContactDetailBloc(
    this._logger,
    this._watchContactUseCase, {
    required this.contactId,
  }) : super(const ContactDetailInitial()) {
    on<ContactDetailEvent>(
      (event, emit) => switch (event) {
        ContactDetailRequested() => _onContactDetailRequested(emit),
      },
    );
  }

  final String contactId;
  final Logger _logger;
  final WatchContactUseCase _watchContactUseCase;

  Future<void> _onContactDetailRequested(Emitter<ContactDetailState> emit) {
    emit(const ContactDetailLoadInProgress());
    return emit.forEach(
      _watchContactUseCase(contactId),
      onData: (result) {
        switch (result) {
          case ResultSuccess():
            return ContactDetailLoadSuccess(result.data);
          case ResultFailure():
            _logger.e(
              'Failed to load contact detail',
              error: result.error,
              stackTrace: result.stackTrace,
            );
            return const ContactDetailLoadFailure();
        }
      },
    );
  }
}
