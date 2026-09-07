import 'package:flutter/material.dart';
import 'package:gcube3/globals/colors.dart' as color;
import 'package:gcube3/globals/state.dart' as state;
import 'package:gcube3/screens/new_project.dart';
import 'package:gcube3/screens/encoder.dart';
import 'package:gcube3/tools/stack_animated.dart' as stack;
import 'package:gcube3/globals/display.dart' as dsp;
import 'package:gcube3/globals/mode.dart' as mode;

class Gcube extends StatefulWidget {
  const Gcube({super.key});

  @override
  State<StatefulWidget> createState() => _Gcube();
}

class _Gcube extends State<Gcube> {
  int frameCount = 0;

  @override
  void initState() {
    super.initState();
    state.mainState = (void Function() it) {
      mounted
          ? setState(() {
              ++frameCount;
              it();
            })
          : it();
    };
  }

  void initApp() {
    dsp.init(context);
  }

  @override
  Widget build(BuildContext context) {
    initApp();
    return MaterialApp(
      title: 'G-Cube',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: color.agroBioTech),
        fontFamily: "Calibri",
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.transparent,
      ),
      home: Scaffold(
        resizeToAvoidBottomInset: true,
        extendBody: false,
        body: Stack(
          children:
              <Widget>[
                if (!mode.encoderWindowOpen) ProjectWindow("", "", Duration(seconds: 1)),
                if (!mode.projectWindowOpen) EncoderWindow("", "", Duration(seconds: 1)),
              ].reversed.toList() +
              stack.data.widgets,
        ),
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
