import 'package:flutter/widgets.dart';

class ModalRouter extends InheritedWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const ModalRouter({
    Key? key,
    required this.child,
    required this.navigatorKey,
  }) : super(key: key, child: child);

  final Widget child;

  static ModalRouter of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<ModalRouter>();
    assert(result != null, "No ModalRouter found in Context");
    return result!;
  }

  /// Should only be used to push Dialogs that are outside of the content or are overallaping AppBar or Sider
  void push({required RouteSettings settings, bool useKey = false}) {
    navigatorKey.currentState?.pushNamed(settings.name ?? "");
  }

  void pop() {
    navigatorKey.currentState?.pop();
  }

  @override
  bool updateShouldNotify(ModalRouter oldWidget) {
    return true;
  }
}
