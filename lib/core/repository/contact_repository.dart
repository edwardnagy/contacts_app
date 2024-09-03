import 'package:contacts_app/core/data/asset/contact_asset_source.dart';
import 'package:contacts_app/core/data/objectbox/contact_objectbox_source.dart';
import 'package:contacts_app/core/model/contact_detail.dart';
import 'package:contacts_app/core/model/contact_sort_field_type.dart';
import 'package:contacts_app/core/model/contact_summary.dart';
import 'package:logger/logger.dart';

class ContactRepository {
  final Logger _logger;
  final ContactObjectboxSource _contactLocalSource;
  final ContactAssetSource _contactAssetSource;

  ContactRepository(
    this._logger,
    this._contactLocalSource,
    this._contactAssetSource,
  );

  Future<void> initialize() async {
    try {
      final isInitialContactsAdded =
          await _contactLocalSource.isInitialContactsAdded();
      if (!isInitialContactsAdded) {
        _logger.i('Initial contacts have not been added. Adding...');
        final initialContacts = await _contactAssetSource.getInitialContacts();
        await _contactLocalSource.addInitialContacts(initialContacts);
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

  Stream<ContactDetail> watchContactDetail(String contactId) {
    return _contactLocalSource.watchContactDetail(contactId);
  }
}
