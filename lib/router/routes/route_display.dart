import 'package:flutter/widgets.dart';

///
/// This class serves as the interface for customizable Route names, displays, functions and hirachy.
/// The [title] is used for Display in UI Elements. The [route] is a [String] which is associated with a [Route].
/// The Iterable [children] is used for building a hirachy. Optionally you can speficidy a [icon] which can be displayed ui UI elements.
///
abstract class RouteDisplay {
  final String title;
  final String route;
  final Iterable<RouteDisplay>? children;
  final IconData? icon;

  const RouteDisplay({
    required this.title,
    required this.route,
    required this.children,
    this.icon,
  });

  const RouteDisplay.none()
      : title = "",
        route = "",
        children = null,
        icon = null;
}

class SimpleRouteDisplay extends RouteDisplay {
  const SimpleRouteDisplay({
    required String title,
    required String route,
    Iterable<RouteDisplay>? children,
    IconData? icon,
    bool? isUnderyling,
  }) : super(
          title: title,
          route: route,
          children: children,
          icon: icon,
        );
}
