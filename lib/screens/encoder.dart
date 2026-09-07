import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gcube3/globals/classes_circonference.dart';
import 'package:gcube3/globals/colors.dart' as colors;
import 'package:gcube3/globals/essences.dart';
import 'package:gcube3/globals/gcube_assets.dart';
import 'package:gcube3/globals/log.dart' as log;
import 'package:gcube3/popup_message.dart';
import 'package:gcube3/tools/cmp_string.dart';
import 'package:gcube3/tools/encoder_row.dart';
import 'package:gcube3/tools/gcube_project.dart';
import 'package:gcube3/tools/stack_animated.dart' as stack;
import 'package:gcube3/globals/state.dart' as state;
import 'package:gcube3/globals/display.dart' as dsp;
import 'package:gcube3/globals/mode.dart' as mode;
import 'package:gcube3/globals/colors.dart' as color;
import 'package:gcube3/globals/anim_data.dart' as anim;
import 'package:gcube3/globals/font_sizes.dart' as ft;
import 'package:gcube3/tools/layout_tools.dart' as lt;
import 'package:share_plus/share_plus.dart';

void encoder() {
  state.rebuildMainStack(() {
    stack.data.add(
      "encoderWindow",
      EncoderWindow("encoderWindow", "Encodage", Duration(milliseconds: 400)),
      Duration(milliseconds: 400),
      anim.onScreenPosCenter,
      anim.offScreenPosWindows,
    );
  });
}

class EncoderWindow extends StatefulWidget implements stack.AnimatedWindowGCube {
  final String id;
  final String title;
  final Duration duration;

  const EncoderWindow(this.id, this.title, this.duration, {super.key});

  @override
  Offset get position => mode.encoderWindowOpen
      ? Offset(dsp.data.alignX(0), dsp.data.alignY(0))
      : Offset(dsp.data.alignX(dsp.data.eqAlignLeft), dsp.data.alignY(dsp.data.eqAlignBottom));

  @override
  Offset get size => Offset(
    mode.encoderWindowOpen ? dsp.data.eqMaxWindowWidth * dsp.eqPx : 150 * dsp.eqPx,
    (mode.encoderWindowOpen ? dsp.data.eqMaxWindowHeight * dsp.eqPx - dsp.data.insetBot : 30 * dsp.eqPx),
  );

  @override
  State<StatefulWidget> createState() => _EncoderWindow();
}

class _EncoderWindow extends State<EncoderWindow> {
  static bool inTransitionAnimation = false;
  int _selectedWidthClass = -1;
  String _selectedEssence = "";
  int _selectedRow = -1;

  String _sortBy = "default";

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: widget.duration,
      alignment: mode.encoderWindowOpen
          ? AlignmentGeometry.xy(dsp.data.alignX(0), dsp.data.alignY(0))
          : AlignmentGeometry.xy(dsp.data.alignX(dsp.data.eqAlignRight), dsp.data.alignY(dsp.data.eqAlignBottom)),
      child: OrientationBuilder(
        builder: (c, o) {
          double cWidth = mode.encoderWindowOpen ? dsp.data.eqMaxWindowWidth * dsp.eqPx : 100 * dsp.eqPx;
          double cHeight = mode.encoderWindowOpen ? dsp.data.eqMaxWindowHeight * dsp.eqPx : 20 * dsp.eqPx;
          cHeight -= dsp.data.insetBot;
          int cAxisCount = (dsp.eqPx * dsp.data.eqMaxWindowWidth / 150).round();
          if (cAxisCount < 2) {
            cAxisCount = 2;
          }
          return AnimatedContainer(
            onEnd: () {
              setState(() {
                inTransitionAnimation = false;
              });
            },
            height: cHeight,
            width: cWidth,
            duration: widget.duration,
            color: Colors.transparent,
            child: Card(
              margin: EdgeInsetsGeometry.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(dsp.eqPx * 0),
                side: BorderSide(color: color.gcube, width: dsp.eqPx * 1),
              ),
              color: color.background,
              child: AnimatedContainer(
                alignment: Alignment.topCenter,
                duration: widget.duration,
                height: cHeight,
                width: cWidth,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (!inTransitionAnimation)
                      Stack(
                        children: [
                          SizedBox(
                            height: cHeight,
                            width: cWidth,
                            child: mode.encoderWindowOpen && !inTransitionAnimation
                                ? Column(
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
                                              Text("Encodeur", style: lt.titleL()),
                                              Container(
                                                alignment: Alignment.topRight,
                                                height: dsp.eqPx * 20,
                                                width: dsp.eqPx * 20,
                                                child: lt.gcubeButton(() {
                                                  state.rebuildMainStack(() {
                                                    setState(() {
                                                      mode.encoderWindowOpen = false;
                                                      inTransitionAnimation = true;
                                                    });
                                                  });
                                                }, mode.encoderWindowOpen ? Icons.minimize_outlined : Icons.square_outlined),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      lt.stroke(dsp.eqPx * 1, dsp.eqPx * 1, colors.gcube),
                                      Container(
                                        alignment: Alignment.topCenter,
                                        color: Colors.black,
                                        width: cWidth,
                                        height: cHeight - dsp.eqPx * 23,
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                Container(
                                                  alignment: Alignment.center,
                                                  height: dsp.eqPx * 30,
                                                  width: dsp.eqPx * 30,
                                                  child: AnimatedContainer(
                                                    alignment: Alignment.center,
                                                    duration: widget.duration * .5,
                                                    height: _selectedRow > -1 ? dsp.eqPx * 30 : 0,
                                                    width: _selectedRow > -1 ? dsp.eqPx * 30 : 0,
                                                    child: _selectedRow > -1
                                                        ? FloatingActionButton(
                                                            onPressed: () {
                                                              state.rebuildMainStack(() {
                                                                popupMessage(
                                                                  width: dsp.eqPx * 150,
                                                                  height: dsp.eqPx * 100,
                                                                  id: "Delete Tree Row",
                                                                  title: "Attention",
                                                                  messageAccept: "Supprimer",
                                                                  messageDecline: "Anuller",
                                                                  onAccept: () {
                                                                    state.rebuildMainStack(() {
                                                                      setState(() {
                                                                        stack.data.pop("Delete Tree Row");
                                                                        GcubeProject.selected.encodedTrees.removeAt(_selectedRow);
                                                                        _selectedRow = -1;
                                                                      });
                                                                    });
                                                                  },
                                                                  onDecline: () {
                                                                    state.rebuildMainStack(() {
                                                                      setState(() {
                                                                        stack.data.pop("Delete Tree Row");
                                                                      });
                                                                    });
                                                                  },
                                                                  onDiscard: () {
                                                                    state.rebuildMainStack(() {
                                                                      setState(() {
                                                                        stack.data.pop("Delete Tree Row");
                                                                      });
                                                                    });
                                                                  },
                                                                  message:
                                                                      "Êtes-vous sûr de vouloir supprimer l'encodage de l'arbre ${GcubeProject.selected.encodedTrees[_selectedRow].essenceId} ?",
                                                                );
                                                              });
                                                            },
                                                            child: Stack(
                                                              children: [
                                                                Container(
                                                                  alignment: Alignment(0, 0),
                                                                  child: Icon(Icons.delete_forever, size: dsp.eqPx * ft.l, color: color.black),
                                                                ),
                                                                Container(
                                                                  alignment: Alignment(.5, .5),
                                                                  child: Icon(Icons.warning, size: dsp.eqPx * ft.s, color: color.red),
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        : Container(color: color.agroBioTech),
                                                  ),
                                                ),
                                                Container(
                                                  alignment: Alignment.center,
                                                  height: dsp.eqPx * 30,
                                                  width: dsp.eqPx * 30,
                                                  child: AnimatedContainer(
                                                    duration: widget.duration * .5,
                                                    height: dsp.eqPx * 30,
                                                    width: dsp.eqPx * 30,
                                                    child: _selectedRow == -1
                                                        ? FloatingActionButton(
                                                            onPressed: () {
                                                              state.rebuildMainStack(() {
                                                                popupMessage(
                                                                  width: dsp.eqPx * 150,
                                                                  height: dsp.eqPx * 300,
                                                                  id: "New Tree Row",
                                                                  title: "Ajoutez un Arbre",
                                                                  messageAccept: "Ajouter",
                                                                  messageDecline: "Anuller",
                                                                  onAccept: () {
                                                                    state.rebuildMainStack(() {
                                                                      setState(() {
                                                                        if (_selectedWidthClass != -1 && _selectedEssence != "") {
                                                                          GcubeProject.selected.encodedTrees.add(
                                                                            EncoderRow(
                                                                              _selectedEssence,
                                                                              _selectedWidthClass,
                                                                              GcubeProject.selected.encodedTrees.length + 1,
                                                                            ),
                                                                          );
                                                                          stack.data.pop("New Tree Row");
                                                                        }
                                                                        _selectedWidthClass = -1;
                                                                        _selectedEssence = "";
                                                                      });
                                                                    });
                                                                  },
                                                                  onDecline: () {
                                                                    state.rebuildMainStack(() {
                                                                      setState(() {
                                                                        stack.data.pop("New Tree Row");
                                                                        _selectedWidthClass = -1;
                                                                        _selectedEssence = "";
                                                                      });
                                                                    });
                                                                  },
                                                                  onDiscard: () {
                                                                    state.rebuildMainStack(() {
                                                                      setState(() {
                                                                        stack.data.pop("New Tree Row");
                                                                        _selectedWidthClass = -1;
                                                                        _selectedEssence = "";
                                                                      });
                                                                    });
                                                                  },
                                                                  child: NewTreeEntry(
                                                                    (String essence, int widthClass) {
                                                                      _selectedEssence = essence;
                                                                      _selectedWidthClass = widthClass;
                                                                    },
                                                                    cHeight / 2,
                                                                    (String essence, int widthClass) {
                                                                      state.rebuildMainStack(() {
                                                                        setState(() {
                                                                          if (_selectedWidthClass != -1 && _selectedEssence != "") {
                                                                            GcubeProject.selected.encodedTrees.add(
                                                                              EncoderRow(
                                                                                _selectedEssence,
                                                                                _selectedWidthClass,
                                                                                GcubeProject.selected.encodedTrees.length + 1,
                                                                              ),
                                                                            );
                                                                            stack.data.pop("New Tree Row");
                                                                          } else {
                                                                            return;
                                                                          }
                                                                          _selectedWidthClass = -1;
                                                                          _selectedEssence = "";
                                                                        });
                                                                      });
                                                                    },
                                                                  ),
                                                                );
                                                              });
                                                            },
                                                            child: Stack(
                                                              children: [
                                                                Container(
                                                                  alignment: Alignment(0, 0),
                                                                  child: Icon(Icons.forest, size: dsp.eqPx * ft.l, color: color.black),
                                                                ),
                                                                Container(
                                                                  alignment: Alignment(.5, .5),
                                                                  child: Icon(Icons.add, size: dsp.eqPx * ft.s, color: color.red),
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        : AnimatedContainer(
                                                            duration: widget.duration * .5,
                                                            height: _selectedRow > -1 ? dsp.eqPx * 30 : 0,
                                                            width: _selectedRow > -1 ? dsp.eqPx * 30 : 0,
                                                            child: _selectedRow > -1
                                                                ? FloatingActionButton(
                                                                    onPressed: () {
                                                                      setState(() {
                                                                        _selectedRow = -1;
                                                                      });
                                                                    },
                                                                    child: Stack(
                                                                      children: [
                                                                        Container(
                                                                          alignment: Alignment(0, 0),
                                                                          child: Icon(Icons.deselect, size: dsp.eqPx * ft.l, color: color.black),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  )
                                                                : Container(color: color.agroBioTech),
                                                          ),
                                                  ),
                                                ),
                                                Container(
                                                  alignment: Alignment.center,
                                                  height: dsp.eqPx * 30,
                                                  width: dsp.eqPx * 30,
                                                  child: AnimatedContainer(
                                                    duration: widget.duration * .5,
                                                    height: _selectedRow == -1 ? dsp.eqPx * 30 : 0,
                                                    width: _selectedRow == -1 ? dsp.eqPx * 30 : 0,
                                                    child: _selectedRow == -1
                                                        ? FloatingActionButton(
                                                            onPressed: () {
                                                              state.rebuildMainStack(() {
                                                                popupMessage(
                                                                  width: dsp.eqPx * 150,
                                                                  height: dsp.eqPx * 100,
                                                                  id: "export Tree Row",
                                                                  title: "Exporter la liste",
                                                                  messageAccept: "Exporter",
                                                                  messageDecline: "Anuller",
                                                                  onAccept: () {
                                                                    state.rebuildMainStack(() async {
                                                                      try {
                                                                        await SharePlus.instance.share(
                                                                          ShareParams(
                                                                            files: [
                                                                              XFile.fromData(
                                                                                utf8.encode("tHIS IS A TEST"),
                                                                                name: "it.csv",//TODO
                                                                                mimeType: 'text/plain',
                                                                              ),
                                                                            ],
                                                                            downloadFallbackEnabled: true,
                                                                          ),
                                                                        );
                                                                      } catch (e) {
                                                                        log.print("Error: Sharing of anaPt pdf failed: ${e.toString()})");
                                                                      }
                                                                      setState(() {
                                                                        stack.data.pop("export Tree Row");
                                                                        _selectedRow = -1;
                                                                      });
                                                                    });
                                                                  },
                                                                  onDecline: () {
                                                                    state.rebuildMainStack(() {
                                                                      setState(() {
                                                                        stack.data.pop("export Tree Row");
                                                                      });
                                                                    });
                                                                  },
                                                                  onDiscard: () {
                                                                    state.rebuildMainStack(() {
                                                                      setState(() {
                                                                        stack.data.pop("export Tree Row");
                                                                      });
                                                                    });
                                                                  },
                                                                  child: Container(),
                                                                );
                                                              });
                                                            },
                                                            child: Stack(
                                                              children: [
                                                                Container(
                                                                  alignment: Alignment(0, 0),
                                                                  child: Icon(Icons.share, size: dsp.eqPx * ft.l, color: color.black),
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        : Container(color: color.agroBioTech),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Container(
                                              alignment: Alignment.center,
                                              height: cHeight - dsp.eqPx * 23 - dsp.eqPx * 30,
                                              width: cWidth,
                                              color: color.black,
                                              child: Container(
                                                alignment: Alignment.center,
                                                child: lt.GcubeScrollView(
                                                  height: cHeight,
                                                  width: cWidth - dsp.eqPx * 10,
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children:
                                                        [_buildRow(null, -1)] +
                                                        List<Widget>.generate(GcubeProject.selected.encodedTrees.length, (int index) {
                                                          return _buildRow(GcubeProject.selected.encodedTrees[index], index);
                                                        }),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                : SizedBox(
                                    height: cHeight,
                                    width: cWidth,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: dsp.eqPx * 20,
                                          width: dsp.eqPx * 100,
                                          child: lt.GcubeScrollView(
                                            child: TextButton(
                                              onPressed: () {
                                                state.rebuildMainStack(() {
                                                  setState(() {
                                                    mode.encoderWindowOpen = true;
                                                    inTransitionAnimation = true;
                                                  });
                                                });
                                              },
                                              child: Container(
                                                alignment: Alignment.centerLeft,
                                                height: dsp.eqPx * 30,
                                                width: dsp.eqPx * 150,
                                                child: Text("${EncoderRow.nRows} encodage${() => EncoderRow.nRows == 1 ? "" : "s"}", style: lt.L()),
                                              ),
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

  void _sortEssencesList() {
    switch (_sortBy) {
      case "order":
        GcubeProject.selected.encodedTrees.sort((EncoderRow a, EncoderRow b) {
          return a.rowNr > b.rowNr ? 1 : 0;
        });
        break;
      case "orderInverse":
        GcubeProject.selected.encodedTrees.sort((EncoderRow a, EncoderRow b) {
          return a.rowNr < b.rowNr ? 1 : 0;
        });
        break;
      case "name":
        GcubeProject.selected.encodedTrees.sort((EncoderRow a, EncoderRow b) {
          return greater(essences[a.essenceId]!.name, essences[b.essenceId]!.name) ? 1 : 0;
        });
        break;
      case "nameInverse":
        GcubeProject.selected.encodedTrees.sort((EncoderRow a, EncoderRow b) {
          return greater(essences[a.essenceId]!.name, essences[b.essenceId]!.name) ? 0 : 1;
        });
        break;
      case "volume":
        GcubeProject.selected.encodedTrees.sort((EncoderRow a, EncoderRow b) {
          return a.computeVolume() > b.computeVolume() ? 1 : 0;
        });
        break;
      case "volumeInverse":
        GcubeProject.selected.encodedTrees.sort((EncoderRow a, EncoderRow b) {
          return a.computeVolume() < b.computeVolume() ? 1 : 0;
        });
        break;
      case "perimeter":
        GcubeProject.selected.encodedTrees.sort((EncoderRow a, EncoderRow b) {
          return a.perimeterclass > b.perimeterclass ? 1 : 0;
        });
        break;
      case "perimeterInverse":
        GcubeProject.selected.encodedTrees.sort((EncoderRow a, EncoderRow b) {
          return a.perimeterclass < b.perimeterclass ? 1 : 0;
        });
        break;
      default:
        GcubeProject.selected.encodedTrees.sort((EncoderRow a, EncoderRow b) {
          return a.rowNr > b.rowNr ? 1 : 0;
        });
    }
  }

  Widget _buildRow(EncoderRow? row, int index) {
    return row != null
        ? TextButton(
            onPressed: () {
              state.rebuildMainStack(() {
                setState(() {
                  _selectedRow == index ? _selectedRow = -1 : _selectedRow = index;
                });
              });
            },
            style: lt.borderlessButton,
            child: Card(
              margin: EdgeInsetsGeometry.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(dsp.eqPx * 0),
                side: BorderSide(color: color.gcube, width: dsp.eqPx * 1),
              ),
              color: _selectedRow == index ? color.agroBioTech : color.transparent,
              child: lt.GcubeScrollView(
                horizontal: true,
                height: dsp.eqPx * 30,
                width: dsp.eqPx * 190,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: dsp.eqPx * 30,
                      height: dsp.eqPx * 30,
                      child: Text(
                        row.rowNr.toString(),
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: dsp.eqPx * 50,
                      height: dsp.eqPx * 30,
                      child: Text(
                        row.essenceId != "" ? essences[row.essenceId]!.name : "no essence ?",
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(width: dsp.eqPx * 5),
                    Container(
                      alignment: Alignment.center,
                      width: dsp.eqPx * 50,
                      height: dsp.eqPx * 30,
                      child: Text(
                        row.perimeterclass > -1
                            ? "${classesCirconference[row.perimeterclass]![0]} - ${classesCirconference[row.perimeterclass]![1]}"
                            : row.perimeterclass.toString(),
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(width: dsp.eqPx * 5),
                    Container(
                      alignment: Alignment.center,
                      width: dsp.eqPx * 50,
                      height: dsp.eqPx * 30,
                      child: Text(
                        row.computeVolume().toString(),
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : Card(
            margin: EdgeInsetsGeometry.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(dsp.eqPx * 0),
              side: BorderSide(color: color.gcube, width: dsp.eqPx * 1),
            ),
            color: color.black,
            child: lt.GcubeScrollView(
              horizontal: true,
              height: dsp.eqPx * 30,
              width: dsp.eqPx * 190,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: dsp.eqPx * 30,
                    height: dsp.eqPx * 30,
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          _sortBy = _sortBy == "order" ? "orderInverse" : "order";
                          _sortEssencesList();
                        });
                      },
                      child: Stack(
                        children: [
                          if (_sortBy == "order" || _sortBy == "orderInverse")
                            Container(
                              color: Colors.transparent,
                              alignment: Alignment.centerRight,
                              child: Icon(_sortBy == "order" ? Icons.arrow_drop_down : Icons.arrow_drop_up, color: Colors.red, size: dsp.eqPx * ft.s),
                            ),
                          Container(
                            color: Colors.transparent,
                            alignment: Alignment.center,
                            child: Text(
                              "#",
                              style: TextStyle(color: Colors.white, fontSize: ft.s * dsp.eqPx),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: dsp.eqPx * 50,
                    height: dsp.eqPx * 30,
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          _sortBy = _sortBy == "name" ? "nameInverse" : "name";
                          _sortEssencesList();
                        });
                      },
                      child: Stack(
                        children: [
                          if (_sortBy == "name" || _sortBy == "nameInverse")
                            Container(
                              color: Colors.transparent,
                              alignment: Alignment.centerRight,
                              child: Icon(_sortBy == "name" ? Icons.arrow_drop_down : Icons.arrow_drop_up, color: Colors.red, size: dsp.eqPx * ft.s),
                            ),
                          Container(
                            color: Colors.transparent,
                            alignment: Alignment.center,
                            child: Text(
                              "Essence",
                              style: TextStyle(color: Colors.white, fontSize: ft.s * dsp.eqPx),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: dsp.eqPx * 5),
                  Container(
                    alignment: Alignment.center,
                    width: dsp.eqPx * 50,
                    height: dsp.eqPx * 30,
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          _sortBy = _sortBy == "perimeter" ? "perimeterInverse" : "perimeter";
                          _sortEssencesList();
                        });
                      },
                      child: Stack(
                        children: [
                          if (_sortBy == "perimeter" || _sortBy == "perimeterInverse")
                            Container(
                              color: Colors.transparent,
                              alignment: Alignment.centerRight,
                              child: Icon(
                                _sortBy == "perimeter" ? Icons.arrow_drop_down : Icons.arrow_drop_up,
                                color: Colors.red,
                                size: dsp.eqPx * ft.s,
                              ),
                            ),
                          Container(
                            color: Colors.transparent,
                            alignment: Alignment.center,
                            child: Text(
                              "Classe de circonférence",
                              style: TextStyle(color: Colors.white, fontSize: ft.xxs * dsp.eqPx),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: dsp.eqPx * 5),
                  Container(
                    alignment: Alignment.center,
                    width: dsp.eqPx * 50,
                    height: dsp.eqPx * 30,
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          _sortBy = _sortBy == "volume" ? "volumeInverse" : "volume";
                          _sortEssencesList();
                        });
                      },
                      child: Stack(
                        children: [
                          if (_sortBy == "volume" || _sortBy == "volumeInverse")
                            Container(
                              color: Colors.transparent,
                              alignment: Alignment.centerRight,
                              child: Icon(
                                _sortBy == "volume" ? Icons.arrow_drop_down : Icons.arrow_drop_up,
                                color: Colors.red,
                                size: dsp.eqPx * ft.s,
                              ),
                            ),
                          Container(
                            color: Colors.transparent,
                            alignment: Alignment.center,
                            child: Text(
                              "Volume [m³]",
                              style: TextStyle(color: Colors.white, fontSize: ft.xs * dsp.eqPx),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}

class NewTreeEntry extends StatefulWidget {
  const NewTreeEntry(this.onValueChanged, this.height, this.onDoubleClick, {super.key});

  final double height;

  final void Function(String, int) onValueChanged;
  final void Function(String, int) onDoubleClick;

  @override
  State<StatefulWidget> createState() => _NewTreeEntry();
}

class _NewTreeEntry extends State<NewTreeEntry> {
  static String _selectedEssence = "";
  int _selectedWidthClass = -1;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(
              "Essence",
              style: TextStyle(color: color.white, fontSize: ft.s * dsp.eqPx),
            ),
            Text(
              "Classe de circonférence",
              style: TextStyle(color: color.white, fontSize: ft.xxs * dsp.eqPx),
            ),
          ],
        ),
        lt.stroke(dsp.eqPx * 1, dsp.eqPx * 1, colors.gcube),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            lt.GcubeScrollView(
              height: widget.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List<Widget>.generate(essences.length, (i) {
                  return Container(
                    color: _selectedEssence == essences.keys.elementAt(i) ? color.agroBioTech : color.black,
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedEssence = essences.keys.elementAt(i);
                          widget.onValueChanged(_selectedEssence, _selectedWidthClass);
                        });
                      },
                      child: Text(
                        essences[essences.keys.elementAt(i)]!.name,
                        style: TextStyle(color: color.white, fontSize: ft.s * dsp.eqPx),
                      ),
                    ),
                  );
                }),
              ),
            ),
            lt.GcubeScrollView(
              height: widget.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List<Widget>.generate(classesCirconference.length, (i) {
                  return Container(
                    color: _selectedWidthClass == classesCirconference.keys.elementAt(i) ? color.agroBioTech : color.black,
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          if (_selectedWidthClass == classesCirconference.keys.elementAt(i)) {
                            {
                              widget.onDoubleClick(_selectedEssence, _selectedWidthClass);
                            }
                          } else {
                            _selectedWidthClass = classesCirconference.keys.elementAt(i);
                            widget.onValueChanged(_selectedEssence, _selectedWidthClass);
                          }
                        });
                      },
                      child: Text(
                        "${classesCirconference[i]![0]} - ${classesCirconference[i]![1]}",
                        style: TextStyle(color: color.white, fontSize: ft.s * dsp.eqPx),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
