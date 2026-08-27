import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'mode.dart' as md;
import 'log.dart';

class Display {
  double paddingTop = -1;
  double paddingBot = -1;
  double paddingLeft = -1;
  double paddingRight = -1;
  double insetTop = -1;
  double insetBot = -1;
  double width = -1;
  double height = -1;
  double dpi = -1;
  double aspect = -1;
  Orientation orientation = Orientation.portrait;
  double equipixel = -1;
  double equiwidth = -1;
  double equiheight = -1;
  bool showKeyboard = false;

  Display.empty();

  double alignX(double px) => (2.0 / width) * (equipixel * px);
  double alignY(double px) => (2.0 / height) * (equipixel * px);

  double get eqAlignTop => paddingTop / equipixel - equiheight / 2;
  double get eqAlignBottom => -paddingBot / equipixel + equiheight / 2;
  double get eqAlignLeft => paddingLeft / equipixel - equiwidth / 2;
  double get eqAlignRight => -paddingRight / equipixel + equiwidth / 2;

  double get eqMaxWindowWidth => (width - 2 * math.max(paddingLeft, paddingRight)) / equipixel;
  double get eqMaxWindowHeight => (height - 2 * math.max(paddingTop, paddingBot)) / equipixel;
  double get maxWinPaddingHeight =>
      eqMaxWindowHeight * eqPx - insetBot > 0 ? eqMaxWindowHeight * eqPx - insetBot : eqPx;

  Display(BuildContext context) {
    paddingTop = MediaQuery.of(context).padding.top;
    paddingBot = MediaQuery.of(context).padding.bottom;
    paddingLeft = MediaQuery.of(context).padding.left;
    paddingRight = MediaQuery.of(context).padding.right;
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    aspect = MediaQuery.of(context).size.aspectRatio;
    dpi = MediaQuery.of(context).devicePixelRatio;
    orientation = MediaQuery.of(context).orientation;
    insetTop = MediaQuery.of(context).viewInsets.top;
    insetBot = MediaQuery.of(context).viewInsets.bottom;
    insetBot > 0 ? showKeyboard = true : showKeyboard = false;
    md.keyboardExpanded = showKeyboard;
    _enforceEquiWidthHeight();
  }

  set context(BuildContext context) => data = Display(context);

  void _enforceEquiWidthHeight() {
    double minEquiPixelsDisplayPortraitWidth = 200;
    double minEquiPixelsDisplayPortraitHeight = 400;
    double minEquiPixelsDisplayLandscapeWidth = 400;
    double minEquiPixelsDisplayLandscapeHeight = 200;
    if (orientation == Orientation.portrait) {
      equipixel = height / minEquiPixelsDisplayPortraitHeight;
      equiwidth = width / equipixel;
      while (equiwidth < minEquiPixelsDisplayPortraitWidth) {
        equipixel *= 0.99;
        equiwidth = width / equipixel;
      }
      equiheight = height / equipixel;
    } else {
      equipixel = width / minEquiPixelsDisplayLandscapeWidth;
      equiheight = height / equipixel;
      while (equiheight < minEquiPixelsDisplayLandscapeHeight) {
        equipixel *= 0.99;
        equiheight = height / equipixel;
      }
      equiwidth = width / equipixel;
    }
  }

  @override
  String toString() {
    return "width: $width\nheight: $height\ndpi: $dpi\naspect: $aspect\norientation: ${orientation.name}\nequipixel: $equipixel\nequiwidth: $equiwidth\nequiheight: $equiheight";
  }
}

Display data = Display.empty();

void init(BuildContext context) {
  data = Display(context);
  print(data.toString());
}

double get eqPx => data.equipixel;
double get eqPxH => data.equiheight;
double get eqPxW => data.equiwidth;
