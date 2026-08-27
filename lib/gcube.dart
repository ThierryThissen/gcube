import 'package:flutter/material.dart';
import 'package:gcube3/globals/colors.dart' as color;
import 'package:gcube3/globals/state.dart' as state;
import 'package:gcube3/main_project_window.dart';
import 'package:gcube3/tools/stack_animated.dart' as stack;
import 'package:gcube3/globals/display.dart' as dsp;

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

  @override
  Widget build(BuildContext context) {
    dsp.init(context);
    if (stack.data.widgets.isEmpty) {
      popupProjectWindow();
    }
    return MaterialApp(
      title: 'G-Cube',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: color.agroBioTech),
        fontFamily: "Calibri",
        useMaterial3: true,
      ),
      home: Stack(children: stack.data.widgets.reversed.toList() + []),
    );
  }
}
