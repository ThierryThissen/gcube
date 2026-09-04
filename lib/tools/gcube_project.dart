import 'package:gcube3/tools/encoder_row.dart';
import 'package:uuid/uuid.dart';

class GcubeProject {
  bool? empty;

  GcubeProject() {
    empty = false;
    //id = Uuid.v4().toString();
  }
  GcubeProject.empty() {
    empty = true;
    name = "Empty Type";
    id = "0000-0000-0000-0000";
  }

  String name = "";
  String id = "";
  static final Map<String, GcubeProject> _projects = {};

  static String _idSelectedProject = '';
  static bool get isNoneSelected => _idSelectedProject.isEmpty;
  static bool get existsAtLeastOne => _projects.isNotEmpty;
  static int get nProjects => _projects.length;
  static List<GcubeProject> get allProjects => _projects.values.toList();

  static String addProject(String name) {
    String id = Uuid().v4().toString();
    _projects[id] = GcubeProject();
    _projects[id]!.name = name;
    _projects[id]!.id = id;
    return id;
  }

  static GcubeProject get selected => (_validId(_idSelectedProject) ? _projects[_idSelectedProject]! : GcubeProject.empty());
  static set selected(GcubeProject it) => _idSelectedProject = it.id;



  static bool _validId(String it) => _projects.keys.contains(it);

  List<EncoderRow> encodedTrees = [];
}
