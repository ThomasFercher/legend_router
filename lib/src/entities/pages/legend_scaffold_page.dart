import 'package:flutter/widgets.dart';
import 'package:legend_router/src/entities/pages/legend_page.dart';
import 'package:legend_router/src/information_provider.dart';

class LegendScaffoldPage extends LegendPage {
  final Widget child;

  @override
  final Map<String, dynamic>? urlArguments;

  const LegendScaffoldPage({
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
      transitionDuration: const Duration(milliseconds: 240),
      pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
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
