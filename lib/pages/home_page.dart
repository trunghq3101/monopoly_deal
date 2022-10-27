import 'dart:async';

import 'package:flutter/material.dart';
import 'package:monopoly_deal/dev/play_ground_page.dart';
import 'package:monopoly_deal/models/game_model.dart';
import 'package:monopoly_deal/models/player_model.dart';
import 'package:monopoly_deal/repositories/game_repository.dart';
import 'package:monopoly_deal/routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
    required this.gameRepository,
  }) : super(key: key);

  final GameRepository gameRepository;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _content = "";
  var _buttonText = "Join";
  final _playGroundText = "Playground";
  late Function()? _onMainBtnPressed;
  late Function() _onPlayGroundBtnPressed;
  late GameModel _gameModel;
  late PlayerModel _player;

  @override
  void initState() {
    super.initState();
    _gameModel = GameModel(players: [], step: Steps.idle, moves: []);
    _player = PlayerModel(hand: []);
    _onMainBtnPressed = () {
      _gameModel.addPlayer(_player, widget.gameRepository);
      _onMainBtnPressed = null;
    };
    _onPlayGroundBtnPressed = () {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => const PlayGroundPage()));
    };
    Timer.periodic(
      const Duration(milliseconds: 200),
      (timer) async {
        _gameModel = await _gameModel.syncUp(widget.gameRepository);
        switch (_gameModel.gameState) {
          case GameState.ready:
            _content = "Ready";
            _buttonText = "Start";
            _onMainBtnPressed =
                () => Navigator.of(context).pushNamed(AppRoutes.game);
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
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _onPlayGroundBtnPressed,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _playGroundText,
                      style: Theme.of(context)
                          .textTheme
                          .headline4!
                          .copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
