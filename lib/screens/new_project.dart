import 'package:flutter/material.dart';
import 'package:gcube3/globals/font_sizes.dart' as ft;
import 'package:gcube3/globals/gcube_assets.dart';
import 'package:gcube3/popup_message.dart';
import 'package:gcube3/tools/gcube_project.dart';
import 'package:gcube3/tools/stack_animated.dart' as stack;
import 'package:gcube3/globals/state.dart' as state;
import 'package:gcube3/globals/display.dart' as dsp;
import 'package:gcube3/globals/mode.dart' as mode;
import 'package:gcube3/globals/colors.dart' as color;
import 'package:gcube3/tools/layout_tools.dart' as lt;

class ProjectWindow extends StatefulWidget implements stack.AnimatedWindowGCube {
  final String id;
  final String title;
  final Duration duration;

  const ProjectWindow(this.id, this.title, this.duration, {super.key});

  @override
  Offset get position => mode.projectWindowOpen
      ? Offset(dsp.data.alignX(0), dsp.data.alignY(0))
      : Offset(dsp.data.alignX(dsp.data.eqAlignLeft), dsp.data.alignY(dsp.data.eqAlignTop));

  @override
  Offset get size => Offset(
    mode.projectWindowOpen ? dsp.data.eqMaxWindowWidth * dsp.eqPx : 150 * dsp.eqPx,
    (mode.projectWindowOpen ? dsp.data.eqMaxWindowHeight * dsp.eqPx : 30 * dsp.eqPx) - dsp.data.insetBot,
  );

  @override
  State<StatefulWidget> createState() => _ProjectWindow();
}

class _ProjectWindow extends State<ProjectWindow> {
  static bool inTransitionAnimation = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: widget.duration,
      alignment: mode.projectWindowOpen
          ? AlignmentGeometry.xy(dsp.data.alignX(0), dsp.data.alignY(0))
          : AlignmentGeometry.xy(dsp.data.alignX(dsp.data.eqAlignLeft), dsp.data.alignY(dsp.data.eqAlignTop)),
      child: OrientationBuilder(
        builder: (c, o) {
          double cWidth = mode.projectWindowOpen ? dsp.data.eqMaxWindowWidth * dsp.eqPx : 80 * dsp.eqPx;
          double cHeight = mode.projectWindowOpen ? dsp.data.eqMaxWindowHeight * dsp.eqPx : 80 * dsp.eqPx;
          cHeight -= dsp.data.insetBot;
          int cAxisCount = (dsp.eqPx * dsp.data.eqMaxWindowWidth / 150).round();
          if (cAxisCount < 2) {
            cAxisCount = 2;
          }
          double cpWinSide = cWidth * .96 / cAxisCount;
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
                side: BorderSide(color: mode.projectWindowOpen || inTransitionAnimation ? color.gcube : color.transparent, width: dsp.eqPx * 1),
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
                            child: (mode.projectWindowOpen || GcubeProject.isNoneSelected) && !inTransitionAnimation
                                ? SizedBox(
                                    height: cHeight,
                                    width: cWidth,
                                    child: Column(
                                      children: [
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
                                                Text("Projets G-Cube", style: lt.titleL()),
                                                Container(
                                                  alignment: Alignment.topRight,
                                                  height: dsp.eqPx * 20,
                                                  width: dsp.eqPx * 20,
                                                  child: lt.gcubeButton(() {
                                                    state.rebuildMainStack(() {
                                                      if (!GcubeProject.isNoneSelected) {
                                                        mode.projectWindowOpen = false;
                                                        inTransitionAnimation = true;
                                                      }
                                                    });
                                                  }, mode.projectWindowOpen ? Icons.minimize_outlined : Icons.square_outlined),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        lt.stroke(dsp.eqPx * 1, dsp.eqPx * 1, color.gcube),
                                        SizedBox(
                                          height: cHeight - dsp.eqPx * 25,
                                          width: cWidth,
                                          child: GridView.count(
                                            crossAxisCount: cAxisCount,
                                            children:
                                                <Widget>[
                                                  TextButton(
                                                    style: lt.borderlessButton,
                                                    onPressed: () {
                                                      state.rebuildMainStack(() {
                                                        setState(() {
                                                          mode.createProject = true;
                                                          String it = "Nouveau ${GcubeProject.nProjects + 1}";
                                                          popupMessage(
                                                            width:
                                                                (dsp.data.eqMaxWindowWidth - 5 > 120 ? 120 : dsp.data.eqMaxWindowWidth - 5) *
                                                                dsp.eqPx,
                                                            height: dsp.eqPx * 100,
                                                            title: "Nouveau projet",
                                                            messageAccept: "Créer",
                                                            onAccept: () {
                                                              state.rebuildMainStack(() {
                                                                setState(() {
                                                                  GcubeProject.addProject(it);
                                                                  GcubeProject.selected = GcubeProject.allProjects.last;
                                                                  mode.createProject = false;
                                                                });
                                                              });
                                                            },
                                                            messageDecline: "Annuler",
                                                            onDecline: () {
                                                              state.rebuildMainStack(() {
                                                                setState(() {
                                                                  mode.createProject = false;
                                                                });
                                                              });
                                                            },
                                                            onDiscard: () {
                                                              state.rebuildMainStack(() {
                                                                setState(() {
                                                                  mode.createProject = false;
                                                                });
                                                              });
                                                            },
                                                            child: SizedBox(
                                                              child: TextField(
                                                                onChanged: (String value) {
                                                                  state.rebuildMainStack(() {
                                                                    it = value;
                                                                  });
                                                                },
                                                                style: TextStyle(color: color.agroBioTech, fontSize: dsp.eqPx * ft.s),
                                                                decoration: InputDecoration(
                                                                  hintText: "Nom du projet",
                                                                  hintStyle: TextStyle(
                                                                    color: color.agroBioTech.withAlpha(128),
                                                                    fontSize: dsp.eqPx * ft.s,
                                                                  ),
                                                                  enabledBorder: UnderlineInputBorder(
                                                                    borderSide: BorderSide(color: color.agroBioTech),
                                                                  ),
                                                                  focusedBorder: UnderlineInputBorder(
                                                                    borderSide: BorderSide(color: color.agroBioTech),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        });
                                                      });
                                                    },
                                                    child: Container(
                                                      alignment: Alignment.center,
                                                      height: cpWinSide * .9,
                                                      width: cpWinSide * .9,
                                                      child: Card(
                                                        margin: EdgeInsetsGeometry.zero,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadiusGeometry.circular(
                                                            mode.createProject ? dsp.eqPx * 0 : dsp.eqPx * 5,
                                                          ),
                                                          side: BorderSide(color: color.uliege, width: dsp.eqPx * 1),
                                                        ),
                                                        color: color.background,
                                                        child: AnimatedContainer(
                                                          duration: widget.duration,
                                                          color: mode.createProject ? color.back.withAlpha(128) : color.transparent,
                                                          height: mode.createProject ? cpWinSide : cpWinSide * .85,
                                                          width: mode.createProject ? cpWinSide : cpWinSide * .85,
                                                          child: Stack(
                                                            alignment: AlignmentGeometry.center,
                                                            children: [
                                                              Container(
                                                                alignment: Alignment.topCenter,
                                                                child: Icon(Icons.add, color: color.agroBioTech, size: cpWinSide * .75),
                                                              ),
                                                              Container(
                                                                alignment: Alignment.bottomCenter,
                                                                child: Text(
                                                                  "Ajouter",
                                                                  style: lt.capitalAfter(size: cpWinSide * .1, color: color.agroBioTech),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ] +
                                                List<Widget>.generate(GcubeProject.nProjects, (int index) {
                                                  return _projectTile(cpWinSide, GcubeProject.allProjects[index], () {
                                                    state.rebuildMainStack(() {
                                                      setState(() {
                                                        GcubeProject.selected = GcubeProject.allProjects[index];
                                                      });
                                                    });
                                                  });
                                                }),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : _projectTile(cHeight, GcubeProject.selected, () {
                                    state.rebuildMainStack(() {
                                      setState(() {
                                        mode.projectWindowOpen = true;
                                        inTransitionAnimation = true;
                                      });
                                    });
                                  }),
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

  Widget _projectTile(double cpWinSide, GcubeProject current, void Function() onPressed) {
    return TextButton(
      style: lt.borderlessButton,
      onPressed: onPressed,
      child: Container(
        alignment: Alignment.center,
        height: cpWinSide * .9,
        width: cpWinSide * .9,
        child: Card(
          margin: EdgeInsetsGeometry.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(GcubeProject.selected == current ? dsp.eqPx * 0 : dsp.eqPx * 5),
            side: BorderSide(color: color.uliege, width: dsp.eqPx * 1),
          ),
          color: color.transparent,
          child: AnimatedContainer(
            duration: widget.duration * .25,
            color: GcubeProject.selected == current ? color.agroBioTech : color.transparent,
            height: GcubeProject.selected == current ? cpWinSide : cpWinSide * .85,
            width: GcubeProject.selected == current ? cpWinSide : cpWinSide * .85,
            alignment: Alignment.center,
            child: Card(
              margin: EdgeInsetsGeometry.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(dsp.eqPx * 0),
                side: BorderSide(color: color.transparent, width: dsp.eqPx * .0),
              ),
              color: color.background,
              child: AnimatedContainer(
                duration: widget.duration,
                height: cpWinSide * .9,
                width: cpWinSide * .9,
                child: Stack(
                  alignment: AlignmentGeometry.center,
                  children: [
                    Container(
                      alignment: Alignment.topCenter,
                      child: Text(
                        current.name[0].toUpperCase(),
                        style: lt.capitalFirst(size: cpWinSide * .35, color: color.agroBioTech),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        current.name,
                        style: lt.capitalAfter(size: cpWinSide * .1, color: color.agroBioTech),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
