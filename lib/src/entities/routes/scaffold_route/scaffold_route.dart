import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const kTransistionDuration = Duration(milliseconds: 300);

class ScaffoldRoute<T> extends PageRoute<T>
    with MaterialRouteTransitionMixin<T> {
  ScaffoldRoute({
    this.maintainState = true,
    this.transitionDuration = kTransistionDuration,
    required this.page,
    required super.settings,
  });

  final Widget page;

  @override
  final bool maintainState;

  @override
  final Duration transitionDuration;

  @override
  Widget buildContent(BuildContext context) => page;
}
