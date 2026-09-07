bool greater(String a, String b) {
  int counter = 0;
  for (int char in a.toLowerCase().codeUnits) {
    if (counter > b.length) return true;
    if (char > b.toLowerCase().codeUnits[counter]) {
      return true;
    } else if (char < b.toLowerCase().codeUnits[counter]) {
      return false;
    }
    counter++;
  }
  return false;
}
