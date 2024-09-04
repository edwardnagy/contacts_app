import 'package:contacts_app/core/model/contact_detail.dart';
import 'package:contacts_app/core/repository/contact_repository.dart';
import 'package:contacts_app/core/result.dart';

class WatchContactUseCase {
  final ContactRepository _contactRepository;

  WatchContactUseCase(this._contactRepository);

  Stream<Result<ContactDetail>> call(String contactId) {
    return Result.fromStream(_contactRepository.watchContact(contactId));
  }
}
