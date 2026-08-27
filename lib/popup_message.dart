import 'package:flutter/material.dart';
import 'package:gcube3/globals/anim_data.dart' as anim;
import 'package:gcube3/globals/colors.dart' as color;
import 'package:gcube3/globals/display.dart' as dsp;
import 'package:gcube3/globals/font_sizes.dart' as ft;
import 'package:gcube3/globals/gcube_assets.dart' as assets;
import 'package:gcube3/globals/mode.dart' as mode;
import 'package:gcube3/tools/stack_animated.dart' as stack;
import 'package:gcube3/tools/layout_tools.dart' as lt;

int _messageCount = 0;

void popupMessage({
  String? id,
  String? title,
  Icon? leadingSymbol,
  String? message,
  Widget? child,
  VoidCallback? onDiscard,
  VoidCallback? onAccept,
  String? messageAccept,
  VoidCallback? onDecline,
  String? messageDecline,
  double? height,
  double? width,
  Duration? duration,
  bool? bigVersion,
}) {
  int count = ++_messageCount;
  stack.data.add(
    id ?? "popMsg$count",
    PopupMessage(
      count,
      id,
      title,
      leadingSymbol,
      message,
      child,
      onDiscard,
      onAccept,
      messageAccept,
      onDecline,
      messageDecline,
      height,
      width,
      duration,
    ),
    duration ?? Duration(milliseconds: 400),
    anim.onScreenPosCenter,
    anim.offScreenPosWindows,
  );
}

class PopupMessage extends StatelessWidget {
  final String? id;
  final String? title;
  final Icon? leadingSymbol;
  final String? message;
  final Widget? child;
  final VoidCallback? onDiscard;
  final VoidCallback? onAccept;
  final String? messageAccept;
  final VoidCallback? onDecline;
  final String? messageDecline;
  final double? height;
  final double? width;
  final Duration? duration;
  final int count;

  const PopupMessage(
    this.count,
    this.id,
    this.title,
    this.leadingSymbol,
    this.message,
    this.child,
    this.onDiscard,
    this.onAccept,
    this.messageAccept,
    this.onDecline,
    this.messageDecline,
    this.height,
    this.width,
    this.duration, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (c, o) {
        double cWidth = width ?? dsp.eqPx * 70;
        double cHeight = height ?? (dsp.data.orientation == Orientation.landscape && dsp.data.showKeyboard ? dsp.eqPx * 20 : dsp.eqPx * 70);
        /*if (cHeight > 95 * dsp.eqPx && dsp.data.orientation == Orientation.landscape) {
          cHeight = dsp.eqPx * 95;
        }
        if (cWidth > 95 * dsp.eqPx && dsp.data.orientation == Orientation.portrait) {
          cWidth = dsp.eqPx * 70;
        }
        if (dsp.eqPx * dsp.data.eqMaxWindowHeight - dsp.data.insetBot < cHeight) cHeight -= dsp.data.insetBot;
        */
        return Card(
          margin: EdgeInsetsGeometry.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(dsp.eqPx * 5),
            side: BorderSide(color: color.agroBioTech, width: dsp.eqPx),
          ),
          color: color.background,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 100),
            alignment: AlignmentGeometry.center,
            height: cHeight,
            width: cWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    if (!mode.keyboardExpanded)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            alignment: AlignmentGeometry.center,
                            height: dsp.eqPx * 15,
                            width: dsp.eqPx * 15,
                            child: leadingSymbol ?? assets.gcubeIcon(width: dsp.eqPx * 12, height: dsp.eqPx * 12),
                          ),
                          Container(
                            alignment: AlignmentGeometry.center,
                            height: dsp.eqPx * 15,
                            width: dsp.eqPx * 40,
                            child: Text(
                              title ?? "Message $count",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: dsp.eqPx * ft.s),
                            ),
                          ),
                          SizedBox(
                            height: dsp.eqPx * 15,
                            width: dsp.eqPx * 15,
                            child: lt.gcubeButton(() {
                              if (onDiscard != null) {
                                onDiscard!();
                              }
                              stack.data.pop(id ?? "popMsg$count");
                            }, Icons.arrow_drop_up_outlined),
                          ),
                        ],
                      ),
                    lt.stroke(0, dsp.eqPx * 1, color.agroBioTech),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        lt.GcubeScrollView(
                          height: cHeight - (mode.keyboardExpanded ? dsp.eqPx : dsp.eqPx * 50),
                          width: cWidth - dsp.eqPx * 5,
                          child:
                              child ??
                              Text(
                                message ?? "",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: dsp.eqPx * ft.s),
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (!mode.keyboardExpanded)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          if (onAccept != null && messageAccept != null)
                            Container(
                              alignment: Alignment.center,
                              height: dsp.eqPx * 20,
                              width: dsp.eqPx * 50,
                              child: TextButton(
                                style: lt.dialogButton(height: dsp.eqPx * 20, width: dsp.eqPx * 50),
                                onPressed: () {
                                  onAccept!();
                                  stack.data.pop(id ?? "popMsg$count");
                                },
                                child: Text(
                                  messageAccept ?? "",
                                  style: TextStyle(color: Colors.black, fontSize: dsp.eqPx * ft.s),
                                ),
                              ),
                            ),
                          if (onDecline != null && messageDecline != null)
                            Container(
                              alignment: Alignment.center,
                              height: dsp.eqPx * 20,
                              width: dsp.eqPx * 50,
                              child: TextButton(
                                style: lt.dialogButton(height: dsp.eqPx * 20, width: dsp.eqPx * 50),
                                onPressed: () {
                                  onDecline!();
                                  stack.data.pop(id ?? "popMsg$count");
                                },
                                child: Text(
                                  messageDecline ?? "",
                                  style: TextStyle(color: Colors.black, fontSize: dsp.eqPx * ft.s),
                                ),
                              ),
                            ),
                        ],
                      ),
                      Container(height: dsp.eqPx * 2),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
