import 'package:equatable/equatable.dart';

class Card with EquatableMixin {
  Card({required this.id});

  final int id;
  bool previewing = false;

  @override
  List<Object?> get props => [id, previewing];
}
