import 'package:contacts_app/core/data/objectbox/entity/contact_entity.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class AddressEntity {
  @Id()
  int id = 0;
  String street1;
  String street2;
  String city;
  String state;
  String zipCode;
  String label;

  final contact = ToOne<ContactEntity>();

  AddressEntity({
    required this.street1,
    required this.street2,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.label,
  });
}
