import 'objectbox.g.dart';

class ObjectBox {
  late final Store store;

  ObjectBox._(this.store);

  static late final ObjectBox _instance;
  static ObjectBox get instance => _instance;

  static Future<void> initialize() async {
    final store = await openStore();
    _instance = ObjectBox._(store);
  }
}
