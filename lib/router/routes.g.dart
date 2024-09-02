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
        ),
        GoRouteData.$route(
          path: 'new-contact',
          factory: $NewContactRouteExtension._fromState,
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
      );

  String get location => GoRouteData.$location(
        '/contacts/${Uri.encodeComponent(contactId)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $NewContactRouteExtension on NewContactRoute {
  static NewContactRoute _fromState(GoRouterState state) => NewContactRoute();

  String get location => GoRouteData.$location(
        '/new-contact',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
