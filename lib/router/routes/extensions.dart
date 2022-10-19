import 'package:legend_router/legend_router.dart';

extension RouteExtensions on List<RouteInfo> {
  List<T> get<T>() => whereType<T>().toList();
}
