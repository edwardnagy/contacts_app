import 'package:collection/collection.dart';
import 'package:contacts_app/core/model/address.dart';
import 'package:contacts_app/core/model/contact_update.dart';
import 'package:contacts_app/core/model/phone_number.dart';
import 'package:contacts_app/core/result.dart';
import 'package:contacts_app/core/use_case/delete_contact_use_case.dart';
import 'package:contacts_app/core/use_case/get_contact_use_case.dart';
import 'package:contacts_app/core/use_case/update_contact_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';

part 'contact_editing_event.dart';
part 'contact_editing_state.dart';

class ContactEditingBloc
    extends Bloc<ContactEditingEvent, ContactEditingState> {
  ContactEditingBloc(
    this._logger,
    this._getContactUseCase,
    this._updateContactUseCase,
    this._deleteContactUseCase, {
    required this.contactId,
  }) : super(const ContactEditingState.initial()) {
    on<ContactEditingEvent>((event, emit) {
      return switch (event) {
        ContactEditingExistingDataRequested() => _onExistingDataRequested(emit),
        ContactEditingFirstNameChanged() =>
          emit(state.copyWith(firstName: event.firstName)),
        ContactEditingLastNameChanged() =>
          emit(state.copyWith(lastName: event.lastName)),
        ContactEditingPhoneNumbersChanged() =>
          emit(state.copyWith(phoneNumbers: event.phoneNumbers)),
        ContactEditingAddressesChanged() =>
          emit(state.copyWith(addresses: event.addresses)),
        ContactEditingSaveRequested() => _onSaveRequested(emit),
        ContactEditingDeleteRequested() => _onDeleteRequested(emit),
      };
    });
  }

  final String contactId;
  final Logger _logger;
  final GetContactUseCase _getContactUseCase;
  final UpdateContactUseCase _updateContactUseCase;
  final DeleteContactUseCase _deleteContactUseCase;

  Future<void> _onExistingDataRequested(
    Emitter<ContactEditingState> emit,
  ) async {
    emit(state.copyWith(loadStatus: ContactLoadStatus.inProgress));
    final contactResult = await _getContactUseCase(contactId);
    switch (contactResult) {
      case ResultSuccess():
        emit(state.copyWith(
          loadStatus: ContactLoadStatus.success,
          initialFirstName: contactResult.data.firstName,
          firstName: contactResult.data.firstName,
          initialLastName: contactResult.data.lastName,
          lastName: contactResult.data.lastName,
          initialPhoneNumbers: contactResult.data.phoneNumbers,
          phoneNumbers: contactResult.data.phoneNumbers,
          initialAddresses: contactResult.data.addresses,
          addresses: contactResult.data.addresses,
        ));
      case ResultFailure():
        _logger.e(
          'Failed to load contact',
          error: contactResult.error,
          stackTrace: contactResult.stackTrace,
        );
        emit(state.copyWith(loadStatus: ContactLoadStatus.failure));
    }
  }

  Future<void> _onSaveRequested(Emitter<ContactEditingState> emit) async {
    emit(state.copyWith(updateStatus: ContactUpdateStatus.inProgress));
    final contactUpdate = _getContactUpdateFromState();
    final updateContactResult = await _updateContactUseCase(contactUpdate);
    switch (updateContactResult) {
      case ResultSuccess():
        emit(state.copyWith(
          updateStatus: ContactUpdateStatus.success,
        ));
      case ResultFailure():
        _logger.e(
          'Failed to update contact',
          error: updateContactResult.error,
          stackTrace: updateContactResult.stackTrace,
        );
        emit(state.copyWith(
          updateStatus: ContactUpdateStatus.failure,
        ));
    }
  }

  Future<void> _onDeleteRequested(Emitter<ContactEditingState> emit) async {
    emit(state.copyWith(deletionStatus: ContactDeletionStatus.inProgress));
    final deleteContactResult = await _deleteContactUseCase(contactId);
    switch (deleteContactResult) {
      case ResultSuccess():
        emit(state.copyWith(
          deletionStatus: ContactDeletionStatus.success,
        ));
      case ResultFailure():
        _logger.e(
          'Failed to delete contact',
          error: deleteContactResult.error,
          stackTrace: deleteContactResult.stackTrace,
        );
        emit(state.copyWith(
          deletionStatus: ContactDeletionStatus.failure,
        ));
    }
  }

  ContactUpdate _getContactUpdateFromState() {
    return ContactUpdate(
      id: contactId,
      firstName: state.firstName,
      lastName: state.lastName,
      phoneNumbers: state.phoneNumbers,
      addresses: state.addresses,
    );
  }
}
