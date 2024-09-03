import 'package:contacts_app/core/data/objectbox/entity/address_entity.dart';
import 'package:contacts_app/core/data/objectbox/entity/phone_number_entity.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class ContactEntity {
  @Id()
  int id = 0;
  @Unique()
  String guid;
  String firstName;
  String lastName;

  final phoneNumbers = ToMany<PhoneNumberEntity>();
  final addresses = ToMany<AddressEntity>();

  ContactEntity({
    required this.guid,
    required this.firstName,
    required this.lastName,
  });
}
