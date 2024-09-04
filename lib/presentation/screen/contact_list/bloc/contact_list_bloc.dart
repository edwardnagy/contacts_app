import 'dart:async';

import 'package:contacts_app/core/model/contact_sort_field_type.dart';
import 'package:contacts_app/core/model/contact_summary.dart';
import 'package:contacts_app/core/result.dart';
import 'package:contacts_app/core/use_case/watch_contacts_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

part 'contact_list_event.dart';
part 'contact_list_state.dart';

class ContactListBloc extends Bloc<ContactListEvent, ContactListState> {
  ContactListBloc(
    this._logger,
    this._watchContactsUseCase,
  ) : super(const ContactListState()) {
    on<ContactListEvent>(
      (event, emit) => switch (event) {
        ContactListRequested() =>
          _onContactsRequested(emit, searchQuery: event.searchQuery),
      },
    );
  }

  final Logger _logger;
  final WatchContactsUseCase _watchContactsUseCase;

  Future<void> _onContactsRequested(
    Emitter<ContactListState> emit, {
    required String searchQuery,
  }) {
    const sortFieldsPrioritized = [
      ContactSortFieldType.lastName,
      ContactSortFieldType.firstName,
      ContactSortFieldType.phoneNumber,
    ];
    emit(state.copyWith(
      loadStatus: ContactListStatus.loading,
      searchQuery: searchQuery,
    ));
    return emit.forEach(
      _watchContactsUseCase(sortFieldsPrioritized, searchQuery: searchQuery),
      onData: (result) {
        switch (result) {
          case ResultSuccess():
            return state.copyWith(
              loadStatus: ContactListStatus.success,
              contacts: result.data,
            );
          case ResultFailure():
            _logger.e(
              'Failed to load contacts',
              error: result.error,
              stackTrace: result.stackTrace,
            );
            return state.copyWith(
              loadStatus: ContactListStatus.failure,
            );
        }
      },
    );
  }
}
