import 'package:flutter/material.dart';
import 'package:monopoly_deal/app/lib/lib.dart';

class StartMenu extends StatelessWidget {
  const StartMenu({super.key});

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
          child: const Padding(
            padding: EdgeInsets.all(24),
            child: _StartMenuContentBox(),
          ),
        ),
      ),
    );
  }
}

class _StartMenuContentBox extends StatelessWidget {
  const _StartMenuContentBox({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          onPressed: () {},
          child: const Text('Create room'),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () {},
          child: const Text('Join room'),
        ),
      ],
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
