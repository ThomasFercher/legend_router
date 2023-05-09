import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:legend_router/src/entities/pages/legend_page.dart';
import 'package:legend_router/src/entities/frames/modal_frame.dart';
import 'package:legend_router/src/entities/routes/route_config.dart';
import 'package:legend_router/src/entities/routes/route_info.dart';
import 'package:legend_router/src/entities/routes/scaffold_route/scaffold_route.dart';
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
  final RouteInfo? Function(RouteConfig s)? onGenerateRoute;
  final bool Function(RouteInfo s)? hideRoutes;

  @override
  final GlobalKey<NavigatorState> navigatorKey;

  final Iterable<RouteInfo> _routes;
  RouteInfo? current;
  List<LegendPage<dynamic>> _pages = [];

  LegendRouterDelegate({
    required this.frame,
    this.modalDependencies,
    required Iterable<RouteInfo> routes,
    required this.navigatorKey,
    this.onGenerateRoute,
    this.hideRoutes,
  })  : _routes = routes,
        assert(routes.isNotEmpty);

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
    if (_pages.isEmpty) {
      _pages.insert(
        0,
        LegendRouter.createPage(
          homeRoute,
          LegendRouter.getRouteWidget(homeRoute, _routes) ?? notFound,
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
          onGenerateRoute: _onGenerateRoute,
        ),
        current,
      );
    }
    return Navigator(
      pages: List.of(_pages),
      key: navigatorKey,
      onPopPage: _onPopPage,
      observers: [
        HeroController(),
      ],
      onGenerateRoute: _onGenerateRoute,
      onGenerateInitialRoutes: (navigator, initialRoute) {
        return [CupertinoPageRoute(builder: (context) => Container())];
      },
    );
  }

  Route<dynamic>? _onGenerateRoute(RouteSettings s) {
    final info = LegendRouter.getRouteWidget(s, _routes);

    if (info is PageRouteInfo) {
      return ScaffoldRoute(page: info.page, settings: s);
    }

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
    if (_pages.isNotEmpty && _pages.last.key == page.key) {
      _pages[_pages.length - 1] = page;
    } else {
      _pages.add(page);
    }

    notifyListeners();
  }

  void replacePage(LegendPage page) {
    _pages.removeLast();
    pushPage(page);
  }

  void popUntil(bool Function(LegendPage<dynamic> route) predicate) {
    _pages.removeLast();
    for (var page in _pages) {
      if (predicate(page)) {
        break;
      }
      _pages.remove(page);
    }

    notifyListeners();
  }

  void clearPages(LegendPage startPage) {
    _pages.clear();
    _pages.add(startPage);

    notifyListeners();
  }

  @override
  Future<void> setNewRoutePath(configuration) {
    List<LegendPage> pages = [];
    for (final RouteConfig s in configuration) {
      final info = LegendRouter.getRouteWidget(s, _routes) ??
          onGenerateRoute?.call(s) ??
          notFound;
      final hide = hideRoutes?.call(info) ?? false;
      if (hide) {
        pages.add(
          LegendRouter.createPage(s, notFound),
        );
      } else {
        pages.add(
          LegendRouter.createPage(
            s,
            LegendRouter.getRouteWidget(s, _routes) ?? notFound,
          ),
        );
      }
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
          LegendRouter.getRouteWidget(homeRoute, _routes) ?? notFound,
        ),
      );
    }

    _pages = pages;
    notifyListeners();
  }
}
