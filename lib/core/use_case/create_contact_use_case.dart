import 'package:contacts_app/core/model/contact_create.dart';
import 'package:contacts_app/core/repository/contact_repository.dart';
import 'package:contacts_app/core/result.dart';

/// Creates a new contact, returning the ID of the created contact.
class CreateContactUseCase {
  final ContactRepository _contactRepository;

  CreateContactUseCase(this._contactRepository);

  Future<Result<String>> call(ContactCreate contact) {
    return Result.fromFuture(_contactRepository.createContact(contact));
  }
}
