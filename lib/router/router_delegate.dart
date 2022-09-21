import 'package:flutter/cupertino.dart';
import 'package:legend_router/router/route_info_provider.dart';
import 'legend_router.dart';
import 'routes/popup_route/legend_popup_route.dart';
import 'routes/popup_route/popup_route_config.dart';

abstract class NavigatorFrame {
  Widget buildFrame(
    BuildContext context,
    Navigator navigator,
    RouteInfo? current,
  );
}

abstract class ModalDependencies {
  Widget buildFrame(BuildContext context);
}

const RouteSettings homeRoute = RouteSettings(name: '/');

class LegendRouterDelegate extends RouterDelegate<List<RouteSettings>>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<List<RouteSettings>> {
  final NavigatorFrame? frame;
  final ModalDependencies? modalDependencies;
  final List<Page<dynamic>> _pages = [];

  Iterable<RouteInfo> _routes = [];
  late RouteInfo? current;

  LegendRouterDelegate({
    required this.frame,
    this.modalDependencies,
  });

  ///
  /// Searches the currently selected [RouteInfo] in the given scope of [_routes] with the currently
  /// selected [Page].
  ///
  RouteInfo? searchCurrentRouteInfo(
    Iterable<RouteInfo> routes,
    Page<dynamic> page,
  ) {
    for (RouteInfo info in routes) {
      if (info.name == page.name) {
        return info;
      } else if (info.children != null && info.children!.isNotEmpty) {
        RouteInfo? a = searchCurrentRouteInfo(info.children!, page);
        if (a != null) return a;
      }
    }
    return null;
  }

  RouteInfo? getCurrent(Page<dynamic> page) {
    return searchCurrentRouteInfo(_routes, page);
  }

  @override
  Widget build(BuildContext context) {
    _routes = LegendRouter.of(context).routes;

    if (_pages.isEmpty) {
      _pages.insert(
        0,
        LegendRouter.createPage(
          homeRoute,
          LegendRouter.getRouteWidget(homeRoute, _routes),
        ),
      );
    }

    // The Currently selected RouteInfo
    current = getCurrent(_pages.last);

    if (frame != null) {
      return RouteInfoProvider(
        route: RouteSettings(name: current?.name ?? "/"),
        child: frame!.buildFrame(
          context,
          Navigator(
            pages: List.of(_pages),
            key: navigatorKey,
            onPopPage: _onPopPage,
            observers: [
              HeroController(),
            ],
            onGenerateRoute: onGenerateRoute,
          ),
          current,
        ),
      );
    } else {
      return Navigator(
        pages: List.of(_pages),
        key: navigatorKey,
        onPopPage: _onPopPage,
        observers: [
          HeroController(),
        ],
        onGenerateRoute: onGenerateRoute,
      );
    }
  }

  Route<dynamic>? onGenerateRoute(RouteSettings s) {
    RouteInfo info = LegendRouter.getRouteWidget(s, _routes);

    if (info is ModalRouteInfo) {
      return LegendPopupRoute(
        settings: s,
        dependencies: modalDependencies,
        widget: info.page,
        config: PopupRouteConfig(
          aligment: Alignment.centerRight,
        ),
      );
    }
    return null;
  }

  @override
  List<Page> get currentConfiguration => List.of(_pages);

  @override
  Future<bool> popRoute() {
    if (_pages.length > 1) {
      _pages.removeLast();
      notifyListeners();
      return Future.value(true);
    }
    return Future.value(false);
  }

  bool _onPopPage(Route route, dynamic result) {
    if (!route.didPop(result)) return false;
    popRoute();
    return true;
  }

  void pushPage(Page page) {
    if (_pages.last.key == page.key) {
      _pages[_pages.length - 1] = page;
    } else {
      _pages.add(page);
    }

    notifyListeners();
  }

  @override
  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Future<void> setNewRoutePath(List<RouteSettings> configuration) {
    List<Page> pages = [];
    for (final RouteSettings s in configuration) {
      pages.add(
        LegendRouter.createPage(
          s,
          LegendRouter.getRouteWidget(s, _routes),
        ),
      );
    }

    _setPath(pages);

    return Future.value(null);
  }

  void _setPath(List<Page> pages) {
    _pages.clear();
    _pages.addAll(pages);
    if (_pages.first.name != '/') {
      _pages.insert(
        0,
        LegendRouter.createPage(
          homeRoute,
          LegendRouter.getRouteWidget(homeRoute, _routes),
        ),
      );
    }
    notifyListeners();
  }
}
