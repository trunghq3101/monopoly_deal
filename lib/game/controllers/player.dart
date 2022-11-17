import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:monopoly_deal/game/game.dart';

class Player extends Component with HasGameReference {
  Player({required this.broadcaster});

  final PlayerBroadcaster broadcaster;

  void _pickUpCards({required List<CardBack> facingDownCards}) {
    const timeStep = 0.1;
    for (var i = 0; i < facingDownCards.length; i++) {
      final card = facingDownCards[i];
      card.addAll([
        RotateEffect.to(
          0,
          DelayedEffectController(
            LinearEffectController(0.1),
            delay: timeStep * i,
          ),
        ),
        MoveEffect.to(
          Vector2(0, 9000),
          DelayedEffectController(
            CurvedEffectController(0.3, Curves.easeInCubic),
            delay: timeStep * i,
          ),
        )
      ]);
    }
  }

  void _listenToBroadcaster() {
    switch (broadcaster.event) {
      case PlayerEvent.tapPickUpRegion:
        _pickUpCards(facingDownCards: broadcaster.aboutToPickUpCards!);
        break;
      default:
    }
  }

  @override
  void onMount() {
    broadcaster.addListener(_listenToBroadcaster);
  }

  @override
  void onRemove() {
    broadcaster.removeListener(_listenToBroadcaster);
  }
}

enum PlayerEvent {
  tapPickUpRegion,
}

class PlayerBroadcaster extends ChangeNotifier {
  PlayerEvent? event;
  List<CardBack>? aboutToPickUpCards;

  void tapPickUpRegion({required List<CardBack> withCards}) {
    event = PlayerEvent.tapPickUpRegion;
    aboutToPickUpCards = withCards;
    notifyListeners();
  }
}
