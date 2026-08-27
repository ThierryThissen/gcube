const String gCubeVersion = "0.0.1 - build 1"; //03/2026

List<String> _onboardLog = [gCubeVersion];

void print(dynamic it) {
  _onboardLog.add("${DateTime.now().toString()}\n${it.toString()}");
}

List<String> get lines => _onboardLog;
