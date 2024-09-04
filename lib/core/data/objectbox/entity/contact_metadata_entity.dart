import 'package:objectbox/objectbox.dart';

@Entity()
class ContactMetadataEntity {
  @Id()
  int id = 0;
  bool isInitialContactsAdded;

  ContactMetadataEntity({
    required this.isInitialContactsAdded,
  });
}
