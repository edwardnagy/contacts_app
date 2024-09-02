import 'package:contacts_app/data/contact_local_source.dart';
import 'package:contacts_app/model/address.dart';
import 'package:contacts_app/model/contact_create.dart';
import 'package:contacts_app/model/contact_sort_field_type.dart';
import 'package:contacts_app/model/contact_summary.dart';
import 'package:contacts_app/model/phone_number.dart';
import 'package:logger/logger.dart';

class ContactRepository {
  final Logger _logger;
  final ContactLocalSource _contactLocalSource;

  ContactRepository(this._logger, this._contactLocalSource) {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      final isInitialContactsAdded =
          await _contactLocalSource.isInitialContactsAdded();
      if (!isInitialContactsAdded) {
        _logger.i('Initial contacts have not been added. Adding...');
        await _contactLocalSource.addInitialContacts(_mockInitialContacts);
        _logger.i('Initial contacts just added');
      } else {
        _logger.i('Initial contacts have already been added');
      }
    } catch (error, stackTrace) {
      _logger.e(
        'Failed to initialize contacts data',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Stream<List<ContactSummary>> watchContacts(
    List<ContactSortFieldType> sortFieldTypes,
  ) {
    return _contactLocalSource.watchContacts(sortFieldTypes: sortFieldTypes);
  }
}

const _mockInitialContacts = [
  ContactCreate(
    firstName: null,
    lastName: null,
    phoneNumbers: null,
    addresses: [
      Address(
        street1: '012 Birch St',
        street2: null,
        city: 'Springfield',
        state: 'IL',
        zipCode: '62701',
        label: 'Work',
      ),
    ],
  ),
  ContactCreate(
    firstName: 'John',
    lastName: 'Doe',
    phoneNumbers: [
      PhoneNumber(number: '123-456-7890', label: 'Home'),
    ],
    addresses: [
      Address(
        street1: '123 Elm St',
        street2: 'Apt 456',
        city: 'Springfield',
        state: 'IL',
        zipCode: '62701',
        label: 'Home',
      ),
    ],
  ),
  ContactCreate(
    firstName: null,
    lastName: null,
    phoneNumbers: [
      PhoneNumber(number: '345-678-9012', label: 'Work'),
    ],
    addresses: [
      Address(
        street1: '789 Pine St',
        street2: null,
        city: 'Springfield',
        state: 'IL',
        zipCode: '62701',
        label: 'Home',
      ),
    ],
  ),
  ContactCreate(
    firstName: 'Jane',
    lastName: 'Smith',
    phoneNumbers: [
      PhoneNumber(number: '234-567-8901', label: 'Mobile'),
    ],
    addresses: [
      Address(
        street1: '456 Oak St',
        street2: null,
        city: 'Springfield',
        state: 'IL',
        zipCode: '62701',
        label: 'Work',
      ),
    ],
  ),
];
