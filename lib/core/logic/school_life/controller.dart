import 'package:ynotes/core/apis/model.dart';
import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/core/utils/controller.dart';
import 'package:ynotes/core/utils/logging_utils/logging_utils.dart';

class SchoolLifeController extends Controller {
  API? _api;

  bool get loading => _loading;
  bool _loading = false;

  List<SchoolLifeTicket>? get tickets => _tickets;
  List<SchoolLifeTicket>? _tickets;

  SchoolLifeController(API? api) : _api = api;

  set api(API? api) {
    _api = api;
  }

  Future<void> refresh({bool force = false}) async {
    CustomLogger.log("SCHOOL LIFE", "Refresh tickets");
    setState(() {
      _loading = true;
    });
    try {
      final tickets = await _api!.getSchoolLife(forceReload: force);
      setState(() {
        _tickets = tickets;
      });
    } catch (e) {
      CustomLogger.log("SCHOOL LIFE", "An error occured while refreshing");
      CustomLogger.error(e);
    }
    setState(() {
      _loading = false;
    });
  }
}
