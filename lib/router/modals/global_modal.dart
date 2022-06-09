import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:legend_router/router/legend_router.dart';

import '../route_info_provider.dart';
import '../routes/route_info.dart';

///
/// In case you have two Navigators in your app and the upper Navigator is only used for modals which
/// need to be displayed over the entire app, this class provides basic functions to reduce boilerplate.
/// For Example: The AppBar should not change when a new route is pushed.
///
class GlobalModal {
  static PageRoute<T> pageRouteBuilder<T>(
    RouteSettings settings,
    Widget Function(BuildContext) builder,
  ) {
    return CupertinoPageRoute<T>(
      settings: settings,
      builder: builder,
    );
  }

  static CupertinoDialogRoute<dynamic>? modalRouteBuilder(
      RouteSettings settings, BuildContext context, WidgetBuilder builder) {
    return CupertinoDialogRoute(
      barrierDismissible: true,
      settings: settings,
      transitionDuration: const Duration(
        milliseconds: 400,
      ),

      transitionBuilder: (context, _, __, child) {
        CurvedAnimation animation = CurvedAnimation(
          parent: _,
          curve: Curves.easeInOutCirc,
        );
        Tween<AlignmentGeometry> aligment = Tween(
          begin: const Alignment(8, 0),
          end: const Alignment(1, 0),
        );
        return AlignTransition(
          alignment: aligment.animate(animation),
          child: child,
        );
      },
      //   useSafeArea: false,
      builder: (context) => RouteInfoProvider(
        route: settings,
        child: Builder(
          builder: (context) {
            return builder(context);
          },
        ),
      ),
      context: context,
    );
  }
}
