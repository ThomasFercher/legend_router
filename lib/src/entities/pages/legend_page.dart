import 'package:flutter/widgets.dart';
import 'package:legend_router/src/entities/routes/route_config.dart';

abstract class LegendPage<T> extends Page<T> implements RouteConfig {
  const LegendPage({
    super.name,
    super.arguments,
    super.key,
    super.restorationId,
  });
}
