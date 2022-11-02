class Command {
  final int id;

  Command(this.id);

  @override
  bool operator ==(Object other) => other is Command && other.id == id;

  @override
  int get hashCode => id;
}
