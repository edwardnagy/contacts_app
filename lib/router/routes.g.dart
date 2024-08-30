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
