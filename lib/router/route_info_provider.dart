import 'package:flutter/widgets.dart';

import 'package:legend_router/router/legend_router.dart';

class RouteInfoProvider extends InheritedWidget {
  final RouteSettings route;

  const RouteInfoProvider({
    Key? key,
    required Widget child,
    required this.route,
  }) : super(key: key, child: child);

  static RouteInfoProvider of(BuildContext context) {
    final RouteInfoProvider? result =
        context.dependOnInheritedWidgetOfExactType<RouteInfoProvider>();
    assert(result != null, 'No RouteInfoProvider found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(RouteInfoProvider oldWidget) {
    return oldWidget.route != route;
  }

  ///
  /// This Method returns the RouteDisplay of the active Route
  /// The [context] is needed for accessing this class in a static way.
  ///
  /* static RouteDisplay? getRouteDisplay(BuildContext context) {
    RouteSettings route = RouteInfoProvider.of(context).route;
    List<RouteDisplay> options = LegendRouter.of(context).routes;
    String? routeName = route.name;
    if (routeName == null || routeName.isEmpty) {
      return null;
    }
    return searchRouteDisplay(options, routeName);
  }*/

  ///
  ///
  ///
  static RouteInfo? getParentRouteInfo(
    BuildContext context,
    RouteInfo current,
  ) {
    List<String> parent = current.name.split('/');
    if (current.depth == 0) return null;
    if (parent.length > 1) {
      String parentRoute = parent.sublist(0, parent.length - 1).join('/');

      return searchRouteInfo(LegendRouter.of(context).routes, parentRoute);
    } else {
      return null;
    }
  }

  ///
  ///
  ///
  static RouteInfo? getRouteInfo(BuildContext context) {
    RouteSettings route = RouteInfoProvider.of(context).route;
    List<RouteInfo> routes = LegendRouter.of(context).routes;
    if (route.name == null || route.name!.isEmpty) {
      return null;
    }
    return searchRouteInfo(routes, route.name!);
  }

  ///
  ///
  ///
  static RouteInfo? searchRouteInfo(Iterable<RouteInfo> routes, String route) {
    for (final RouteInfo info in routes) {
      if (info.name == route) {
        return info;
      } else if (info.children != null && info.children!.isNotEmpty) {
        RouteInfo? subRoute = searchRouteInfo(info.children!, route);
        if (subRoute != null) {
          return subRoute;
        }
      }
    }
    return null;
  }

  /* static RouteDisplay? getParentRouteDisplay(BuildContext context) {
    RouteSettings? route = RouteInfoProvider.of(context).route;
    List<RouteDisplay> options = LegendRouter.of(context).routes;

    if (route.name == null) {
      return null;
    }

    for (final RouteDisplay op in options) {
      if (route.name!.contains(op.route)) {
        var slash = 0;
        var s = op.route;
        if (s == '/' || s.isEmpty) {
          continue;
        }

        for (final c in s.characters) {
          if (c == '/') {
            slash++;
          }
        }

        var rS = route.name!;
        var slashR = 0;
        for (final c in rS.characters) {
          if (c == '/') {
            slashR++;
          }
        }

        if (slashR > slash) {
          return op;
        }
      }
    }

    return null;
  }*/
}
