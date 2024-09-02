// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $contactListRoute,
    ];

RouteBase get $contactListRoute => GoRouteData.$route(
      path: '/',
      factory: $ContactListRouteExtension._fromState,
      routes: [
        GoRouteData.$route(
          path: 'contacts/:contactId',
          factory: $ContactDetailRouteExtension._fromState,
          routes: [
            GoRouteData.$route(
              path: 'edit',
              factory: $ContactEditingRouteExtension._fromState,
            ),
          ],
        ),
        GoRouteData.$route(
          path: 'new-contact',
          factory: $ContactCreationRouteExtension._fromState,
        ),
      ],
    );

extension $ContactListRouteExtension on ContactListRoute {
  static ContactListRoute _fromState(GoRouterState state) => ContactListRoute();

  String get location => GoRouteData.$location(
        '/',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $ContactDetailRouteExtension on ContactDetailRoute {
  static ContactDetailRoute _fromState(GoRouterState state) =>
      ContactDetailRoute(
        contactId: state.pathParameters['contactId']!,
        firstName: state.uri.queryParameters['first-name'],
        lastName: state.uri.queryParameters['last-name'],
      );

  String get location => GoRouteData.$location(
        '/contacts/${Uri.encodeComponent(contactId)}',
        queryParams: {
          if (firstName != null) 'first-name': firstName,
          if (lastName != null) 'last-name': lastName,
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $ContactEditingRouteExtension on ContactEditingRoute {
  static ContactEditingRoute _fromState(GoRouterState state) =>
      ContactEditingRoute(
        contactId: state.pathParameters['contactId']!,
      );

  String get location => GoRouteData.$location(
        '/contacts/${Uri.encodeComponent(contactId)}/edit',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $ContactCreationRouteExtension on ContactCreationRoute {
  static ContactCreationRoute _fromState(GoRouterState state) =>
      ContactCreationRoute();

  String get location => GoRouteData.$location(
        '/new-contact',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
