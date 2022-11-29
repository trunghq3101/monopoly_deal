import 'state_machine.dart';

typedef StateToActions<S, EV> = Map<S, Map<EV, EventAction<S>>>;

class StateMachine<S, EV> {
  StateToActions<S, EV> _stateToActions = {};
  final Map<S, Function()> _stateToOnEnter = {};
  final Map<S, Function()> _stateToOnExit = {};
  late S _currentState;

  void handle(Event<EV> event) {
    assert(_stateToActions.containsKey(_currentState),
        "State $_currentState hasn't registered yet");

    final eventAction = _stateToActions[_currentState]![event.eventId];
    if (eventAction == null) return;

    _changeState(eventAction.to);
    eventAction.action(event);
  }

  void setup(StateToActions<S, EV> stateToActions) {
    _stateToActions = stateToActions;
    _currentState = _stateToActions.entries.first.key;
  }

  void setOnExit(S state, Function() onExit) {
    _stateToOnExit[state] = onExit;
  }

  void setOnEnter(S state, Function() onEnter) {
    _stateToOnEnter[state] = onEnter;
  }

  void _changeState(S newState) {
    _stateToOnExit[_currentState]?.call();
    _currentState = newState;
    _stateToOnEnter[newState]?.call();
  }
}
