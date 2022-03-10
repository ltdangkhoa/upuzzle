bool isSorted(List list) {
  int n = list.length;
  if (n == 0 || n == 1) {
    return true;
  }
  for (int i = 1; i < n; i++) {
    if (list[i - 1] > list[i]) {
      return false;
    }
  }
  return true;
}
