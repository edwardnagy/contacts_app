import 'package:contacts_app/core/model/contact_sort_field_type.dart';
import 'package:contacts_app/core/model/contact_summary.dart';
import 'package:contacts_app/core/repository/contact_repository.dart';
import 'package:contacts_app/core/result.dart';

class WatchContactsUseCase {
  final ContactRepository _contactRepository;

  WatchContactsUseCase(this._contactRepository);

  Stream<Result<List<ContactSummary>>> call(
    List<ContactSortFieldType> sortFieldTypes, {
    required String searchQuery,
  }) {
    return Result.fromStream(
      _contactRepository.watchContacts(
        sortFieldTypes,
        searchQuery: searchQuery,
      ),
    );
  }
}
