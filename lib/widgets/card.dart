import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  const AppCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstraintsTransformBox(
      constraintsTransform: (constraints) => constraints.loosen(),
      child: AspectRatio(
        aspectRatio: 0.75,
        child: LayoutBuilder(builder: (_, constraints) {
          final w = constraints.maxWidth;
          return DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(w * 0.1)),
              border: Border.all(
                width: w * 0.0005,
                color: const Color.fromARGB(236, 179, 179, 179),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(25, 0, 0, 0),
                  offset: Offset(w * 0.005, w * 0.005),
                  blurRadius: 1,
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(w * 0.1),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.all(Radius.circular(w * 0.05)),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
