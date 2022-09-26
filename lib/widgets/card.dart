import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  const AppCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, constraints) {
      return UnconstrainedBox(
        child: ConstrainedBox(
          constraints: constraints.loosen(),
          child: const AspectRatio(
            aspectRatio: 0.75,
            child: ColoredBox(
              color: Colors.blueGrey,
            ),
          ),
        ),
      );
    });
  }
}
