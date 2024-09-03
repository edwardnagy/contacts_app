import 'package:contacts_app/core/model/address.dart';
import 'package:contacts_app/core/model/contact_create.dart';
import 'package:contacts_app/core/model/phone_number.dart';
import 'package:contacts_app/core/result.dart';
import 'package:contacts_app/core/use_case/create_contact_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';

part 'contact_creation_event.dart';
part 'contact_creation_state.dart';

class ContactCreationBloc
    extends Bloc<ContactCreationEvent, ContactCreationState> {
  ContactCreationBloc(
    this._logger,
    this._createContactUseCase,
  ) : super(const ContactCreationState.initial()) {
    on<ContactCreationEvent>((event, emit) {
      return switch (event) {
        ContactCreationFirstNameChanged() =>
          emit(state.resetStatusAndCopyWith(firstName: event.firstName)),
        ContactCreationLastNameChanged() =>
          emit(state.resetStatusAndCopyWith(lastName: event.lastName)),
        ContactCreationPhoneNumbersChanged() =>
          emit(state.resetStatusAndCopyWith(phoneNumbers: event.phoneNumbers)),
        ContactCreationAddressesChanged() =>
          emit(state.resetStatusAndCopyWith(addresses: event.addresses)),
        ContactCreationSaveRequested() => _onSaveRequested(emit),
      };
    });
  }

  final Logger _logger;
  final CreateContactUseCase _createContactUseCase;

  Future<void> _onSaveRequested(Emitter<ContactCreationState> emit) async {
    final contact = _getContactFromState();
    final createContactResult = await _createContactUseCase(contact);
    switch (createContactResult) {
      case ResultSuccess():
        emit(state.copyWith(
          creationStatus:
              ContactCreationSuccess(contactId: createContactResult.data),
        ));
        break;
      case ResultFailure():
        _logger.e(
          'Failed to create contact',
          error: createContactResult.error,
          stackTrace: createContactResult.stackTrace,
        );
        emit(state.copyWith(
          creationStatus: ContactCreationFailure(createContactResult.error),
        ));
        break;
    }
  }

  ContactCreate _getContactFromState() {
    return ContactCreate(
      firstName: state.firstName,
      lastName: state.lastName,
      phoneNumbers: state.phoneNumbers
          .where((phoneNumber) => phoneNumber.isNotEmpty)
          .toList(),
      addresses:
          state.addresses.where((address) => address.isNotEmpty).toList(),
    );
  }
}

extension on PhoneNumber {
  bool get isNotEmpty => number.isNotEmpty;
}

extension on Address {
  bool get isNotEmpty =>
      street1.isNotEmpty == true ||
      street2.isNotEmpty ||
      city.isNotEmpty ||
      state.isNotEmpty ||
      zipCode.isNotEmpty;
}
