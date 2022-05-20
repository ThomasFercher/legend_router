import 'package:flutter/widgets.dart';

abstract class RouteInfo {
  final String name;
  final Widget page;
  final Object? arguments;
  final Iterable<RouteInfo>? children;

  @mustCallSuper
  const RouteInfo({
    required this.name,
    required this.page,
    this.arguments,
    this.children,
  });

  bool get isUnderyling => name.split('/').length > 1;
}

enum ModalTransition {
  SLIDE,
  FADE,
}

class PageRouteInfo extends RouteInfo {
  const PageRouteInfo({
    required String name,
    required Widget page,
    Iterable<PageRouteInfo>? children,
    Object? arguments,
    bool? isUnderlying,
  }) : super(
          name: name,
          page: page,
          children: children,
          arguments: arguments,
        );
}

class ModalRouteInfo extends RouteInfo {
  final double width;
  final ModalTransition transition;

  const ModalRouteInfo({
    required Widget page,
    required String name,
    required this.width,
    this.transition = ModalTransition.SLIDE,
    Object? arguments,
    bool? isUnderlying,
  }) : super(
          name: name,
          page: page,
          arguments: arguments,
        );
}
