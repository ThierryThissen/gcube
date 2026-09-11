import 'package:flutter/material.dart';
import 'package:gcube3/globals/font_sizes.dart' as ft;
import 'package:gcube3/globals/gcube_assets.dart';
import 'package:gcube3/tools/gcube_project.dart';
import 'package:gcube3/tools/stack_animated.dart' as stack;
import 'package:gcube3/globals/state.dart' as state;
import 'package:gcube3/globals/display.dart' as dsp;
import 'package:gcube3/globals/mode.dart' as mode;
import 'package:gcube3/globals/colors.dart' as color;
import 'package:gcube3/tools/layout_tools.dart' as lt;

class SettingsWindow extends StatefulWidget implements stack.AnimatedWindowGCube {
  final String id;
  final String title;
  final Duration duration;

  const SettingsWindow(this.id, this.title, this.duration, {super.key});

  @override
  Offset get position => mode.settingsWindowOpen
      ? Offset(dsp.data.alignX(0), dsp.data.alignY(0))
      : Offset(dsp.data.alignX(dsp.data.eqAlignLeft), dsp.data.alignY(dsp.data.eqAlignTop));

  @override
  Offset get size => Offset(
    mode.settingsWindowOpen ? dsp.data.eqMaxWindowWidth * dsp.eqPx : 150 * dsp.eqPx,
    (mode.settingsWindowOpen ? dsp.data.eqMaxWindowHeight * dsp.eqPx : 30 * dsp.eqPx) - dsp.data.insetBot,
  );

  @override
  State<StatefulWidget> createState() => _SettingsWindow();
}

class _SettingsWindow extends State<SettingsWindow> {
  static bool inTransitionAnimation = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: widget.duration,
      alignment: mode.settingsWindowOpen
          ? AlignmentGeometry.xy(dsp.data.alignX(0), dsp.data.alignY(0))
          : AlignmentGeometry.xy(dsp.data.alignX(dsp.data.eqAlignRight - 40), dsp.data.alignY(dsp.data.eqAlignTop)),
      child: OrientationBuilder(
        builder: (c, o) {
          double cWidth = mode.settingsWindowOpen ? dsp.data.eqMaxWindowWidth * dsp.eqPx : 40 * dsp.eqPx;
          double cHeight = mode.settingsWindowOpen ? dsp.data.eqMaxWindowHeight * dsp.eqPx : 30 * dsp.eqPx;
          cHeight -= dsp.data.insetBot;
          return AnimatedContainer(
            onEnd: () {
              setState(() {
                inTransitionAnimation = false;
              });
            },
            curve: Curves.slowMiddle,
            height: cHeight,
            width: cWidth,
            duration: widget.duration,
            color: color.transparent,
            child: Card(
              margin: EdgeInsetsGeometry.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(dsp.eqPx * 0),
                side: BorderSide(color: mode.settingsWindowOpen || inTransitionAnimation ? color.gcube : color.transparent, width: dsp.eqPx * 1),
              ),
              color: color.background,
              child: AnimatedContainer(
                duration: widget.duration,
                height: cHeight,
                width: cWidth,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (!inTransitionAnimation)
                      Stack(
                        alignment: AlignmentGeometry.xy(0, 0),
                        children: [
                          SizedBox(
                            height: cHeight,
                            width: cWidth,
                            child: (mode.settingsWindowOpen || GcubeProject.isNoneSelected) && !inTransitionAnimation
                                ? SizedBox(
                                    height: cHeight,
                                    width: cWidth,
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          alignment: Alignment.topCenter,
                                          height: dsp.eqPx * 20,
                                          width: dsp.eqPx * dsp.data.eqMaxWindowWidth,
                                          child: Container(
                                            alignment: Alignment.center,
                                            height: dsp.eqPx * 20,
                                            width: dsp.eqPx * dsp.data.eqMaxWindowWidth,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                SizedBox(height: dsp.eqPx * 20, width: dsp.eqPx * 20, child: gcubeIcon(height: 40, width: 40)),
                                                Text("Paramètres projet", style: lt.titleL()),
                                                Container(
                                                  alignment: Alignment.topRight,
                                                  height: dsp.eqPx * 20,
                                                  width: dsp.eqPx * 20,
                                                  child: lt.gcubeButton(() {
                                                    state.rebuildMainStack(() {
                                                      if (!GcubeProject.isNoneSelected) {
                                                        mode.settingsWindowOpen = false;
                                                        inTransitionAnimation = true;
                                                      }
                                                    });
                                                  }, mode.settingsWindowOpen ? Icons.minimize_outlined : Icons.square_outlined),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        lt.stroke(dsp.eqPx * 1, dsp.eqPx * 1, color.gcube),
                                        lt.GcubeScrollView(
                                          width: cWidth - dsp.eqPx * 10,
                                          height: cHeight - dsp.eqPx * 30,
                                          child: Column(
                                            children: [
                                              ExpansionTile(
                                                iconColor: color.white,
                                                collapsedIconColor: color.white,
                                                title: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Equations de cubage",
                                                      style: TextStyle(color: color.white, fontSize: dsp.eqPx * ft.m),
                                                    ),
                                                  ],
                                                ),
                                                children: [_buildEquationsSetting()],
                                              ),
                                              ExpansionTile(
                                                iconColor: color.white,
                                                collapsedIconColor: color.white,
                                                title: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Export des données",
                                                      style: TextStyle(color: color.white, fontSize: dsp.eqPx * ft.m),
                                                    ),
                                                  ],
                                                ),
                                                children: [_buildEquationsExportTreeList()],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : SizedBox(
                                    height: cHeight,
                                    width: cWidth,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: dsp.eqPx * 30,
                                          width: dsp.eqPx * 150,
                                          child: lt.GcubeScrollView(
                                            horizontal: true,
                                            scrollbar: false,
                                            child: TextButton(
                                              onPressed: () {
                                                state.rebuildMainStack(() {
                                                  mode.settingsWindowOpen = true;
                                                  inTransitionAnimation = true;
                                                });
                                              },
                                              child: Icon(Icons.settings_suggest, color: color.agroBioTech, size: dsp.eqPx * 30),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEquationsSetting() {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: dsp.eqPx * 120,
              child: Text(
                "1 entrée: (circonférence)",
                style: TextStyle(color: color.white, fontSize: dsp.eqPx * ft.xs),
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  mode.equationType = 1;
                });
              },
              icon: Icon(mode.equationType == 1 ? Icons.square : Icons.square_outlined, color: color.white, size: dsp.eqPx * ft.l),
            ),
          ],
        ),
        Row(
          children: [
            SizedBox(
              width: dsp.eqPx * 120,
              child: Text(
                "2 entrées: (circonfŕence, hauteur)",
                style: TextStyle(color: color.white, fontSize: dsp.eqPx * ft.xs),
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  mode.equationType = 2;
                });
              },
              icon: Icon(mode.equationType == 2 ? Icons.square : Icons.square_outlined, color: color.white, size: dsp.eqPx * ft.l),
            ),
          ],
        ),
        Row(
          children: [
            SizedBox(
              width: dsp.eqPx * 120,
              child: Text(
                "3 entrées: (circonférence, hauteur, conique)",
                style: TextStyle(color: color.white, fontSize: dsp.eqPx * ft.xs),
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  mode.equationType = 3;
                });
              },
              icon: Icon(mode.equationType == 3 ? Icons.square : Icons.square_outlined, color: color.white, size: dsp.eqPx * ft.l),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEquationsExportTreeList() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Format",
              style: TextStyle(color: color.white, fontSize: dsp.eqPx * ft.s),
            ),
          ],
        ),
        Row(
          children: [
            TextButton(
              onPressed: () {
                setState(() {
                  mode.exportType = "xml";
                });
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty<Color>.fromMap(<WidgetStatesConstraint, Color>{
                  WidgetState.any: mode.exportType == "xml" ? color.agroBioTech : color.transparent,
                }),
              ),
              child: Text(
                "xml",
                style: TextStyle(color: color.white, fontSize: dsp.eqPx * ft.m),
              ),
            ),
            TextButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty<Color>.fromMap(<WidgetStatesConstraint, Color>{
                  WidgetState.any: mode.exportType == "csv" ? color.agroBioTech : color.transparent,
                }),
              ),
              onPressed: () {
                setState(() {
                  mode.exportType = "csv";
                });
              },
              child: Text(
                "csv",
                style: TextStyle(color: color.white, fontSize: dsp.eqPx * ft.m),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  mode.exportType = "xls";
                });
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty<Color>.fromMap(<WidgetStatesConstraint, Color>{
                  WidgetState.any: mode.exportType == "xls" ? color.agroBioTech : color.transparent,
                }),
              ),
              child: Text(
                "xls",
                style: TextStyle(color: color.white, fontSize: dsp.eqPx * ft.m),
              ),
            ),
          ],
        ),
        lt.stroke(dsp.eqPx * .5, dsp.eqPx * .5, color.gcube),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Ajouter le numéro d'observation #",
              style: TextStyle(color: color.white, fontSize: dsp.eqPx * ft.s),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextButton(
              onPressed: () {
                setState(() {
                  mode.addObservationNrToExport = true;
                });
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty<Color>.fromMap(<WidgetStatesConstraint, Color>{
                  WidgetState.any: mode.addObservationNrToExport ? color.agroBioTech : color.transparent,
                }),
              ),
              child: Text(
                "Oui",
                style: TextStyle(color: color.white, fontSize: dsp.eqPx * ft.m),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  mode.addObservationNrToExport = false;
                });
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty<Color>.fromMap(<WidgetStatesConstraint, Color>{
                  WidgetState.any: !mode.addObservationNrToExport ? color.agroBioTech : color.transparent,
                }),
              ),
              child: Text(
                "Non",
                style: TextStyle(color: color.white, fontSize: dsp.eqPx * ft.m),
              ),
            ),
          ],
        ),
        lt.stroke(dsp.eqPx * .5, dsp.eqPx * .5, color.gcube),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Ajouter un UUID v.4 par arbre",
              style: TextStyle(color: color.white, fontSize: dsp.eqPx * ft.s),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextButton(
              onPressed: () {
                setState(() {
                  mode.addUUIDToExport = true;
                });
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty<Color>.fromMap(<WidgetStatesConstraint, Color>{
                  WidgetState.any: mode.addUUIDToExport ? color.agroBioTech : color.transparent,
                }),
              ),
              child: Text(
                "Oui",
                style: TextStyle(color: color.white, fontSize: dsp.eqPx * ft.m),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  mode.addUUIDToExport = false;
                });
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty<Color>.fromMap(<WidgetStatesConstraint, Color>{
                  WidgetState.any: !mode.addUUIDToExport ? color.agroBioTech : color.transparent,
                }),
              ),
              child: Text(
                "Non",
                style: TextStyle(color: color.white, fontSize: dsp.eqPx * ft.m),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
