import 'package:contacts_app/core/data/asset/contact_asset_source.dart';
import 'package:contacts_app/core/data/objectbox/contact_objectbox_source.dart';
import 'package:contacts_app/core/data/objectbox/generated/objectbox.g.dart';
import 'package:contacts_app/core/data/objectbox/objectbox.dart';
import 'package:contacts_app/core/repository/contact_repository.dart';
import 'package:contacts_app/core/use_case/create_contact_use_case.dart';
import 'package:contacts_app/core/use_case/delete_contact_use_case.dart';
import 'package:contacts_app/core/use_case/get_contact_use_case.dart';
import 'package:contacts_app/core/use_case/update_contact_use_case.dart';
import 'package:contacts_app/core/use_case/watch_contacts_use_case.dart';
import 'package:contacts_app/presentation/screen/contact_creation/bloc/contact_creation_bloc.dart';
import 'package:contacts_app/presentation/screen/contact_editing/bloc/contact_editing_bloc.dart';
import 'package:contacts_app/presentation/screen/contact_list/bloc/contact_list_bloc.dart';
import 'package:logger/logger.dart';

/// A simple dependency injection container.
class SimpleDi {
  SimpleDi._();

  static final instance = SimpleDi._();

  Future<void> initialize() async {
    await contactRepository.initialize();
  }

  Logger getLogger() => Logger();

  Store getStore() => ObjectBox.instance.store;
  ContactObjectboxSource getContactLocalSource() =>
      ContactObjectboxSource(getStore());

  ContactAssetSource getContactAssetSource() => ContactAssetSource();

  late final ContactRepository contactRepository = ContactRepository(
      getLogger(), getContactLocalSource(), getContactAssetSource());

  CreateContactUseCase getCreateContactUseCase() =>
      CreateContactUseCase(contactRepository);
  GetContactUseCase getGetContactUseCase() =>
      GetContactUseCase(contactRepository);
  WatchContactsUseCase getWatchContactsUseCase() =>
      WatchContactsUseCase(contactRepository);
  UpdateContactUseCase getUpdateContactUseCase() =>
      UpdateContactUseCase(contactRepository);
  DeleteContactUseCase getDeleteContactUseCase() =>
      DeleteContactUseCase(contactRepository);

  ContactListBloc getContactListBloc() =>
      ContactListBloc(getLogger(), getWatchContactsUseCase());
  ContactCreationBloc getContactCreationBloc() =>
      ContactCreationBloc(getLogger(), getCreateContactUseCase());
  ContactEditingBloc getContactEditingBloc({required String contactId}) =>
      ContactEditingBloc(
        contactId: contactId,
        getLogger(),
        getGetContactUseCase(),
        getUpdateContactUseCase(),
        getDeleteContactUseCase(),
      );
}
