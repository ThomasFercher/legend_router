import 'package:flutter/widgets.dart';

@immutable
class RouteInfo {
  final String name;
  final String title;
  final Widget page;
  final IconData? icon;
  final Object? arguments;
  final Iterable<RouteInfo>? children;

  @mustCallSuper
  const RouteInfo({
    required this.name,
    required this.title,
    required this.page,
    this.icon,
    this.arguments,
    this.children,
  });

  int get depth => name.split('/').length - 1;

  bool get isUnderyling => name.split('/').length > 1;
}

enum ModalTransition {
  SLIDE,
  FADE,
}

class PageRouteInfo extends RouteInfo {
  const PageRouteInfo({
    required super.name,
    required super.page,
    required super.title,
    super.icon,
    super.children,
    super.arguments,
  });
}

class ModalRouteInfo extends RouteInfo {
  final ModalTransition transition;

  const ModalRouteInfo({
    required super.name,
    required super.page,
    required super.title,
    super.arguments,
    super.children,
    super.icon,
    this.transition = ModalTransition.SLIDE,
  });
}
