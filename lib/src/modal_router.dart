import 'package:flutter/widgets.dart';

class ModalRouter extends InheritedWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const ModalRouter({
    super.key,
    required super.child,
    required this.navigatorKey,
  });

  static ModalRouter of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<ModalRouter>();
    assert(result != null, "No ModalRouter found in Context");
    return result!;
  }

  /// Should only be used to push Dialogs that are outside of the content or are overallaping AppBar or Sider
  void push(
    String route, {
    Object? arguments,
  }) {
    navigatorKey.currentState?.pushNamed(route, arguments: arguments);
  }

  void pop() {
    navigatorKey.currentState?.pop();
  }

  @override
  bool updateShouldNotify(ModalRouter oldWidget) {
    return true;
  }
}
