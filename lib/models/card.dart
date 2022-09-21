import 'dart:collection';

import 'package:equatable/equatable.dart';

class Card extends Equatable {
  const Card(this.name);

  final String name;

  @override
  List<Object?> get props => [name];
}

class CardDeck {
  CardDeck({required this.initial}) : remaining = Queue.from(initial);

  final List<Card> initial;
  late Queue<Card> remaining;

  Card draw() {
    return remaining.removeLast();
  }
}
