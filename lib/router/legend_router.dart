import 'package:flutter/material.dart';
import 'package:legend_router/router/route_info_provider.dart';
import 'package:legend_router/router/routes/route_display.dart';
import 'legendPage.dart';
import 'router_delegate.dart';
import 'routes/route_info.dart';
export 'errorpages/notfound.dart';
export 'router_delegate.dart';
export 'routes/route_info.dart';

const PageRouteInfo NOTFOUND = PageRouteInfo(
  name: "Not Found",
  page: SizedBox(),
);

// ignore: must_be_immutable
class LegendRouter extends InheritedWidget {
  final LegendRouterDelegate routerDelegate;
  @override
  final Widget child;
  final List<RouteInfo> routes;
  late final List<PageRouteInfo> pageRoutes;
  late final List<ModalRouteInfo> modalRoutes;
  late final PageRouteInfo? notFound;
  final List<RouteDisplay> routeDisplays;
  BuildContext? context;

  LegendRouter({
    Key? key,
    required this.routerDelegate,
    required this.child,
    required this.routes,
    required this.routeDisplays,
    this.notFound = NOTFOUND,
  }) : super(key: key, child: child) {
    modalRoutes = routes.whereType<ModalRouteInfo>().toList();
    pageRoutes = routes.whereType<PageRouteInfo>().toList();
  }

  static LegendRouter of(BuildContext context) {
    final LegendRouter? result =
        context.dependOnInheritedWidgetOfExactType<LegendRouter>();
    assert(result != null, 'No RouterProvider found in context');
    result!.context = context;
    return result;
  }

  void pushPage({required RouteSettings settings, bool useKey = false}) {
    RouteInfo info = getRouteWidget(settings, routes);

    Page<dynamic> p = createPage(settings, info);

    if (useKey) {
      routerDelegate.navigatorKey?.currentState?.pushNamed(p.name ?? '');
    } else {
      routerDelegate.pushPage(p);
    }
  }

  List<RouteDisplay> get getRouteDisplays => List.of(findAll(routeDisplays));

  ///
  /// Returns all RouteDisplays parents and children,
  ///
  List<RouteDisplay> findAll(Iterable<RouteDisplay> list) {
    List<RouteDisplay> items = [];
    for (final RouteDisplay item in list) {
      items.add(item);
      if (item.children != null && item.children!.isNotEmpty) {
        items.addAll(item.children!);
      }
    }
    return items;
  }

  ///
  /// Searches the currently selected [RouteDisplay]
  ///
  RouteDisplay? searchCurrent(Iterable<RouteDisplay> options, String name) {
    for (final RouteDisplay option in options) {
      if (option.route == name) return option;
      if (option.children != null) {
        RouteDisplay? co = searchCurrent(option.children!, name);
        if (co != null) return co;
      }
    }
    return null;
  }

  ///
  /// Invokes the [searchCurrent] Method with the current Route name and [routeDisplays]
  ///
  RouteDisplay? getCurrent() {
    String? name = routerDelegate.current?.name;
    if (name == null || name.isEmpty) return null;
    RouteDisplay? option = searchCurrent(routeDisplays, name);
    return option;
  }

  /// Should only be used to push Dialogs that are outside of the content or are overallaping AppBar or Sider
  void pushGlobalModal({required RouteSettings settings, bool useKey = false}) {
    RouteInfo info = getRouteWidget(settings, routes);

    if (info is ModalRouteInfo) {
      Page<dynamic> p = createPage(settings, info);

      Navigator.of(context!).pushNamed(info.name);
    }
  }

  void popPage({bool useKey = false}) {
    if (useKey) {
      routerDelegate.navigatorKey?.currentState?.pop();
    } else {
      routerDelegate.popRoute();
    }
  }

  void popModal() {
    Navigator.of(context!).pop();
  }

  static RouteInfo getRouteWidget(RouteSettings s, Iterable<RouteInfo> routes) {
    if (routes.isEmpty) {
      return NOTFOUND;
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

    return NOTFOUND;
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
