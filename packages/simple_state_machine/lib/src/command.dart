part of simple_state_machine;

class Command<T> {
  final int id;
  T? payload;

  Command(this.id, [this.payload]);

  @override
  bool operator ==(Object other) => other is Command && other.id == id;

  @override
  int get hashCode => id;
}
