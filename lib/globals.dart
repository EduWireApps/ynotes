import 'package:ynotes/core/logic/appConfig/controller.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';

//Futures
Future? disciplinesListFuture;

Future<List<AgendaEvent>?>? spaceAgendaFuture;

Future<List<AgendaEvent>?>? agendaFuture;

late ApplicationSystem appSys;
