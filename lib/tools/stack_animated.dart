import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:gcube3/globals/display.dart' as dsp;
import 'package:gcube3/globals/state.dart' as state;
import 'package:flutter/material.dart';

AnimatedStack data = AnimatedStack();

class AnimatedStack {
  static List<StackAnimated> stack = [];
  static Map<String, void Function(void Function())> animStates = {};

  List<Widget> get widgets => List<Widget>.generate(stack.length, (index) {
    return stack[index];
  });
  List<int> get priorities => List<int>.generate(stack.length, (index) {
    return stack[index].priority;
  });
  List<String> get ids => List<String>.generate(stack.length, (index) {
    return stack[index].id;
  });
  int indexPriority(int priority) => stack.isEmpty
      ? 0
      : priorities.indexWhere((int p) {
          return (p <= priority);
        });

  void add(String id, Widget it, Duration duration, Offset onScreen, Offset offScreen, {int? priority}) {
    if (ids.contains(id)) return;
    stack.insert(
      indexPriority(priority ?? stack.length * 10),
      StackAnimated(
        positions: <Offset>[Offset(offScreen.dx, offScreen.dy), onScreen, offScreen],
        priority: priority ?? stack.length * 10,
        id: id,
        duration: duration,
        child: it,
      ),
    );
    stack.sort((a, b) {
      return (a.priority < b.priority) ? 1 : 0;
    });
    _startTimer(id);
  }

  void pop(String id) {
    if (stack.isEmpty || !ids.contains(id)) return;
    StackAnimated it = stack.firstWhere((StackAnimated a) {
      return a.id == id;
    });
    animStates[id]!(() {
      it.positions[0] = it.positions[2];
    });
    Timer(it.duration, () {
      state.rebuildMainStack(() {
        stack.removeWhere((StackAnimated a) {
          return a.id == id;
        });
        animStates.remove(id);
      });
    });
  }

  void setToTopPriority(String id) {
    if (stack.isEmpty || !ids.contains(id)) return;
    int it = stack.lastIndexOf(
      stack.firstWhere((StackAnimated a) {
        return a.id == id;
      }),
    );

    state.rebuildMainStack(() {
      stack.insert(stack.length - 1, stack.removeAt(it));
    });
  }

  void _startTimer(String id) {
    Timer(Duration(milliseconds: 10), () {
      StackAnimated it = stack.firstWhere((StackAnimated a) {
        return a.id == id;
      });
      if (animStates[id] != null) {
        animStates[id]!(() {
          it.positions[0] = it.positions[1];
        });
      } else {
        _startTimer(id);
      }
    });
  }
}

class StackAnimated extends StatefulWidget {
  const StackAnimated({
    super.key,
    required this.child,
    required this.positions,
    required this.priority,
    required this.id,
    required this.duration,
    this.data,
  });
  final Widget child;
  final List<Offset> positions;
  final int priority;
  final String id;
  final dynamic data;
  final Duration duration;

  @override
  State<StatefulWidget> createState() => _StackAnimated();
}

class _StackAnimated extends State<StackAnimated> {
  @override
  Widget build(BuildContext context) {
    AnimatedStack.animStates[widget.id] = (void Function() it) {
      if (mounted) {
        setState(() {
          it();
        });
      }
    };

    return Container(
      alignment: AlignmentGeometry.center,
      width: double.infinity,
      height: double.infinity,
      child: OrientationBuilder(
        builder: (c, o) {
          return AnimatedContainer(
            duration: widget.duration,
            alignment: AlignmentGeometry.xy(
              dsp.data.alignX((widget.child as AnimatedWindowGCube).position.dx),
              dsp.data.alignY((widget.child as AnimatedWindowGCube).position.dy),
            ),
            child: widget.child,
          );
        },
      ),
    );
  }
}

abstract class AnimatedWindowGCube {
  @visibleForOverriding
  Offset get position => Offset(0, 0);

  @visibleForOverriding
  Offset get size => Offset(10, 10);
}
