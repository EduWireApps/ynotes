// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apiManager.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HomeworkAdapter extends TypeAdapter<Homework> {
  @override
  final int typeId = 0;

  @override
  Homework read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Homework(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
      fields[3] as String,
      fields[4] as String,
      fields[5] as DateTime,
      fields[6] as DateTime,
      fields[7] as bool,
      fields[8] as bool,
      fields[9] as bool,
      (fields[10] as List)?.cast<Document>(),
      (fields[11] as List)?.cast<Document>(),
      fields[12] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Homework obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.matiere)
      ..writeByte(1)
      ..write(obj.codeMatiere)
      ..writeByte(2)
      ..write(obj.idDevoir)
      ..writeByte(3)
      ..write(obj.contenu)
      ..writeByte(4)
      ..write(obj.contenuDeSeance)
      ..writeByte(5)
      ..write(obj.date)
      ..writeByte(6)
      ..write(obj.datePost)
      ..writeByte(7)
      ..write(obj.done)
      ..writeByte(8)
      ..write(obj.rendreEnLigne)
      ..writeByte(9)
      ..write(obj.interrogation)
      ..writeByte(10)
      ..write(obj.documents)
      ..writeByte(11)
      ..write(obj.documentsContenuDeSeance)
      ..writeByte(12)
      ..write(obj.nomProf);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HomeworkAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DocumentAdapter extends TypeAdapter<Document> {
  @override
  final int typeId = 1;

  @override
  Document read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Document(
      fields[0] as String,
      fields[1] as int,
      fields[2] as String,
      fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Document obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.libelle)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.length);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DocumentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class GradeAdapter extends TypeAdapter<Grade> {
  @override
  final int typeId = 2;

  @override
  Grade read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Grade(
      devoir: fields[0] as String,
      codePeriode: fields[1] as String,
      codeMatiere: fields[2] as String,
      codeSousMatiere: fields[3] as String,
      libelleMatiere: fields[4] as String,
      letters: fields[5] as bool,
      valeur: fields[6] as String,
      coef: fields[7] as String,
      noteSur: fields[8] as String,
      moyenneClasse: fields[9] as String,
      typeDevoir: fields[10] as String,
      date: fields[11] as String,
      dateSaisie: fields[12] as String,
      nonSignificatif: fields[13] as bool,
      nomPeriode: fields[14] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Grade obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.devoir)
      ..writeByte(1)
      ..write(obj.codePeriode)
      ..writeByte(2)
      ..write(obj.codeMatiere)
      ..writeByte(3)
      ..write(obj.codeSousMatiere)
      ..writeByte(4)
      ..write(obj.libelleMatiere)
      ..writeByte(5)
      ..write(obj.letters)
      ..writeByte(6)
      ..write(obj.valeur)
      ..writeByte(7)
      ..write(obj.coef)
      ..writeByte(8)
      ..write(obj.noteSur)
      ..writeByte(9)
      ..write(obj.moyenneClasse)
      ..writeByte(10)
      ..write(obj.typeDevoir)
      ..writeByte(11)
      ..write(obj.date)
      ..writeByte(12)
      ..write(obj.dateSaisie)
      ..writeByte(13)
      ..write(obj.nonSignificatif)
      ..writeByte(14)
      ..write(obj.nomPeriode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GradeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DisciplineAdapter extends TypeAdapter<Discipline> {
  @override
  final int typeId = 3;

  @override
  Discipline read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Discipline(
      gradesList: (fields[12] as List)?.cast<Grade>(),
      moyenneGeneralClasseMax: fields[1] as String,
      moyenneGeneraleClasse: fields[2] as String,
      moyenneGenerale: fields[0] as String,
      moyenneClasse: fields[7] as String,
      moyenneMin: fields[8] as String,
      moyenneMax: fields[9] as String,
      codeMatiere: fields[3] as String,
      codeSousMatiere: (fields[4] as List)?.cast<String>(),
      moyenne: fields[6] as String,
      professeurs: (fields[10] as List)?.cast<String>(),
      nomDiscipline: fields[5] as String,
      periode: fields[11] as String,
      color: fields[13] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Discipline obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.moyenneGenerale)
      ..writeByte(1)
      ..write(obj.moyenneGeneralClasseMax)
      ..writeByte(2)
      ..write(obj.moyenneGeneraleClasse)
      ..writeByte(3)
      ..write(obj.codeMatiere)
      ..writeByte(4)
      ..write(obj.codeSousMatiere)
      ..writeByte(5)
      ..write(obj.nomDiscipline)
      ..writeByte(6)
      ..write(obj.moyenne)
      ..writeByte(7)
      ..write(obj.moyenneClasse)
      ..writeByte(8)
      ..write(obj.moyenneMin)
      ..writeByte(9)
      ..write(obj.moyenneMax)
      ..writeByte(10)
      ..write(obj.professeurs)
      ..writeByte(11)
      ..write(obj.periode)
      ..writeByte(12)
      ..write(obj.gradesList)
      ..writeByte(13)
      ..write(obj.color);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DisciplineAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LessonAdapter extends TypeAdapter<Lesson> {
  @override
  final int typeId = 4;

  @override
  Lesson read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Lesson(
      room: fields[0] as String,
      teachers: (fields[1] as List)?.cast<String>(),
      start: fields[2] as DateTime,
      duration: fields[4] as int,
      canceled: fields[5] as bool,
      status: fields[6] as String,
      groups: (fields[7] as List)?.cast<String>(),
      content: fields[8] as String,
      matiere: fields[9] as String,
      codeMatiere: fields[10] as String,
      end: fields[3] as DateTime,
      id: fields[11] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Lesson obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.room)
      ..writeByte(1)
      ..write(obj.teachers)
      ..writeByte(2)
      ..write(obj.start)
      ..writeByte(3)
      ..write(obj.end)
      ..writeByte(4)
      ..write(obj.duration)
      ..writeByte(5)
      ..write(obj.canceled)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.groups)
      ..writeByte(8)
      ..write(obj.content)
      ..writeByte(9)
      ..write(obj.matiere)
      ..writeByte(10)
      ..write(obj.codeMatiere)
      ..writeByte(11)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LessonAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PollInfoAdapter extends TypeAdapter<PollInfo> {
  @override
  final int typeId = 5;

  @override
  PollInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PollInfo(
      fields[0] as String,
      fields[1] as DateTime,
      (fields[2] as List)?.cast<String>(),
      fields[3] as bool,
      fields[4] as String,
      fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PollInfo obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.auteur)
      ..writeByte(1)
      ..write(obj.datedebut)
      ..writeByte(2)
      ..write(obj.questions)
      ..writeByte(3)
      ..write(obj.read)
      ..writeByte(4)
      ..write(obj.title)
      ..writeByte(5)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PollInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
