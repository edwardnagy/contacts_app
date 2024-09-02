import 'package:contacts_app/l10n/app_localizations.dart';
import 'package:contacts_app/screen/contact_detail/contact_detail_screen.dart';
import 'package:contacts_app/screen/contact_list/contact_list_screen.dart';
import 'package:contacts_app/screen/new_contact/new_contact_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

part 'routes.g.dart';

@TypedGoRoute<ContactListRoute>(
  path: '/',
  routes: [
    TypedGoRoute<ContactDetailRoute>(
      path: 'contacts/:contactId',
    ),
    TypedGoRoute<NewContactRoute>(
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
class NewContactRoute extends GoRouteData {
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    // Sheet presentation style is not yet supported. https://github.com/flutter/flutter/issues/42560
    return const CupertinoPage(
      fullscreenDialog: true,
      child: NewContactScreen(),
    );
  }
}
