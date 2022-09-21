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
        final state = await widget.game.fetchState();
        switch (state) {
          case GameState.ready:
            _content = "Ready";
            _buttonText = "Start";
            _onMainBtnPressed = () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => GamePage()));
            timer.cancel();
            break;
          default:
            _content = "Waiting";
        }
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_content),
          ElevatedButton(
            onPressed: _onMainBtnPressed,
            child: Text(_buttonText),
          )
        ],
      ),
    );
  }
}
