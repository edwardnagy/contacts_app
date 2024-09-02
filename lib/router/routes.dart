import 'package:contacts_app/l10n/app_localizations.dart';
import 'package:contacts_app/screen/contact_detail/contact_detail_screen.dart';
import 'package:contacts_app/screen/contact_editing/contact_editing_screen.dart';
import 'package:contacts_app/screen/contact_list/contact_list_screen.dart';
import 'package:contacts_app/screen/contact_creation/contact_creation_screen.dart';
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
    return CupertinoPage(
      title: AppLocalizations.of(context).contacts,
      child: const ContactListScreen(),
    );
  }
}

@immutable
class ContactDetailRoute extends GoRouteData {
  final String contactId;

  const ContactDetailRoute({required this.contactId});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ContactDetailScreen(contactId: contactId);
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
