extension IterableExt<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T element) test) {
    try {
      return firstWhere(test);
    } on StateError catch (e) {
      if (e.message == "No element") return null;
      rethrow;
    }
  }
}
