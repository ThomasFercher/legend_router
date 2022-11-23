import 'package:flutter/widgets.dart';

class LegendRouteInformationProvider extends PlatformRouteInformationProvider {
  VoidCallback? _listener;

  LegendRouteInformationProvider({
    required super.initialRouteInformation,
  });

  @override
  void addListener(VoidCallback listener) {
    _listener = listener;
  }

  @override
  void removeListener(VoidCallback listener) {
    _listener = null;
  }

  @override
  Future<bool> didPushRoute(String route) {
    _listener?.call();
    return super.didPushRoute(route);
  }

  @override
  Future<bool> didPushRouteInformation(RouteInformation routeInformation) {
    _listener?.call();
    return super.didPushRouteInformation(routeInformation);
  }
}
