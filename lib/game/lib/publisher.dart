import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flame/components.dart';

class PublisherComponent extends Component with Publisher {
  @override
  void onRemove() {
    _subscribers.clear();
    super.onRemove();
  }
}

mixin Publisher {
  final List<Subscriber> _subscribers = [];

  UnmodifiableListView<Subscriber> get subscribers =>
      UnmodifiableListView(_subscribers);

  void addSubscriber(Subscriber subscriber) {
    _subscribers.add(subscriber);
  }

  void removeSubscriber(Subscriber subscriber) {
    _subscribers.remove(subscriber);
  }

  void notify(Event event) {
    _cleanRemovedComponents();
    for (var s in _subscribers) {
      s.onNewEvent(event);
    }
  }

  void _cleanRemovedComponents() {
    final pendingRemoved = [];
    for (var s in _subscribers) {
      if (s is Component && (s as Component).isRemoved) {
        pendingRemoved.add(s);
      }
    }
    for (var s in pendingRemoved) {
      removeSubscriber(s);
    }
  }
}

mixin Subscriber {
  void onNewEvent(Event event);
}

class Event with EquatableMixin {
  Event(this.eventIdentifier);

  final Object eventIdentifier;
  Object? payload;
  Object? reverseEvent;
  Object? reversePayload;

  @override
  List<Object?> get props =>
      [eventIdentifier, payload, reverseEvent, reversePayload];
}
