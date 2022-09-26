import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  const AppCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstraintsTransformBox(
      constraintsTransform: (constraints) => constraints.loosen(),
      child: const AspectRatio(
        aspectRatio: 0.75,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.blueGrey,
            borderRadius: BorderRadius.all(Radius.circular(24)),
            border: Border.fromBorderSide(
              BorderSide(
                color: Colors.white,
                width: 10,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(25, 0, 0, 0),
                offset: Offset(2, 2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
