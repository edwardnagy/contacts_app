import 'package:contacts_app/screen/contact_list_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

part 'routes.g.dart';

@TypedGoRoute<ContactListRoute>(
  path: '/',
)
@immutable
class ContactListRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ContactListScreen();
  }
}
