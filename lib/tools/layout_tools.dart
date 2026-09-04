import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gcube3/globals/colors.dart' as color;
import 'package:gcube3/globals/display.dart' as dsp;
import 'package:gcube3/globals/font_sizes.dart' as ft;

Widget stroke(double space, double thickness, Color color, {bool vertical = false, double height = 10}) {
  return vertical
      ? Row(
          children: [
            SizedBox(width: space),
            Container(height: dsp.eqPx * height, width: thickness, color: color),
            SizedBox(width: space),
          ],
        )
      : Column(
          children: [
            SizedBox(height: space),
            Container(height: thickness, color: color),
            SizedBox(height: space),
          ],
        );
}

Widget gridlines() {
  double equiPixelPerLine = dsp.eqPx * 4;
  return Stack(
    children:
        List<Widget>.generate((dsp.data.width / equiPixelPerLine).round(), (i) {
          return Container(
            alignment: AlignmentGeometry.xy((1.0 - (2.0 / (dsp.data.width / equiPixelPerLine).round() * i)), 0),
            child: Container(height: dsp.data.height, width: 1, color: Colors.black),
          );
        }) +
        List<Widget>.generate((dsp.data.height / equiPixelPerLine).round(), (i) {
          return Container(
            alignment: AlignmentGeometry.xy(0, (1.0 - (2.0 / (dsp.data.height / equiPixelPerLine).round() * i))),
            child: Container(height: 1, width: dsp.data.width, color: Colors.black),
          );
        }),
  );
}

ButtonStyle borderlessButton = ButtonStyle(
  animationDuration: Duration(seconds: 1),
  backgroundColor: WidgetStateProperty<Color>.fromMap(<WidgetStatesConstraint, Color>{WidgetState.any: Colors.transparent}),
  padding: WidgetStateProperty<EdgeInsetsGeometry>.fromMap(<WidgetStatesConstraint, EdgeInsetsGeometry>{WidgetState.any: EdgeInsetsGeometry.zero}),
);

ButtonStyle gcubeBrown = ButtonStyle(
  animationDuration: Duration(seconds: 1),
  backgroundColor: WidgetStateProperty<Color>.fromMap(<WidgetStatesConstraint, Color>{WidgetState.any: Colors.green}),
  padding: WidgetStateProperty<EdgeInsetsGeometry>.fromMap(<WidgetStatesConstraint, EdgeInsetsGeometry>{WidgetState.any: EdgeInsetsGeometry.zero}),
);

ButtonStyle dialogButton({
  double width = 0,
  double height = 0,
  Color col = color.gcube,
  double borderWidth = 0,
}) {
  return ButtonStyle(
    backgroundColor: WidgetStateProperty.fromMap(<WidgetStatesConstraint, Color>{
      WidgetState.any: col.withAlpha(200),
    }),
    shape: WidgetStateProperty<OutlinedBorder>.fromMap(<WidgetStatesConstraint, OutlinedBorder>{
      WidgetState.any: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(12.0),
        side: BorderSide(color: col, width: borderWidth),
      ),
    }),
    fixedSize: WidgetStateProperty.fromMap(<WidgetStatesConstraint, Size>{
      WidgetState.any: Size(
        width == 0 ? dsp.eqPx * 30 : width,
        height == 0 ? dsp.eqPx * 15 : height,
      ),
    }),
    padding: WidgetStateProperty.fromMap(<WidgetStatesConstraint, EdgeInsetsGeometry>{
      WidgetState.any: EdgeInsetsGeometry.zero,
    }),
  );
}

class ValidTextField extends StatefulWidget {
  final VoidCallback onTap;
  final VoidCallback onEditingComplete;
  final bool Function(String) validate;
  final ValueChanged<String> onValid;
  final ValueChanged<String> onInvalid;
  final Color validColor;
  final Color invalidColor;
  final double width;
  final double height;
  final int maxLength;
  final String initialValue;

  const ValidTextField({
    super.key,
    required this.width,
    required this.height,
    required this.validate,
    required this.onValid,
    required this.onInvalid,
    required this.onTap,
    required this.onEditingComplete,
    this.validColor = Colors.white,
    this.invalidColor = Colors.red,
    this.maxLength = 255,
    this.initialValue = "",
  });

  @override
  State<StatefulWidget> createState() => _ValidTextField();
}

class _ValidTextField extends State<ValidTextField> {
  bool _valid = true;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: TextFormField(
        initialValue: widget.initialValue,
        maxLength: widget.maxLength,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        onChanged: (String value) {
          setState(() {
            _valid = widget.validate(value);
          });
          _valid ? widget.onValid(value) : widget.onInvalid(value);
        },
        onEditingComplete: widget.onEditingComplete,
        onTap: () => widget.onTap,
        style: TextStyle(color: _valid ? widget.validColor : widget.invalidColor),
      ),
    );
  }
}

ButtonStyle get trNoPadButtonstyle => ButtonStyle(
  animationDuration: Duration(seconds: 1),
  backgroundColor: WidgetStateProperty<Color>.fromMap(<WidgetStatesConstraint, Color>{WidgetState.any: Colors.transparent}),
  padding: WidgetStateProperty<EdgeInsetsGeometry>.fromMap(<WidgetStatesConstraint, EdgeInsetsGeometry>{WidgetState.any: EdgeInsetsGeometry.zero}),
);

class GcubeScrollView extends StatefulWidget {
  const GcubeScrollView({
    super.key,
    this.height,
    this.width,
    required this.child,
    this.reverse = false,
    this.horizontal = false,
    this.arrowColor,
    this.sizeArrows,
    this.scrollbar = true,
    this.id,
  });
  final double? height;
  final double? width;
  final Widget child;
  final bool reverse;
  final bool horizontal;
  final Color? arrowColor;
  final double? sizeArrows;
  final bool scrollbar;
  final String? id;

  @override
  State<StatefulWidget> createState() => _GcubeScrollView();
}

class _GcubeScrollView extends State<GcubeScrollView> {
  final ScrollController _controller = ScrollController();

  bool _atTop = true;
  bool _atBottom = true;

  void _scrollTo(int element) {
    _controller.animateTo(dsp.eqPx * (element * ft.l - dsp.eqPxW / 4), duration: Duration(milliseconds: 300), curve: Curves.fastOutSlowIn);
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _atBottom = _atTop = false;
        if (_controller.position.maxScrollExtent < 0) {
          return;
        }
        if (_controller.offset < 10) {
          _atTop = true;
        }
        if (_controller.position.maxScrollExtent - _controller.offset < 10) {
          _atBottom = true;
        }
      });
    });
    if (widget.id != null && widget.id == "geoScrollBar") {
      switch (widget.id) {
        case "geoScrollBar":
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollTo(0);
          });
          break;

        default:
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _controller.jumpTo(5);
          });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = widget.width ?? dsp.eqPx * 65;
    double height = widget.height ?? dsp.eqPx * 20;
    double sizeArrows = widget.sizeArrows ?? width * .1;
    return Container(
      padding: EdgeInsets.zero,
      alignment: Alignment.center,
      width: width,
      height: height,
      child: Stack(
        children: [
          widget.scrollbar
              ? Scrollbar(
                  scrollbarOrientation: widget.horizontal ? ScrollbarOrientation.top : ScrollbarOrientation.right,
                  thickness: widget.horizontal ? height * .02 : width * .02,
                  controller: _controller,
                  child: SingleChildScrollView(
                    controller: _controller,
                    padding: EdgeInsets.zero,
                    reverse: widget.reverse,
                    scrollDirection: widget.horizontal ? Axis.horizontal : Axis.vertical,
                    child: widget.child,
                  ),
                )
              : SingleChildScrollView(
                  controller: _controller,
                  padding: EdgeInsets.zero,
                  reverse: widget.reverse,
                  scrollDirection: widget.horizontal ? Axis.horizontal : Axis.vertical,
                  child: widget.child,
                ),
          widget.horizontal
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      height: height,
                      width: sizeArrows,
                      child: !_atTop ? Icon(Icons.arrow_left_outlined, color: widget.arrowColor ?? Colors.red, size: sizeArrows) : Container(),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      height: height,
                      width: sizeArrows,
                      child: !_atBottom ? Icon(Icons.arrow_right_outlined, color: widget.arrowColor ?? Colors.red, size: sizeArrows) : Container(),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.topCenter,
                      height: sizeArrows,
                      width: width,
                      child: !_atTop ? Icon(Icons.arrow_drop_up_outlined, color: widget.arrowColor ?? Colors.red, size: sizeArrows) : Container(),
                    ),
                    Container(
                      alignment: Alignment.bottomCenter,
                      height: sizeArrows,
                      width: width,
                      child: !_atBottom
                          ? Icon(Icons.arrow_drop_down_outlined, color: widget.arrowColor ?? Colors.red, size: sizeArrows)
                          : Container(),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}

Widget gcubeButton(VoidCallback onPressed, IconData icon, {double? iconSize}) {
  return Stack(
    alignment: AlignmentGeometry.center,
    children: [
      CircleAvatar(
        radius: dsp.eqPx * (ft.s - 1.5),
        backgroundColor: Colors.white,
        child: CircleAvatar(radius: dsp.eqPx * (ft.s - 1.75), backgroundColor: color.agroBioTech),
      ),
      IconButton(
        alignment: Alignment.center,
        style: trNoPadButtonstyle,
        onPressed: () {
          onPressed();
        },
        icon: Icon(icon, color: Colors.black, size: iconSize ?? dsp.eqPx * ft.m),
      ),
    ],
  );
}

TextStyle titleL() => TextStyle(fontSize: dsp.eqPx * ft.l, color: Colors.white);
TextStyle L() => TextStyle(fontSize: dsp.eqPx * ft.m, color: Colors.white);
TextStyle capitalFirst({double? size, Color? color}) => TextStyle(fontSize: size ?? dsp.eqPx * ft.xxl, color: color ?? Colors.white);
TextStyle capitalAfter({double? size, Color? color}) => TextStyle(fontSize: size ?? dsp.eqPx * ft.l, color: color ?? Colors.white);
