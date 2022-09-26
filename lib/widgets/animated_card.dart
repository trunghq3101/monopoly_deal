import 'dart:math';

import 'package:flutter/material.dart';
import 'package:monopoly_deal/widgets/card.dart';

class AnimatedAppCardController extends ChangeNotifier {
  Offset offset = Offset.zero;
  double angle = 0;

  void deal({required Offset to, double? angle}) {
    offset = to;
    this.angle = angle ?? pi + Random().nextInt(4) * pi / 4;
    notifyListeners();
  }
}

class AnimatedAppCard extends StatelessWidget {
  const AnimatedAppCard({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final AnimatedAppCardController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, child) => TweenAnimationBuilder(
        tween: Tween<Offset>(begin: Offset.zero, end: controller.offset),
        duration: const Duration(milliseconds: 300),
        builder: (_, Offset value, child) => Transform.translate(
          offset: value,
          child: child,
        ),
        child: TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: controller.angle),
          duration: const Duration(milliseconds: 300),
          builder: (_, double value, child) {
            return Transform.rotate(
              angle: value,
              child: child,
            );
          },
          child: child,
        ),
      ),
      child: const AppCard(),
    );
  }
}
