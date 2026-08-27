import 'package:flutter/material.dart';
import 'package:gcube3/gcube.dart';
import 'package:gcube3/globals/mode.dart' as mode;
import 'package:gcube3/globals/log.dart' as log;

void main() {
  mode.init();

  log.print("finished initializing, running app.");
  runApp(const Gcube());
}
