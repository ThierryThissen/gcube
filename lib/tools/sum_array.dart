int _sumArray(List<int> l) => l.length == 1 ? l.removeLast() : l.removeLast() + _sumArray(l);
int sumArray(List<int> l) => _sumArray(l.toList());
