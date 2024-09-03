import 'package:contacts_app/core/repository/contact_repository.dart';
import 'package:contacts_app/core/result.dart';

class DeleteContactUseCase {
  final ContactRepository _contactRepository;

  DeleteContactUseCase(this._contactRepository);

  Future<Result<void>> call(String contactId) async {
    return Result.fromFuture(_contactRepository.deleteContact(contactId));
  }
}
