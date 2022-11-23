import 'package:flutter/widgets.dart';
import 'package:legend_router/src/entities/routes/route_info.dart';

abstract class NavigatorFrame {
  Widget buildFrame(
    BuildContext context,
    Navigator navigator,
    RouteInfo? current,
  );
}
