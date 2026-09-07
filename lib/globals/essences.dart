import 'dart:ui';
import 'package:gcube3/globals/colors.dart' as cs;

class Essence {
  static int _counter = 0;
  final int id = _counter++;
  final String name;
  final Color color;

  Essence.birch({this.name = "Hêtres", this.color = cs.birch});
  Essence.beech({this.name = "Bouleau", this.color = cs.beech});
  Essence.oak({this.name = "Chêne", this.color = cs.oak});
  Essence.pine({this.name = "Pin", this.color = cs.pine});
  Essence.poplar({this.name = "Peuplier", this.color = cs.poplar});
}

Map<String, Essence> essences = {
  "birch": Essence.birch(),
  "beech": Essence.beech(),
  "oak": Essence.oak(),
  "pine": Essence.pine(),
  "poplar": Essence.poplar(),
};
