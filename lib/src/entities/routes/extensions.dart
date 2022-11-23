import 'package:legend_router/legend_router.dart';

extension RouteExtensions on List<RouteInfo> {
  List<T> get<T>() => whereType<T>().toList();

  List<RouteInfo> get expandedChildren {
    List<RouteInfo> result = [];
    for (final RouteInfo info in this) {
      result.add(info);
      if (info.children != null) {
        result.addAll(info.children!.toList().expandedChildren);
      }
    }
    return result;
  }
}
