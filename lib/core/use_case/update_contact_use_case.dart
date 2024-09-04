import 'package:contacts_app/core/model/contact_update.dart';
import 'package:contacts_app/core/repository/contact_repository.dart';
import 'package:contacts_app/core/result.dart';

class UpdateContactUseCase {
  final ContactRepository contactRepository;

  UpdateContactUseCase(this.contactRepository);

  Future<Result<void>> call(ContactUpdate contact) {
    return Result.fromFuture(contactRepository.updateContact(contact));
  }
}
