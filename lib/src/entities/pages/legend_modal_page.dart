import 'package:flutter/material.dart';
import 'package:legend_router/src/entities/pages/legend_page.dart';

class LegendModalPage extends LegendPage {
  final Widget child;

  @override
  final Map<String, dynamic>? urlArguments;

  const LegendModalPage({
    required this.child,
    this.urlArguments,
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
      pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }
}
