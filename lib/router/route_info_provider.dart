import 'package:flutter/widgets.dart';

import 'package:legend_router/router/legend_router.dart';

import 'routes/route_display.dart';

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
  static RouteDisplay? getRouteDisplay(BuildContext context) {
    RouteSettings route = RouteInfoProvider.of(context).route;
    List<RouteDisplay> options = LegendRouter.of(context).routeDisplays;
    String? routeName = route.name;
    if (routeName == null || routeName.isEmpty) {
      return null;
    }
    return searchRouteDisplay(options, routeName);
  }

  ///
  /// Recursive Method for searching a [RouteDisplay] with a given [route] in a given Iterable<RouteDisplay> of [displays].
  ///
  static RouteDisplay? searchRouteDisplay(
    Iterable<RouteDisplay> displays,
    String route,
  ) {
    for (final RouteDisplay display in displays) {
      if (route == display.route) {
        return display;
      } else if (display.children != null && display.children!.isNotEmpty) {
        RouteDisplay? subDisplay = searchRouteDisplay(display.children!, route);
        if (subDisplay != null) {
          return subDisplay;
        }
      }
    }
    return null;
  }

  static RouteDisplay? getParentRouteDisplay(BuildContext context) {
    RouteSettings? route = RouteInfoProvider.of(context).route;
    List<RouteDisplay> options = LegendRouter.of(context).routeDisplays;

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
  }
}
