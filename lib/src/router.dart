import 'package:flutter/material.dart';
import 'package:legend_router/src/entities/pages/not_found.dart';
import 'package:legend_router/src/information_provider.dart';
import 'package:legend_router/src/entities/routes/extensions.dart';

import 'entities/pages/legend_modal_page.dart';
import 'entities/pages/legend_page.dart';
import 'entities/pages/legend_scaffold_page.dart';
import 'entities/routes/route_config.dart';
import 'delegate.dart';
import 'entities/routes/route_info.dart';

const notFound = PageRouteInfo(
  name: "/notFound",
  page: NotFound(),
  title: 'Not Found',
);

class LegendRouter extends InheritedWidget {
  final LegendRouterDelegate routerDelegate;
  final List<RouteInfo> routes;

  const LegendRouter({
    super.key,
    required this.routerDelegate,
    required super.child,
    required this.routes,
  });

  static LegendRouter of(BuildContext context) {
    final LegendRouter? result =
        context.dependOnInheritedWidgetOfExactType<LegendRouter>();
    assert(result != null, 'No RouterProvider found in context');

    return result!;
  }

  List<T> getTopRoutes<T extends PageRouteInfo>() {
    return List.of(
      routes.get<T>().where(
            (route) => route.depth == 1,
          ),
    );
  }

  RouteInfo? get current => routerDelegate.current;

  ///
  /// Utility Functions
  ///

  void pushPage(
    String route, {
    Map<String, dynamic>? urlArguments,
    Object? arguments,
  }) {
    final _routeConfig = RouteConfig(
      name: route,
      arguments: arguments,
      urlArguments: urlArguments,
    );

    final info = getRouteWidget(_routeConfig, routes) ??
        routerDelegate.onGenerateRoute?.call(_routeConfig) ??
        notFound;

    final hideRoute = routerDelegate.hideRoutes?.call(info) ?? false;
    if (hideRoute) return;

    final page = createPage(_routeConfig, info);

    routerDelegate.pushPage(page);
  }

  bool get isFirstOnStack => routerDelegate.currentConfiguration.length == 1;

  void popPage() => routerDelegate.popRoute();

  void popUntil(bool Function(LegendPage<dynamic>) predicate) =>
      routerDelegate.popUntil(predicate);

  void clear() => routerDelegate.clearPages();

  void replacePage(
    String route, {
    Map<String, dynamic>? urlArguments,
    Object? arguments,
  }) {
    final _routeConfig = RouteConfig(
      name: route,
      arguments: arguments,
      urlArguments: urlArguments,
    );

    final info = getRouteWidget(_routeConfig, routes) ?? notFound;
    final page = createPage(_routeConfig, info);

    routerDelegate.replacePage(page);
  }

  ///
  /// Delegate Functions
  ///

  static RouteInfo? getRouteWidget(
      RouteSettings s, Iterable<RouteInfo> routes) {
    for (final RouteInfo routeinfo in routes) {
      if (routeinfo.name == s.name) {
        return routeinfo;
      }

      if (routeinfo.children != null) {
        for (final RouteInfo r in routeinfo.children!) {
          if (r.name == s.name) {
            return r;
          }
        }
      }
    }

    return null;
  }

  static LegendPage<dynamic> createPage(
    RouteConfig s,
    RouteInfo info,
  ) {
    if (info is ModalRouteInfo) {
      return createModalPage(s, info);
    } else {
      return createPageRoute(s, info);
    }
  }

  static LegendPage<dynamic> createModalPage(
    RouteConfig s,
    ModalRouteInfo route,
  ) {
    return LegendModalPage(
      child: Stack(
        children: [
          RouteInfoProvider(
            child: route.page,
            route: s,
          ),
        ],
      ),
      name: route.name,
      arguments: s.arguments,
      urlArguments: s.urlArguments,
      key: UniqueKey(),
    );
  }

  static LegendScaffoldPage createPageRoute(RouteConfig s, RouteInfo route) {
    return LegendScaffoldPage(
      child: RouteInfoProvider(
        child: route.page,
        route: s,
      ),
      name: route.name,
      arguments: s.arguments,
      urlArguments: s.urlArguments,
      key: UniqueKey(),
    );
  }

  @override
  bool updateShouldNotify(covariant LegendRouter oldWidget) =>
      routerDelegate.currentConfiguration !=
      oldWidget.routerDelegate.currentConfiguration;
}
