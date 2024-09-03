import 'package:contacts_app/core/model/contact_detail.dart';
import 'package:contacts_app/core/repository/contact_repository.dart';
import 'package:contacts_app/core/result.dart';

class GetContactUseCase {
  final ContactRepository _contactRepository;

  GetContactUseCase(this._contactRepository);

  Future<Result<ContactDetail>> call(String id) {
    return Result.fromFuture(_contactRepository.getContact(id));
  }
}
