import 'package:flutter/material.dart';
import 'package:gcube3/globals/display.dart' as dsp;
import 'package:gcube3/globals/font_sizes.dart' as ft;

Widget gcubeIcon({double width = 0, double height = 0}) {
  return Container(
    padding: EdgeInsets.only(right: dsp.eqPx * 2),
    width: width == 0 ? dsp.eqPx * ft.xs : width,
    height: height == 0 ? dsp.eqPx * ft.xs : height,
    child: Image.asset("assets/images/LogsAlphaBackground.png"),
  );
}
