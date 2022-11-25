import 'package:equatable/equatable.dart';

class Event<T> extends Equatable {
  final T eventId;
  final dynamic payload;

  const Event(this.eventId, [this.payload]);

  @override
  List<Object?> get props => [eventId];
}

class EventAction<T> {
  final Function(Event event) action;
  final T to;

  EventAction(this.action, this.to);
}
