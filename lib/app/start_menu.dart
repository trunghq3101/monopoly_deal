import 'dart:async';

import 'package:flutter/material.dart';

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
        children: const [
          Spacer(),
          Expanded(
            child: StartMenuBox(),
          ),
          Spacer(),
        ],
      ),
    );
  }
}

class StartMenuBox extends StatefulWidget {
  const StartMenuBox({
    Key? key,
  }) : super(key: key);

  @override
  State<StartMenuBox> createState() => _StartMenuBoxState();
}

class _StartMenuBoxState extends State<StartMenuBox> {
  double _scale = 0.0;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 0), () {
      setState(() {
        _scale = 0.8;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _scale,
      duration: const Duration(milliseconds: 300),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: FractionallySizedBox(
          heightFactor: 0.7,
          widthFactor: 0.9,
          child: Column(
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
          ),
        ),
      ),
    );
  }
}
