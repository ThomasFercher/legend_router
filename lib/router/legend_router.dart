import 'package:flutter/material.dart';
import 'package:legend_router/router/route_info_provider.dart';
import 'package:legend_router/router/routes/extensions.dart';

import 'legendPage.dart';
import 'router_delegate.dart';
import 'routes/route_info.dart';
export 'errorpages/notfound.dart';
export 'router_delegate.dart';
export 'routes/route_info.dart';

extension RouteUtility on List<RouteInfo> {
  List<RouteInfo> expandChildren() {
    List<RouteInfo> result = [];
    for (final RouteInfo info in this) {
      result.add(info);
      if (info.children != null) {
        result.addAll(info.children!.toList().expandChildren());
      }
    }
    return result;
  }
}

class LegendRouter extends InheritedWidget {
  final LegendRouterDelegate routerDelegate;

  final List<RouteInfo> routes;

  static const PageRouteInfo notFound = PageRouteInfo(
    name: "Not Found",
    page: SizedBox(),
    title: 't',
  );

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

  List<RouteInfo> get topRoutes =>
      routes.get<PageRouteInfo>().where((route) => route.depth == 1).toList();

  void pushPage({required RouteSettings settings, bool useKey = false}) {
    RouteInfo info = getRouteWidget(settings, routes);

    Page<dynamic> p = createPage(settings, info);

    if (useKey) {
      routerDelegate.navigatorKey?.currentState?.pushNamed(p.name ?? '');
    } else {
      routerDelegate.pushPage(p);
    }
  }

  bool currentIsUnderlying() {
    return routerDelegate.current?.isUnderyling ?? false;
  }

  bool isFirstOnStack() {
    return routerDelegate.currentConfiguration.length == 1;
  }

  void popPage({bool useKey = false}) {
    if (useKey) {
      routerDelegate.navigatorKey?.currentState?.pop();
    } else {
      routerDelegate.popRoute();
    }
  }

  static RouteInfo getRouteWidget(RouteSettings s, Iterable<RouteInfo> routes) {
    if (routes.isEmpty) {
      return notFound;
    }

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

    return notFound;
  }

  static Page<dynamic> createPage(
    RouteSettings s,
    RouteInfo info,
  ) {
    if (info is ModalRouteInfo) {
      return createModalPage(s, info);
    } else {
      return createPageRoute(s, info);
    }
  }

  static Page<dynamic> createModalPage(RouteSettings s, ModalRouteInfo route) {
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
      arguments: route.arguments,
      key: UniqueKey(),
    );
  }

  static LegendPage createPageRoute(RouteSettings s, RouteInfo route) {
    return LegendPage(
      child: RouteInfoProvider(
        child: route.page,
        route: s,
      ),
      name: route.name,
      arguments: route.arguments,
      key: UniqueKey(),
    );
  }

  @override
  bool updateShouldNotify(covariant LegendRouter old) =>
      routerDelegate.currentConfiguration !=
      old.routerDelegate.currentConfiguration;
}
