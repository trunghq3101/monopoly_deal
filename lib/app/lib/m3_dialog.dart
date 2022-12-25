import 'package:flutter/material.dart';
import 'package:monopoly_deal/app/lib/lib.dart';

class M3Dialog extends StatelessWidget {
  const M3Dialog({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: M3Duration.long2,
      curve: M3Curves.emphasizedDecelerate,
      builder: (context, value, child) {
        return Align(
          alignment: Alignment.center -
              const Alignment(0, 0.3) +
              const Alignment(0, 0.3) * value,
          child: Opacity(
            opacity: value,
            child: ClipRRect(
              clipper: RRectClipper(
                borderRadius: const BorderRadius.all(Radius.circular(28)),
                fractionY: value,
              ),
              child: child,
            ),
          ),
        );
      },
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 280, maxWidth: 560),
        child: Material(
          color: Theme.of(context).colorScheme.surface,
          type: MaterialType.card,
          borderRadius: const BorderRadius.all(Radius.circular(28)),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: child,
          ),
        ),
      ),
    );
  }
}

class RRectClipper extends CustomClipper<RRect> {
  final double fractionX;
  final double fractionY;
  final BorderRadiusGeometry borderRadius;

  RRectClipper(
      {required this.borderRadius, this.fractionX = 1, this.fractionY = 1});

  @override
  RRect getClip(Size size) {
    return borderRadius.resolve(TextDirection.ltr).toRRect(
        Offset.zero & Size(size.width * fractionX, size.height * fractionY));
  }

  @override
  bool shouldReclip(CustomClipper<RRect> oldClipper) =>
      oldClipper is RRectClipper &&
      (fractionX != oldClipper.fractionX || fractionY != oldClipper.fractionY);
}
