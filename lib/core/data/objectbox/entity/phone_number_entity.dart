import 'package:contacts_app/core/data/objectbox/entity/contact_entity.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class PhoneNumberEntity {
  @Id()
  int id = 0;
  String number;
  String label;

  final contact = ToOne<ContactEntity>();

  PhoneNumberEntity({
    required this.number,
    required this.label,
  });
}
