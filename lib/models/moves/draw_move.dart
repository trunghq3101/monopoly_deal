import 'move.dart';

class DrawMove extends GameMove {
  DrawMove({
    required super.player,
    required this.amount,
  });

  final int amount;

  @override
  void move() {}
}
