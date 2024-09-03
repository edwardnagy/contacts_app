import 'package:contacts_app/presentation/screen/contact_creation/contact_creation_screen.dart';
import 'package:contacts_app/presentation/screen/contact_detail/contact_detail_screen.dart';
import 'package:contacts_app/presentation/screen/contact_editing/contact_editing_screen.dart';
import 'package:contacts_app/presentation/screen/contact_list/contact_list_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

part 'routes.g.dart';

@TypedGoRoute<ContactListRoute>(
  path: '/',
  routes: [
    TypedGoRoute<ContactDetailRoute>(
      path: 'contacts/:contactId',
      routes: [
        TypedGoRoute<ContactEditingRoute>(
          path: 'edit',
        ),
      ],
    ),
    TypedGoRoute<ContactCreationRoute>(
      path: 'new-contact',
    ),
  ],
)
@immutable
class ContactListRoute extends GoRouteData {
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return const CupertinoPage(
      // Disable title for now, as it's not working properly when popping back
      // from multiple pushed routes.
      // This issue still occurs: https://github.com/flutter/flutter/issues/57581
      // title: AppLocalizations.of(context).contacts,
      child: ContactListScreen(),
    );
  }
}

@immutable
class ContactDetailRoute extends GoRouteData {
  final String contactId;
  final String? firstName;
  final String? lastName;

  const ContactDetailRoute({
    required this.contactId,
    required this.firstName,
    required this.lastName,
  });

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ContactDetailScreen(
      contactId: contactId,
      firstName: firstName,
      lastName: lastName,
    );
  }
}

@immutable
class ContactCreationRoute extends GoRouteData {
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    // Sheet presentation style is not yet supported. https://github.com/flutter/flutter/issues/42560
    return const CupertinoPage(
      fullscreenDialog: true,
      child: ContactCreationScreen(),
    );
  }
}

@immutable
class ContactEditingRoute extends GoRouteData {
  final String contactId;

  const ContactEditingRoute({required this.contactId});

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CustomTransitionPage(
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          FadeTransition(opacity: animation, child: child),
      child: ContactEditingScreen(contactId: contactId),
    );
  }
}
