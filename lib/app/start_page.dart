import 'package:flutter/material.dart';
import 'package:monopoly_deal/app/app.dart';
import 'package:monopoly_deal/app/lib/lib.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: M3Duration.short4,
            builder: (context, value, child) => Opacity(
              opacity: value,
              child: child,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints.expand(),
              child: const ColoredBox(
                color: Colors.black54,
              ),
            ),
          ),
          const StartMenu()
        ],
      ),
    );
  }
}
