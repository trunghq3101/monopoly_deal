import 'dart:async';

import 'package:flutter/material.dart';
import 'package:monopoly_deal/app/lib/lib.dart';

class StartMenu extends StatelessWidget {
  const StartMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(),
          Expanded(
            child: LayoutBuilder(builder: (_, constraints) {
              return StartMenuBox(
                height: constraints.maxHeight,
              );
            }),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class StartMenuBox extends StatefulWidget {
  const StartMenuBox({
    Key? key,
    required this.height,
  }) : super(key: key);

  final double height;

  @override
  State<StartMenuBox> createState() => _StartMenuBoxState();
}

class _StartMenuBoxState extends State<StartMenuBox> {
  double _height = 0.0;
  double _opacity = 0.0;
  double _contentOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 0), () {
      setState(() {
        _height = widget.height;
        _opacity = 1;
      });
    });
    Timer(const Duration(milliseconds: 200), () {
      setState(() {
        _contentOpacity = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: UnconstrainedBox(
        constrainedAxis: Axis.horizontal,
        child: AnimatedContainer(
          height: _height,
          duration: M3Duration.medium4.duration,
          curve: M3Easing.emphasizedDecelerate.cubic,
          child: AnimatedOpacity(
            opacity: _opacity,
            duration: M3Duration.medium4.duration,
            curve: M3Easing.emphasizedDecelerate.cubic,
            child: Dialog(
              child: AnimatedOpacity(
                  opacity: _contentOpacity,
                  duration: M3Duration.short4.duration,
                  curve: M3Easing.emphasizedDecelerate.cubic,
                  child: const _StartMenuContentBox()),
            ),
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
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Spacer(flex: 2),
        Expanded(
          flex: 2,
          child: FittedBox(
            fit: BoxFit.fitHeight,
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('Create room'),
            ),
          ),
        ),
        const Spacer(flex: 1),
        Expanded(
          flex: 2,
          child: FittedBox(
            fit: BoxFit.fitHeight,
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('Join room'),
            ),
          ),
        ),
        const Spacer(flex: 2),
      ],
    );
  }
}
