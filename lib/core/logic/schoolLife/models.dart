import 'package:hive/hive.dart';

@HiveType(typeId: 10)
class SchoolLifeTicket {
  @HiveField(0)
  final String? libelle;
  @HiveField(1)
  final String? displayDate;
  @HiveField(2)
  final String? motif;
  @HiveField(3)
  final String? type;
  @HiveField(4)
  final bool? isJustified;
  SchoolLifeTicket(this.libelle, this.displayDate, this.motif, this.type, this.isJustified);
}
