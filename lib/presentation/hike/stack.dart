class Stack<T> {
  final List<T> _stack = [];

  void push(T element) {
    _stack.add(element);
  }

  T pop() {
    if (_stack.isEmpty) {
      throw StateError("No elements in the Stack");
    } else {
      T lastElement = _stack.last;
      _stack.removeLast();
      return lastElement;
    }
  }

  T top() {
    if (_stack.isEmpty) {
      throw StateError("No elements in the Stack");
    } else {
      return _stack.last;
    }
  }

  bool isEmpty() {
    return _stack.isEmpty;
  }

  @override
  String toString() => _stack.toString();
}
