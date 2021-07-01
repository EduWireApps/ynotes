import 'package:ynotes/core/logic/app_config/controller.dart';
import 'package:ynotes/core/logic/models_exporter.dart';

//Futures
Future? disciplinesListFuture;

Future<List<AgendaEvent>?>? spaceAgendaFuture;

Future<List<AgendaEvent>?>? agendaFuture;

late ApplicationSystem appSys;
