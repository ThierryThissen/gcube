import 'package:flutter/material.dart';
import 'package:gcube3/gcube.dart';
import 'package:gcube3/globals/mode.dart' as mode;
import 'package:gcube3/globals/log.dart' as log;
import 'globals/classes_circonference.dart' as circ;

void main() {
  mode.init();
  circ.init(28);

  log.print("finished initializing, running app.");
  runApp(const Gcube());
}
