import 'package:gcube3/globals/classes_circonference.dart';
import 'package:uuid/v4.dart';

class EncoderRow {
  bool? empty;
  int perimeterclass;
  int rowNr;
  String essenceId = "";
  String id = "";
  double result = 0;

  EncoderRow(this.essenceId, this.perimeterclass, this.rowNr) {
    empty = false;
    id = UuidV4().toString();
  }

  EncoderRow.empty({this.perimeterclass = -1, this.rowNr = -1}) {
    empty = true;
    essenceId = "Empty Type";
    id = "0000-0000-0000-0000";
    rowNr = -1;
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
    switch (essenceId) {
      case "oak":
        return magikOak(classesCirconference[perimeterclass]![0], classesCirconference[perimeterclass]![1]);
      default:
        return magikDefault(classesCirconference[perimeterclass]![0], classesCirconference[perimeterclass]![1]);
    }
  }
}

double magikOak(int min, int max) {
  return (min + max).toDouble() * .5;
}

double magikDefault(int min, int max) {
  return (min + max).toDouble() * .5;
}
