import 'package:ynotes/core/logic/appConfig/controller.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';
import 'package:ynotes/main.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/core/logic/homework/controller.dart';

//Futures
Future? disciplinesListFuture;

Future<List<AgendaEvent>?>? spaceAgendaFuture;

Future<List<AgendaEvent>?>? agendaFuture;

late ApplicationSystem appSys;
