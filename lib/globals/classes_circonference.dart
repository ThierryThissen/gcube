Map<int, List<int>> classesCirconference = {};

void init(int n) {
  int min = 20;
  for (int i = 0; i < n; i++) {
    classesCirconference[i] = [min + i * 10, min + i * 10 + 9];
  }
}
