import 'state_machine.dart';

typedef StateToActions<S, EV> = Map<S, Map<EV, EventAction<S>>>;

class StateMachine<S, EV> {
  StateToActions<S, EV> _stateToActions = {};
  late S _currentState;

  void handle(Event<EV> event) {
    assert(_stateToActions.containsKey(_currentState),
        "State $_currentState hasn't registered yet");

    final eventAction = _stateToActions[_currentState]![event.eventId];
    if (eventAction == null) return;

    _currentState = eventAction.to;
    eventAction.action(event);
  }

  void setup(StateToActions<S, EV> stateToActions) {
    _stateToActions = stateToActions;
    _currentState = _stateToActions.entries.first.key;
  }
}
