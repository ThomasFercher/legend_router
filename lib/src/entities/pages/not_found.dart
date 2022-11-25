import 'package:flutter/material.dart';
import 'package:legend_router/src/router.dart';

class NotFound extends StatelessWidget {
  const NotFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: const [
            Text(
              "404",
              style: TextStyle(fontSize: 128),
            ),
            Text(
              "Page not Found",
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => LegendRouter.of(context).pushPage('/'),
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Text(
                "Head back home",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.blueAccent,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
