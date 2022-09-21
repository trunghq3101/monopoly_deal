import 'dart:async';

import 'package:flutter/material.dart';
import 'package:monopoly_deal/models/game_round.dart';
import 'package:monopoly_deal/models/player.dart';
import 'package:monopoly_deal/pages/game_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
    required this.game,
    required this.player,
  }) : super(key: key);

  final GameRound game;
  final Player player;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _content = "";
  var _buttonText = "Join";
  late Function()? _onMainBtnPressed;

  @override
  void initState() {
    super.initState();
    _onMainBtnPressed = () {
      widget.game.addPlayer(widget.player);
      _onMainBtnPressed = null;
    };
    Timer.periodic(
      const Duration(milliseconds: 200),
      (timer) async {
        final state = await widget.game.syncUp();
        switch (state) {
          case GameState.ready:
            _content = "Ready";
            _buttonText = "Start";
            _onMainBtnPressed = () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const GamePage()));
            timer.cancel();
            break;
          default:
            _content = _onMainBtnPressed == null ? "Waiting" : "";
        }
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(),
          Expanded(
              child: Text(
            _content,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline2,
          )),
          Row(
            children: [
              const Spacer(),
              Expanded(
                child: ElevatedButton(
                  onPressed: _onMainBtnPressed,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _buttonText,
                      style: Theme.of(context)
                          .textTheme
                          .headline4!
                          .copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
