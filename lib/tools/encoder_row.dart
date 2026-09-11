import 'package:gcube3/globals/classes_circonference.dart';
import 'package:gcube3/globals/mode.dart' as mode;
import 'package:uuid/v4.dart';

class EncoderRow {
  bool? empty;
  int perimeterclass;
  int observationNr;
  String essenceId = "";
  String id = "";
  double volume = 0;
  double height;
  double cone;

  EncoderRow(this.essenceId, this.perimeterclass, this.observationNr, this.height, this.cone) {
    empty = false;
    id = UuidV4().generate();
    volume = computeVolume();
  }

  EncoderRow.empty({this.perimeterclass = -1, this.observationNr = -1, this.height = -1, this.cone = -1}) {
    empty = true;
    essenceId = "Empty Type";
    id = "0000-0000-0000-0000";
    observationNr = -1;
    volume = -1;
  }

  static final Map<String, EncoderRow> _rows = {};

  static String _idSelectedRow = '';
  static bool get isNoneSelected => _idSelectedRow.isEmpty;
  static bool get existsAtLeastOne => _rows.isNotEmpty;
  static int get nRows => _rows.length;
  static List<EncoderRow> get allRows => _rows.values.toList();

  static EncoderRow get selected => (_validId(_idSelectedRow) ? _rows[_idSelectedRow]! : EncoderRow.empty());
  static set selected(EncoderRow it) => _idSelectedRow = it.id;
  static bool _validId(String it) => _rows.keys.contains(it);

  double computeVolume() {
    switch (mode.equationType) {
      case 1:
        switch (essenceId) {
          case "oak":
            return magikOak1(classesCirconference[perimeterclass]![0], classesCirconference[perimeterclass]![1]);
          default:
            return magikDefault1(classesCirconference[perimeterclass]![0], classesCirconference[perimeterclass]![1]);
        }
      case 2:
        switch (essenceId) {
          case "oak":
            return magikOak2(classesCirconference[perimeterclass]![0], classesCirconference[perimeterclass]![1], height);
          default:
            return magikDefault2(classesCirconference[perimeterclass]![0], classesCirconference[perimeterclass]![1], height);
        }
      case 3:
        switch (essenceId) {
          case "oak":
            return magikOak3(classesCirconference[perimeterclass]![0], classesCirconference[perimeterclass]![1], height, cone);
          default:
            return magikDefault3(classesCirconference[perimeterclass]![0], classesCirconference[perimeterclass]![1], height, cone);
        }
      default:
        return -1;
    }
  }
}

double magikOak1(int min, int max) {
  return (min + max).toDouble() * .5;
}

double magikOak2(int min, int max, double height) {
  return (min + max).toDouble() * height * .03;
}

double magikOak3(int min, int max, double height, double cone) {
  return (min + max).toDouble() * height * .02 * 1 / cone;
}

double magikDefault1(int min, int max) {
  return (min + max).toDouble() * .5;
}

double magikDefault2(int min, int max, double height) {
  return (min + max).toDouble() * height * .03;
}

double magikDefault3(int min, int max, double height, double cone) {
  return (min + max).toDouble() * height * .02 * 1 / cone;
}
