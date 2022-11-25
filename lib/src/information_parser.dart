import 'package:flutter/widgets.dart';
import 'package:legend_router/src/delegate.dart';
import 'package:legend_router/src/entities/routes/route_config.dart';

class LegendRouteInformationParser
    extends RouteInformationParser<LegendConfiguration> {
  const LegendRouteInformationParser();

  @override
  Future<LegendConfiguration> parseRouteInformation(
    RouteInformation routeInformation,
  ) {
    final uri = Uri.parse(routeInformation.location!);

    if (uri.pathSegments.isEmpty) {
      return Future.value(
        [
          const RouteConfig(
            name: '/',
          ),
        ],
      );
    }

    final routeSettings = uri.pathSegments.map(
      (pathSegment) {
        return RouteConfig(
          name: '/$pathSegment',
          arguments: null,
          urlArguments:
              pathSegment == uri.pathSegments.last ? uri.queryParameters : null,
        );
      },
    ).toList();
    return Future.value(routeSettings);
  }

  @override
  RouteInformation? restoreRouteInformation(configuration) {
    if (configuration.isEmpty) {
      return const RouteInformation();
    }
    final routeConfig = configuration.last;
    final name = routeConfig.name ?? '';
    final arguments = routeConfig.urlArguments.toUriArguments();
    return RouteInformation(location: '$name$arguments');
  }
}

extension ArgumentsUtil on Map<String, dynamic>? {
  String toUriArguments() {
    if (this == null || this!.isEmpty) return '';

    String arguments = '';

    for (var i = 0; i < this!.length; i++) {
      arguments += "${this!.keys.elementAt(i)}=${this!.values.elementAt(i)}";
      if (i != this!.length - 1) {
        arguments += "&";
      }
    }

    return "?$arguments";
  }
}
