import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? shared;

void init() async {
  /*
  shared = await SharedPreferences.getInstance();*/
}

bool debugScanlines = false;
bool debugInfo = false;
bool keyboardExpanded = false;
bool web = false;
bool mobile = false;
bool square = false;
bool tablet = false;
bool projectWindowOpen = true;
bool encoderWindowOpen = false;
bool createProject = false;

void serialize() async {
  //await shared!.setBool('Modes.essence', essence);
}

void deserialize() {
  //essence = shared!.getBool('Modes.essence') ?? false;
}

