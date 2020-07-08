// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apiManager.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class homeworkAdapter extends TypeAdapter<homework> {
  @override
  final typeId = 0;

  @override
  homework read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return homework(
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
      (fields[10] as List)?.cast<document>(),
      (fields[11] as List)?.cast<document>(),
      fields[12] as String,
    );
  }

  @override
  void write(BinaryWriter writer, homework obj) {
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
}

class documentAdapter extends TypeAdapter<document> {
  @override
  final typeId = 1;

  @override
  document read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return document(
      fields[0] as String,
      fields[1] as int,
      fields[2] as String,
      fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, document obj) {
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
}

class gradeAdapter extends TypeAdapter<grade> {
  @override
  final typeId = 2;

  @override
  grade read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return grade(
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
    );
  }

  @override
  void write(BinaryWriter writer, grade obj) {
    writer
      ..writeByte(14)
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
      ..write(obj.nonSignificatif);
  }
}

class disciplineAdapter extends TypeAdapter<discipline> {
  @override
  final typeId = 3;

  @override
  discipline read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return discipline(
      gradesList: (fields[12] as List)?.cast<grade>(),
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
  void write(BinaryWriter writer, discipline obj) {
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
}
