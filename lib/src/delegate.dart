import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:legend_router/src/entities/pages/legend_page.dart';
import 'package:legend_router/src/entities/frames/modal_frame.dart';
import 'package:legend_router/src/entities/routes/route_config.dart';
import 'package:legend_router/src/entities/routes/route_info.dart';
import 'entities/frames/scaffold_frame.dart';
import 'router.dart';
import 'entities/routes/popup_route/legend_popup_route.dart';
import 'entities/routes/popup_route/popup_route_config.dart';

const RouteConfig homeRoute = RouteConfig(name: '/');

typedef LegendConfiguration = List<RouteConfig>;

class LegendRouterDelegate extends RouterDelegate<LegendConfiguration>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<LegendConfiguration> {
  final NavigatorFrame? frame;
  final ModalDependencies? modalDependencies;

  List<LegendPage<dynamic>> _pages = [];

  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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
      return frame!.buildFrame(
        context,
        Navigator(
          pages: List.of(_pages),
          key: navigatorKey,
          onPopPage: _onPopPage,
          onGenerateRoute: onGenerateRoute,
        ),
        current,
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
  LegendConfiguration get currentConfiguration => _pages;

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

  void pushPage(LegendPage page) {
    if (_pages.last.key == page.key) {
      _pages[_pages.length - 1] = page;
    } else {
      _pages.add(page);
    }

    notifyListeners();
  }

  @override
  Future<void> setNewRoutePath(configuration) {
    List<LegendPage> pages = [];
    for (final RouteConfig s in configuration) {
      pages.add(
        LegendRouter.createPage(
          s,
          LegendRouter.getRouteWidget(s, _routes),
        ),
      );
    }

    _setPath(pages);

    return SynchronousFuture(null);
  }

  void _setPath(List<LegendPage> pages) {
    if (pages.first.name != '/') {
      pages.insert(
        0,
        LegendRouter.createPage(
          homeRoute,
          LegendRouter.getRouteWidget(homeRoute, _routes),
        ),
      );
    }

    _pages = pages;
    notifyListeners();
  }
}
