import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:legend_router/router/route_info_provider.dart';

class LegendPage extends Page {
  final Widget child;

  const LegendPage({
    required this.child,
    required super.name,
    super.arguments,
    super.key,
  });

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      transitionDuration: const Duration(milliseconds: 240),
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return RouteInfoProvider(
          route: this,
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    );
  }
}

class LegendModalPage extends Page {
  final Widget child;

  const LegendModalPage({
    required this.child,
    required super.name,
    super.arguments,
    super.key,
  });

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      opaque: false,
      barrierColor: Colors.black12,
      barrierDismissible: true,
      fullscreenDialog: true,
      transitionDuration: const Duration(milliseconds: 240),
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }
}
