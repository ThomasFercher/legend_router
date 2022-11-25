import 'package:flutter/widgets.dart';
import 'package:legend_router/src/router.dart';
import 'package:legend_router/src/entities/routes/route_config.dart';
import 'package:legend_router/src/entities/routes/route_info.dart';

class RouteInfoProvider extends InheritedWidget {
  final RouteConfig route;

  const RouteInfoProvider({
    Key? key,
    required Widget child,
    required this.route,
  }) : super(key: key, child: child);

  static RouteInfoProvider? of(BuildContext context) {
    final RouteInfoProvider? result =
        context.dependOnInheritedWidgetOfExactType<RouteInfoProvider>();
    //assert(result != null, 'No RouteInfoProvider found in context');
    return result;
  }

  @override
  bool updateShouldNotify(RouteInfoProvider oldWidget) {
    return oldWidget.route != route;
  }

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
}
