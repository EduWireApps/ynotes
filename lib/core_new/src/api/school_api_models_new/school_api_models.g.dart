// GENERATED CODE - DO NOT MODIFY BY HAND

part of new_models;

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, invalid_use_of_protected_member

extension GetGradeCollection on Isar {
  IsarCollection<Grade> get grades {
    return getCollection('Grade');
  }
}

final GradeSchema = CollectionSchema(
  name: 'Grade',
  schema:
      '{"name":"Grade","properties":[{"name":"classAverage","type":"Double"},{"name":"classMax","type":"Double"},{"name":"classMin","type":"Double"},{"name":"coefficient","type":"Double"},{"name":"custom","type":"Byte"},{"name":"date","type":"Long"},{"name":"entryDate","type":"Long"},{"name":"name","type":"String"},{"name":"outOf","type":"Double"},{"name":"periodId","type":"String"},{"name":"realValue","type":"Double"},{"name":"significant","type":"Byte"},{"name":"subjectId","type":"String"},{"name":"type","type":"String"},{"name":"value","type":"Double"}],"indexes":[],"links":[]}',
  adapter: const _GradeAdapter(),
  idName: 'isarId',
  propertyIds: {
    'classAverage': 0,
    'classMax': 1,
    'classMin': 2,
    'coefficient': 3,
    'custom': 4,
    'date': 5,
    'entryDate': 6,
    'name': 7,
    'outOf': 8,
    'periodId': 9,
    'realValue': 10,
    'significant': 11,
    'subjectId': 12,
    'type': 13,
    'value': 14
  },
  indexIds: {},
  indexTypes: {},
  linkIds: {},
  backlinkIds: {},
  linkedCollections: [],
  getId: (obj) => obj.isarId,
  setId: (obj, id) => obj.isarId = id,
  getLinks: (obj) => [],
  version: 0,
);

class _GradeAdapter extends IsarTypeAdapter<Grade> {
  const _GradeAdapter();

  @override
  int serialize(IsarCollection<Grade> collection, RawObject rawObj,
      Grade object, List<int> offsets,
      [int? existingBufferSize]) {
    rawObj.id = object.isarId ?? Isar.autoIncrement;
    var dynamicSize = 0;
    final value0 = object.classAverage;
    final _classAverage = value0;
    final value1 = object.classMax;
    final _classMax = value1;
    final value2 = object.classMin;
    final _classMin = value2;
    final value3 = object.coefficient;
    final _coefficient = value3;
    final value4 = object.custom;
    final _custom = value4;
    final value5 = object.date;
    final _date = value5;
    final value6 = object.entryDate;
    final _entryDate = value6;
    final value7 = object.name;
    final _name = BinaryWriter.utf8Encoder.convert(value7);
    dynamicSize += _name.length;
    final value8 = object.outOf;
    final _outOf = value8;
    final value9 = object.periodId;
    final _periodId = BinaryWriter.utf8Encoder.convert(value9);
    dynamicSize += _periodId.length;
    final value10 = object.realValue;
    final _realValue = value10;
    final value11 = object.significant;
    final _significant = value11;
    final value12 = object.subjectId;
    final _subjectId = BinaryWriter.utf8Encoder.convert(value12);
    dynamicSize += _subjectId.length;
    final value13 = object.type;
    final _type = BinaryWriter.utf8Encoder.convert(value13);
    dynamicSize += _type.length;
    final value14 = object.value;
    final _value = value14;
    final size = dynamicSize + 116;

    late int bufferSize;
    if (existingBufferSize != null) {
      if (existingBufferSize < size) {
        malloc.free(rawObj.buffer);
        rawObj.buffer = malloc(size);
        bufferSize = size;
      } else {
        bufferSize = existingBufferSize;
      }
    } else {
      rawObj.buffer = malloc(size);
      bufferSize = size;
    }
    rawObj.buffer_length = size;
    final buffer = rawObj.buffer.asTypedList(size);
    final writer = BinaryWriter(buffer, 116);
    writer.writeDouble(offsets[0], _classAverage);
    writer.writeDouble(offsets[1], _classMax);
    writer.writeDouble(offsets[2], _classMin);
    writer.writeDouble(offsets[3], _coefficient);
    writer.writeBool(offsets[4], _custom);
    writer.writeDateTime(offsets[5], _date);
    writer.writeDateTime(offsets[6], _entryDate);
    writer.writeBytes(offsets[7], _name);
    writer.writeDouble(offsets[8], _outOf);
    writer.writeBytes(offsets[9], _periodId);
    writer.writeDouble(offsets[10], _realValue);
    writer.writeBool(offsets[11], _significant);
    writer.writeBytes(offsets[12], _subjectId);
    writer.writeBytes(offsets[13], _type);
    writer.writeDouble(offsets[14], _value);
    return bufferSize;
  }

  @override
  Grade deserialize(IsarCollection<Grade> collection, int id,
      BinaryReader reader, List<int> offsets) {
    final object = Grade(
      classAverage: reader.readDouble(offsets[0]),
      classMax: reader.readDouble(offsets[1]),
      classMin: reader.readDouble(offsets[2]),
      coefficient: reader.readDouble(offsets[3]),
      custom: reader.readBool(offsets[4]),
      date: reader.readDateTime(offsets[5]),
      entryDate: reader.readDateTime(offsets[6]),
      name: reader.readString(offsets[7]),
      outOf: reader.readDouble(offsets[8]),
      periodId: reader.readString(offsets[9]),
      significant: reader.readBool(offsets[11]),
      subjectId: reader.readString(offsets[12]),
      type: reader.readString(offsets[13]),
      value: reader.readDouble(offsets[14]),
    );
    object.isarId = id;
    return object;
  }

  @override
  P deserializeProperty<P>(
      int id, BinaryReader reader, int propertyIndex, int offset) {
    switch (propertyIndex) {
      case -1:
        return id as P;
      case 0:
        return (reader.readDouble(offset)) as P;
      case 1:
        return (reader.readDouble(offset)) as P;
      case 2:
        return (reader.readDouble(offset)) as P;
      case 3:
        return (reader.readDouble(offset)) as P;
      case 4:
        return (reader.readBool(offset)) as P;
      case 5:
        return (reader.readDateTime(offset)) as P;
      case 6:
        return (reader.readDateTime(offset)) as P;
      case 7:
        return (reader.readString(offset)) as P;
      case 8:
        return (reader.readDouble(offset)) as P;
      case 9:
        return (reader.readString(offset)) as P;
      case 10:
        return (reader.readDouble(offset)) as P;
      case 11:
        return (reader.readBool(offset)) as P;
      case 12:
        return (reader.readString(offset)) as P;
      case 13:
        return (reader.readString(offset)) as P;
      case 14:
        return (reader.readDouble(offset)) as P;
      default:
        throw 'Illegal propertyIndex';
    }
  }
}

extension GradeQueryWhereSort on QueryBuilder<Grade, Grade, QWhere> {
  QueryBuilder<Grade, Grade, QAfterWhere> anyIsarId() {
    return addWhereClause(WhereClause(indexName: null));
  }
}

extension GradeQueryWhere on QueryBuilder<Grade, Grade, QWhereClause> {
  QueryBuilder<Grade, Grade, QAfterWhereClause> isarIdEqualTo(int? isarId) {
    return addWhereClause(WhereClause(
      indexName: null,
      lower: [isarId],
      includeLower: true,
      upper: [isarId],
      includeUpper: true,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterWhereClause> isarIdNotEqualTo(int? isarId) {
    if (whereSortInternal == Sort.asc) {
      return addWhereClause(WhereClause(
        indexName: null,
        upper: [isarId],
        includeUpper: false,
      )).addWhereClause(WhereClause(
        indexName: null,
        lower: [isarId],
        includeLower: false,
      ));
    } else {
      return addWhereClause(WhereClause(
        indexName: null,
        lower: [isarId],
        includeLower: false,
      )).addWhereClause(WhereClause(
        indexName: null,
        upper: [isarId],
        includeUpper: false,
      ));
    }
  }

  QueryBuilder<Grade, Grade, QAfterWhereClause> isarIdGreaterThan(
    int? isarId, {
    bool include = false,
  }) {
    return addWhereClause(WhereClause(
      indexName: null,
      lower: [isarId],
      includeLower: include,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterWhereClause> isarIdLessThan(
    int? isarId, {
    bool include = false,
  }) {
    return addWhereClause(WhereClause(
      indexName: null,
      upper: [isarId],
      includeUpper: include,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterWhereClause> isarIdBetween(
    int? lowerIsarId,
    int? upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addWhereClause(WhereClause(
      indexName: null,
      lower: [lowerIsarId],
      includeLower: includeLower,
      upper: [upperIsarId],
      includeUpper: includeUpper,
    ));
  }
}

extension GradeQueryFilter on QueryBuilder<Grade, Grade, QFilterCondition> {
  QueryBuilder<Grade, Grade, QAfterFilterCondition> classAverageGreaterThan(
      double value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'classAverage',
      value: value,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> classAverageLessThan(
      double value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'classAverage',
      value: value,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> classAverageBetween(
      double lower, double upper) {
    return addFilterCondition(FilterCondition.between(
      property: 'classAverage',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> classMaxGreaterThan(
      double value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'classMax',
      value: value,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> classMaxLessThan(
      double value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'classMax',
      value: value,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> classMaxBetween(
      double lower, double upper) {
    return addFilterCondition(FilterCondition.between(
      property: 'classMax',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> classMinGreaterThan(
      double value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'classMin',
      value: value,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> classMinLessThan(
      double value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'classMin',
      value: value,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> classMinBetween(
      double lower, double upper) {
    return addFilterCondition(FilterCondition.between(
      property: 'classMin',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> coefficientGreaterThan(
      double value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'coefficient',
      value: value,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> coefficientLessThan(
      double value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'coefficient',
      value: value,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> coefficientBetween(
      double lower, double upper) {
    return addFilterCondition(FilterCondition.between(
      property: 'coefficient',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> customEqualTo(bool value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.eq,
      property: 'custom',
      value: value,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> dateEqualTo(
      DateTime value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.eq,
      property: 'date',
      value: value,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> dateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'date',
      value: value,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> dateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'date',
      value: value,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> dateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterCondition(FilterCondition.between(
      property: 'date',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> entryDateEqualTo(
      DateTime value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.eq,
      property: 'entryDate',
      value: value,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> entryDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'entryDate',
      value: value,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> entryDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'entryDate',
      value: value,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> entryDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterCondition(FilterCondition.between(
      property: 'entryDate',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> isarIdIsNull() {
    return addFilterCondition(FilterCondition(
      type: ConditionType.isNull,
      property: 'isarId',
      value: null,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> isarIdEqualTo(int? value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.eq,
      property: 'isarId',
      value: value,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> isarIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'isarId',
      value: value,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> isarIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'isarId',
      value: value,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> isarIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterCondition(FilterCondition.between(
      property: 'isarId',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.eq,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> nameLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterCondition(FilterCondition.between(
      property: 'name',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.startsWith,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.endsWith,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> nameContains(String value,
      {bool caseSensitive = true}) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.contains,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> nameMatches(String pattern,
      {bool caseSensitive = true}) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.matches,
      property: 'name',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> outOfGreaterThan(
      double value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'outOf',
      value: value,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> outOfLessThan(
      double value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'outOf',
      value: value,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> outOfBetween(
      double lower, double upper) {
    return addFilterCondition(FilterCondition.between(
      property: 'outOf',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> periodIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.eq,
      property: 'periodId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> periodIdGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'periodId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> periodIdLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'periodId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> periodIdBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterCondition(FilterCondition.between(
      property: 'periodId',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> periodIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.startsWith,
      property: 'periodId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> periodIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.endsWith,
      property: 'periodId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> periodIdContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.contains,
      property: 'periodId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> periodIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.matches,
      property: 'periodId',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> realValueGreaterThan(
      double value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'realValue',
      value: value,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> realValueLessThan(
      double value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'realValue',
      value: value,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> realValueBetween(
      double lower, double upper) {
    return addFilterCondition(FilterCondition.between(
      property: 'realValue',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> significantEqualTo(
      bool value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.eq,
      property: 'significant',
      value: value,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> subjectIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.eq,
      property: 'subjectId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> subjectIdGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'subjectId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> subjectIdLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'subjectId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> subjectIdBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterCondition(FilterCondition.between(
      property: 'subjectId',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> subjectIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.startsWith,
      property: 'subjectId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> subjectIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.endsWith,
      property: 'subjectId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> subjectIdContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.contains,
      property: 'subjectId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> subjectIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.matches,
      property: 'subjectId',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> typeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.eq,
      property: 'type',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> typeGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'type',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> typeLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'type',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> typeBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterCondition(FilterCondition.between(
      property: 'type',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> typeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.startsWith,
      property: 'type',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> typeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.endsWith,
      property: 'type',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> typeContains(String value,
      {bool caseSensitive = true}) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.contains,
      property: 'type',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> typeMatches(String pattern,
      {bool caseSensitive = true}) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.matches,
      property: 'type',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> valueGreaterThan(
      double value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'value',
      value: value,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> valueLessThan(
      double value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'value',
      value: value,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> valueBetween(
      double lower, double upper) {
    return addFilterCondition(FilterCondition.between(
      property: 'value',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }
}

extension GradeQueryWhereSortBy on QueryBuilder<Grade, Grade, QSortBy> {
  QueryBuilder<Grade, Grade, QAfterSortBy> sortByClassAverage() {
    return addSortByInternal('classAverage', Sort.asc);
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> sortByClassAverageDesc() {
    return addSortByInternal('classAverage', Sort.desc);
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> sortByClassMax() {
    return addSortByInternal('classMax', Sort.asc);
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> sortByClassMaxDesc() {
    return addSortByInternal('classMax', Sort.desc);
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> sortByClassMin() {
    return addSortByInternal('classMin', Sort.asc);
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> sortByClassMinDesc() {
    return addSortByInternal('classMin', Sort.desc);
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> sortByCoefficient() {
    return addSortByInternal('coefficient', Sort.asc);
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> sortByCoefficientDesc() {
    return addSortByInternal('coefficient', Sort.desc);
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> sortByCustom() {
    return addSortByInternal('custom', Sort.asc);
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> sortByCustomDesc() {
    return addSortByInternal('custom', Sort.desc);
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> sortByDate() {
    return addSortByInternal('date', Sort.asc);
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> sortByDateDesc() {
    return addSortByInternal('date', Sort.desc);
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> sortByEntryDate() {
    return addSortByInternal('entryDate', Sort.asc);
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> sortByEntryDateDesc() {
    return addSortByInternal('entryDate', Sort.desc);
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> sortByIsarId() {
    return addSortByInternal('isarId', Sort.asc);
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> sortByIsarIdDesc() {
    return addSortByInternal('isarId', Sort.desc);
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> sortByName() {
    return addSortByInternal('name', Sort.asc);
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> sortByNameDesc() {
    return addSortByInternal('name', Sort.desc);
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> sortByOutOf() {
    return addSortByInternal('outOf', Sort.asc);
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> sortByOutOfDesc() {
    return addSortByInternal('outOf', Sort.desc);
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> sortByPeriodId() {
    return addSortByInternal('periodId', Sort.asc);
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> sortByPeriodIdDesc() {
    return addSortByInternal('periodId', Sort.desc);
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> sortByRealValue() {
    return addSortByInternal('realValue', Sort.asc);
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> sortByRealValueDesc() {
    return addSortByInternal('realValue', Sort.desc);
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> sortBySignificant() {
    return addSortByInternal('significant', Sort.asc);
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> sortBySignificantDesc() {
    return addSortByInternal('significant', Sort.desc);
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> sortBySubjectId() {
    return addSortByInternal('subjectId', Sort.asc);
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> sortBySubjectIdDesc() {
    return addSortByInternal('subjectId', Sort.desc);
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> sortByType() {
    return addSortByInternal('type', Sort.asc);
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> sortByTypeDesc() {
    return addSortByInternal('type', Sort.desc);
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> sortByValue() {
    return addSortByInternal('value', Sort.asc);
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> sortByValueDesc() {
    return addSortByInternal('value', Sort.desc);
  }
}

extension GradeQueryWhereSortThenBy on QueryBuilder<Grade, Grade, QSortThenBy> {
  QueryBuilder<Grade, Grade, QAfterSortBy> thenByClassAverage() {
    return addSortByInternal('classAverage', Sort.asc);
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenByClassAverageDesc() {
    return addSortByInternal('classAverage', Sort.desc);
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenByClassMax() {
    return addSortByInternal('classMax', Sort.asc);
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenByClassMaxDesc() {
    return addSortByInternal('classMax', Sort.desc);
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenByClassMin() {
    return addSortByInternal('classMin', Sort.asc);
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenByClassMinDesc() {
    return addSortByInternal('classMin', Sort.desc);
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenByCoefficient() {
    return addSortByInternal('coefficient', Sort.asc);
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenByCoefficientDesc() {
    return addSortByInternal('coefficient', Sort.desc);
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenByCustom() {
    return addSortByInternal('custom', Sort.asc);
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenByCustomDesc() {
    return addSortByInternal('custom', Sort.desc);
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenByDate() {
    return addSortByInternal('date', Sort.asc);
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenByDateDesc() {
    return addSortByInternal('date', Sort.desc);
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenByEntryDate() {
    return addSortByInternal('entryDate', Sort.asc);
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenByEntryDateDesc() {
    return addSortByInternal('entryDate', Sort.desc);
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenByIsarId() {
    return addSortByInternal('isarId', Sort.asc);
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenByIsarIdDesc() {
    return addSortByInternal('isarId', Sort.desc);
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenByName() {
    return addSortByInternal('name', Sort.asc);
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenByNameDesc() {
    return addSortByInternal('name', Sort.desc);
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenByOutOf() {
    return addSortByInternal('outOf', Sort.asc);
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenByOutOfDesc() {
    return addSortByInternal('outOf', Sort.desc);
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenByPeriodId() {
    return addSortByInternal('periodId', Sort.asc);
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenByPeriodIdDesc() {
    return addSortByInternal('periodId', Sort.desc);
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenByRealValue() {
    return addSortByInternal('realValue', Sort.asc);
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenByRealValueDesc() {
    return addSortByInternal('realValue', Sort.desc);
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenBySignificant() {
    return addSortByInternal('significant', Sort.asc);
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenBySignificantDesc() {
    return addSortByInternal('significant', Sort.desc);
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenBySubjectId() {
    return addSortByInternal('subjectId', Sort.asc);
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenBySubjectIdDesc() {
    return addSortByInternal('subjectId', Sort.desc);
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenByType() {
    return addSortByInternal('type', Sort.asc);
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenByTypeDesc() {
    return addSortByInternal('type', Sort.desc);
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenByValue() {
    return addSortByInternal('value', Sort.asc);
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenByValueDesc() {
    return addSortByInternal('value', Sort.desc);
  }
}

extension GradeQueryWhereDistinct on QueryBuilder<Grade, Grade, QDistinct> {
  QueryBuilder<Grade, Grade, QDistinct> distinctByClassAverage() {
    return addDistinctByInternal('classAverage');
  }

  QueryBuilder<Grade, Grade, QDistinct> distinctByClassMax() {
    return addDistinctByInternal('classMax');
  }

  QueryBuilder<Grade, Grade, QDistinct> distinctByClassMin() {
    return addDistinctByInternal('classMin');
  }

  QueryBuilder<Grade, Grade, QDistinct> distinctByCoefficient() {
    return addDistinctByInternal('coefficient');
  }

  QueryBuilder<Grade, Grade, QDistinct> distinctByCustom() {
    return addDistinctByInternal('custom');
  }

  QueryBuilder<Grade, Grade, QDistinct> distinctByDate() {
    return addDistinctByInternal('date');
  }

  QueryBuilder<Grade, Grade, QDistinct> distinctByEntryDate() {
    return addDistinctByInternal('entryDate');
  }

  QueryBuilder<Grade, Grade, QDistinct> distinctByIsarId() {
    return addDistinctByInternal('isarId');
  }

  QueryBuilder<Grade, Grade, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('name', caseSensitive: caseSensitive);
  }

  QueryBuilder<Grade, Grade, QDistinct> distinctByOutOf() {
    return addDistinctByInternal('outOf');
  }

  QueryBuilder<Grade, Grade, QDistinct> distinctByPeriodId(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('periodId', caseSensitive: caseSensitive);
  }

  QueryBuilder<Grade, Grade, QDistinct> distinctByRealValue() {
    return addDistinctByInternal('realValue');
  }

  QueryBuilder<Grade, Grade, QDistinct> distinctBySignificant() {
    return addDistinctByInternal('significant');
  }

  QueryBuilder<Grade, Grade, QDistinct> distinctBySubjectId(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('subjectId', caseSensitive: caseSensitive);
  }

  QueryBuilder<Grade, Grade, QDistinct> distinctByType(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('type', caseSensitive: caseSensitive);
  }

  QueryBuilder<Grade, Grade, QDistinct> distinctByValue() {
    return addDistinctByInternal('value');
  }
}

extension GradeQueryProperty on QueryBuilder<Grade, Grade, QQueryProperty> {
  QueryBuilder<Grade, double, QQueryOperations> classAverageProperty() {
    return addPropertyName('classAverage');
  }

  QueryBuilder<Grade, double, QQueryOperations> classMaxProperty() {
    return addPropertyName('classMax');
  }

  QueryBuilder<Grade, double, QQueryOperations> classMinProperty() {
    return addPropertyName('classMin');
  }

  QueryBuilder<Grade, double, QQueryOperations> coefficientProperty() {
    return addPropertyName('coefficient');
  }

  QueryBuilder<Grade, bool, QQueryOperations> customProperty() {
    return addPropertyName('custom');
  }

  QueryBuilder<Grade, DateTime, QQueryOperations> dateProperty() {
    return addPropertyName('date');
  }

  QueryBuilder<Grade, DateTime, QQueryOperations> entryDateProperty() {
    return addPropertyName('entryDate');
  }

  QueryBuilder<Grade, int?, QQueryOperations> isarIdProperty() {
    return addPropertyName('isarId');
  }

  QueryBuilder<Grade, String, QQueryOperations> nameProperty() {
    return addPropertyName('name');
  }

  QueryBuilder<Grade, double, QQueryOperations> outOfProperty() {
    return addPropertyName('outOf');
  }

  QueryBuilder<Grade, String, QQueryOperations> periodIdProperty() {
    return addPropertyName('periodId');
  }

  QueryBuilder<Grade, double, QQueryOperations> realValueProperty() {
    return addPropertyName('realValue');
  }

  QueryBuilder<Grade, bool, QQueryOperations> significantProperty() {
    return addPropertyName('significant');
  }

  QueryBuilder<Grade, String, QQueryOperations> subjectIdProperty() {
    return addPropertyName('subjectId');
  }

  QueryBuilder<Grade, String, QQueryOperations> typeProperty() {
    return addPropertyName('type');
  }

  QueryBuilder<Grade, double, QQueryOperations> valueProperty() {
    return addPropertyName('value');
  }
}

// ignore_for_file: non_constant_identifier_names, invalid_use_of_protected_member

extension GetSubjectCollection on Isar {
  IsarCollection<Subject> get subjects {
    return getCollection('Subject');
  }
}

final SubjectSchema = CollectionSchema(
  name: 'Subject',
  schema:
      '{"name":"Subject","properties":[{"name":"average","type":"Double"},{"name":"classAverage","type":"Double"},{"name":"coefficient","type":"Double"},{"name":"color","type":"String"},{"name":"id","type":"String"},{"name":"maxAverage","type":"Double"},{"name":"minAverage","type":"Double"},{"name":"name","type":"String"},{"name":"teachers","type":"String"}],"indexes":[],"links":[]}',
  adapter: const _SubjectAdapter(),
  idName: 'isarId',
  propertyIds: {
    'average': 0,
    'classAverage': 1,
    'coefficient': 2,
    'color': 3,
    'id': 4,
    'maxAverage': 5,
    'minAverage': 6,
    'name': 7,
    'teachers': 8
  },
  indexIds: {},
  indexTypes: {},
  linkIds: {},
  backlinkIds: {},
  linkedCollections: [],
  getId: (obj) => obj.isarId,
  setId: (obj, id) => obj.isarId = id,
  getLinks: (obj) => [],
  version: 0,
);

class _SubjectAdapter extends IsarTypeAdapter<Subject> {
  const _SubjectAdapter();

  static const _YTColorConverter = YTColorConverter();

  @override
  int serialize(IsarCollection<Subject> collection, RawObject rawObj,
      Subject object, List<int> offsets,
      [int? existingBufferSize]) {
    rawObj.id = object.isarId ?? Isar.autoIncrement;
    var dynamicSize = 0;
    final value0 = object.average;
    final _average = value0;
    final value1 = object.classAverage;
    final _classAverage = value1;
    final value2 = object.coefficient;
    final _coefficient = value2;
    final value3 = _SubjectAdapter._YTColorConverter.toIsar(object.color);
    final _color = BinaryWriter.utf8Encoder.convert(value3);
    dynamicSize += _color.length;
    final value4 = object.id;
    final _id = BinaryWriter.utf8Encoder.convert(value4);
    dynamicSize += _id.length;
    final value5 = object.maxAverage;
    final _maxAverage = value5;
    final value6 = object.minAverage;
    final _minAverage = value6;
    final value7 = object.name;
    final _name = BinaryWriter.utf8Encoder.convert(value7);
    dynamicSize += _name.length;
    final value8 = object.teachers;
    final _teachers = BinaryWriter.utf8Encoder.convert(value8);
    dynamicSize += _teachers.length;
    final size = dynamicSize + 82;

    late int bufferSize;
    if (existingBufferSize != null) {
      if (existingBufferSize < size) {
        malloc.free(rawObj.buffer);
        rawObj.buffer = malloc(size);
        bufferSize = size;
      } else {
        bufferSize = existingBufferSize;
      }
    } else {
      rawObj.buffer = malloc(size);
      bufferSize = size;
    }
    rawObj.buffer_length = size;
    final buffer = rawObj.buffer.asTypedList(size);
    final writer = BinaryWriter(buffer, 82);
    writer.writeDouble(offsets[0], _average);
    writer.writeDouble(offsets[1], _classAverage);
    writer.writeDouble(offsets[2], _coefficient);
    writer.writeBytes(offsets[3], _color);
    writer.writeBytes(offsets[4], _id);
    writer.writeDouble(offsets[5], _maxAverage);
    writer.writeDouble(offsets[6], _minAverage);
    writer.writeBytes(offsets[7], _name);
    writer.writeBytes(offsets[8], _teachers);
    return bufferSize;
  }

  @override
  Subject deserialize(IsarCollection<Subject> collection, int id,
      BinaryReader reader, List<int> offsets) {
    final object = Subject(
      average: reader.readDouble(offsets[0]),
      classAverage: reader.readDouble(offsets[1]),
      coefficient: reader.readDouble(offsets[2]),
      color: _SubjectAdapter._YTColorConverter.fromIsar(
          reader.readString(offsets[3])),
      id: reader.readString(offsets[4]),
      maxAverage: reader.readDouble(offsets[5]),
      minAverage: reader.readDouble(offsets[6]),
      name: reader.readString(offsets[7]),
      teachers: reader.readString(offsets[8]),
    );
    object.isarId = id;
    return object;
  }

  @override
  P deserializeProperty<P>(
      int id, BinaryReader reader, int propertyIndex, int offset) {
    switch (propertyIndex) {
      case -1:
        return id as P;
      case 0:
        return (reader.readDouble(offset)) as P;
      case 1:
        return (reader.readDouble(offset)) as P;
      case 2:
        return (reader.readDouble(offset)) as P;
      case 3:
        return (_SubjectAdapter._YTColorConverter.fromIsar(
            reader.readString(offset))) as P;
      case 4:
        return (reader.readString(offset)) as P;
      case 5:
        return (reader.readDouble(offset)) as P;
      case 6:
        return (reader.readDouble(offset)) as P;
      case 7:
        return (reader.readString(offset)) as P;
      case 8:
        return (reader.readString(offset)) as P;
      default:
        throw 'Illegal propertyIndex';
    }
  }
}

extension SubjectQueryWhereSort on QueryBuilder<Subject, Subject, QWhere> {
  QueryBuilder<Subject, Subject, QAfterWhere> anyIsarId() {
    return addWhereClause(WhereClause(indexName: null));
  }
}

extension SubjectQueryWhere on QueryBuilder<Subject, Subject, QWhereClause> {
  QueryBuilder<Subject, Subject, QAfterWhereClause> isarIdEqualTo(int? isarId) {
    return addWhereClause(WhereClause(
      indexName: null,
      lower: [isarId],
      includeLower: true,
      upper: [isarId],
      includeUpper: true,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterWhereClause> isarIdNotEqualTo(
      int? isarId) {
    if (whereSortInternal == Sort.asc) {
      return addWhereClause(WhereClause(
        indexName: null,
        upper: [isarId],
        includeUpper: false,
      )).addWhereClause(WhereClause(
        indexName: null,
        lower: [isarId],
        includeLower: false,
      ));
    } else {
      return addWhereClause(WhereClause(
        indexName: null,
        lower: [isarId],
        includeLower: false,
      )).addWhereClause(WhereClause(
        indexName: null,
        upper: [isarId],
        includeUpper: false,
      ));
    }
  }

  QueryBuilder<Subject, Subject, QAfterWhereClause> isarIdGreaterThan(
    int? isarId, {
    bool include = false,
  }) {
    return addWhereClause(WhereClause(
      indexName: null,
      lower: [isarId],
      includeLower: include,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterWhereClause> isarIdLessThan(
    int? isarId, {
    bool include = false,
  }) {
    return addWhereClause(WhereClause(
      indexName: null,
      upper: [isarId],
      includeUpper: include,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterWhereClause> isarIdBetween(
    int? lowerIsarId,
    int? upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addWhereClause(WhereClause(
      indexName: null,
      lower: [lowerIsarId],
      includeLower: includeLower,
      upper: [upperIsarId],
      includeUpper: includeUpper,
    ));
  }
}

extension SubjectQueryFilter
    on QueryBuilder<Subject, Subject, QFilterCondition> {
  QueryBuilder<Subject, Subject, QAfterFilterCondition> averageGreaterThan(
      double value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'average',
      value: value,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> averageLessThan(
      double value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'average',
      value: value,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> averageBetween(
      double lower, double upper) {
    return addFilterCondition(FilterCondition.between(
      property: 'average',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> classAverageGreaterThan(
      double value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'classAverage',
      value: value,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> classAverageLessThan(
      double value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'classAverage',
      value: value,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> classAverageBetween(
      double lower, double upper) {
    return addFilterCondition(FilterCondition.between(
      property: 'classAverage',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> coefficientGreaterThan(
      double value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'coefficient',
      value: value,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> coefficientLessThan(
      double value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'coefficient',
      value: value,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> coefficientBetween(
      double lower, double upper) {
    return addFilterCondition(FilterCondition.between(
      property: 'coefficient',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> colorEqualTo(
    YTColor value, {
    bool caseSensitive = true,
  }) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.eq,
      property: 'color',
      value: _SubjectAdapter._YTColorConverter.toIsar(value),
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> colorGreaterThan(
    YTColor value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'color',
      value: _SubjectAdapter._YTColorConverter.toIsar(value),
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> colorLessThan(
    YTColor value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'color',
      value: _SubjectAdapter._YTColorConverter.toIsar(value),
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> colorBetween(
    YTColor lower,
    YTColor upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterCondition(FilterCondition.between(
      property: 'color',
      lower: _SubjectAdapter._YTColorConverter.toIsar(lower),
      includeLower: includeLower,
      upper: _SubjectAdapter._YTColorConverter.toIsar(upper),
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> colorStartsWith(
    YTColor value, {
    bool caseSensitive = true,
  }) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.startsWith,
      property: 'color',
      value: _SubjectAdapter._YTColorConverter.toIsar(value),
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> colorEndsWith(
    YTColor value, {
    bool caseSensitive = true,
  }) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.endsWith,
      property: 'color',
      value: _SubjectAdapter._YTColorConverter.toIsar(value),
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> colorContains(
      YTColor value,
      {bool caseSensitive = true}) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.contains,
      property: 'color',
      value: _SubjectAdapter._YTColorConverter.toIsar(value),
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> colorMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.matches,
      property: 'color',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> idEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.eq,
      property: 'id',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> idGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'id',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> idLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'id',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> idBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterCondition(FilterCondition.between(
      property: 'id',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> idStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.startsWith,
      property: 'id',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> idEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.endsWith,
      property: 'id',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> idContains(String value,
      {bool caseSensitive = true}) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.contains,
      property: 'id',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> idMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.matches,
      property: 'id',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> isarIdIsNull() {
    return addFilterCondition(FilterCondition(
      type: ConditionType.isNull,
      property: 'isarId',
      value: null,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> isarIdEqualTo(
      int? value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.eq,
      property: 'isarId',
      value: value,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> isarIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'isarId',
      value: value,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> isarIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'isarId',
      value: value,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> isarIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterCondition(FilterCondition.between(
      property: 'isarId',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> maxAverageGreaterThan(
      double value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'maxAverage',
      value: value,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> maxAverageLessThan(
      double value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'maxAverage',
      value: value,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> maxAverageBetween(
      double lower, double upper) {
    return addFilterCondition(FilterCondition.between(
      property: 'maxAverage',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> minAverageGreaterThan(
      double value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'minAverage',
      value: value,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> minAverageLessThan(
      double value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'minAverage',
      value: value,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> minAverageBetween(
      double lower, double upper) {
    return addFilterCondition(FilterCondition.between(
      property: 'minAverage',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.eq,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> nameLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterCondition(FilterCondition.between(
      property: 'name',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.startsWith,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.endsWith,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.contains,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.matches,
      property: 'name',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> teachersEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.eq,
      property: 'teachers',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> teachersGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'teachers',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> teachersLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'teachers',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> teachersBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterCondition(FilterCondition.between(
      property: 'teachers',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> teachersStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.startsWith,
      property: 'teachers',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> teachersEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.endsWith,
      property: 'teachers',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> teachersContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.contains,
      property: 'teachers',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> teachersMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.matches,
      property: 'teachers',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }
}

extension SubjectQueryWhereSortBy on QueryBuilder<Subject, Subject, QSortBy> {
  QueryBuilder<Subject, Subject, QAfterSortBy> sortByAverage() {
    return addSortByInternal('average', Sort.asc);
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> sortByAverageDesc() {
    return addSortByInternal('average', Sort.desc);
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> sortByClassAverage() {
    return addSortByInternal('classAverage', Sort.asc);
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> sortByClassAverageDesc() {
    return addSortByInternal('classAverage', Sort.desc);
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> sortByCoefficient() {
    return addSortByInternal('coefficient', Sort.asc);
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> sortByCoefficientDesc() {
    return addSortByInternal('coefficient', Sort.desc);
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> sortByColor() {
    return addSortByInternal('color', Sort.asc);
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> sortByColorDesc() {
    return addSortByInternal('color', Sort.desc);
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> sortByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> sortByIsarId() {
    return addSortByInternal('isarId', Sort.asc);
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> sortByIsarIdDesc() {
    return addSortByInternal('isarId', Sort.desc);
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> sortByMaxAverage() {
    return addSortByInternal('maxAverage', Sort.asc);
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> sortByMaxAverageDesc() {
    return addSortByInternal('maxAverage', Sort.desc);
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> sortByMinAverage() {
    return addSortByInternal('minAverage', Sort.asc);
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> sortByMinAverageDesc() {
    return addSortByInternal('minAverage', Sort.desc);
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> sortByName() {
    return addSortByInternal('name', Sort.asc);
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> sortByNameDesc() {
    return addSortByInternal('name', Sort.desc);
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> sortByTeachers() {
    return addSortByInternal('teachers', Sort.asc);
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> sortByTeachersDesc() {
    return addSortByInternal('teachers', Sort.desc);
  }
}

extension SubjectQueryWhereSortThenBy
    on QueryBuilder<Subject, Subject, QSortThenBy> {
  QueryBuilder<Subject, Subject, QAfterSortBy> thenByAverage() {
    return addSortByInternal('average', Sort.asc);
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> thenByAverageDesc() {
    return addSortByInternal('average', Sort.desc);
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> thenByClassAverage() {
    return addSortByInternal('classAverage', Sort.asc);
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> thenByClassAverageDesc() {
    return addSortByInternal('classAverage', Sort.desc);
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> thenByCoefficient() {
    return addSortByInternal('coefficient', Sort.asc);
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> thenByCoefficientDesc() {
    return addSortByInternal('coefficient', Sort.desc);
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> thenByColor() {
    return addSortByInternal('color', Sort.asc);
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> thenByColorDesc() {
    return addSortByInternal('color', Sort.desc);
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> thenByIsarId() {
    return addSortByInternal('isarId', Sort.asc);
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> thenByIsarIdDesc() {
    return addSortByInternal('isarId', Sort.desc);
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> thenByMaxAverage() {
    return addSortByInternal('maxAverage', Sort.asc);
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> thenByMaxAverageDesc() {
    return addSortByInternal('maxAverage', Sort.desc);
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> thenByMinAverage() {
    return addSortByInternal('minAverage', Sort.asc);
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> thenByMinAverageDesc() {
    return addSortByInternal('minAverage', Sort.desc);
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> thenByName() {
    return addSortByInternal('name', Sort.asc);
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> thenByNameDesc() {
    return addSortByInternal('name', Sort.desc);
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> thenByTeachers() {
    return addSortByInternal('teachers', Sort.asc);
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> thenByTeachersDesc() {
    return addSortByInternal('teachers', Sort.desc);
  }
}

extension SubjectQueryWhereDistinct
    on QueryBuilder<Subject, Subject, QDistinct> {
  QueryBuilder<Subject, Subject, QDistinct> distinctByAverage() {
    return addDistinctByInternal('average');
  }

  QueryBuilder<Subject, Subject, QDistinct> distinctByClassAverage() {
    return addDistinctByInternal('classAverage');
  }

  QueryBuilder<Subject, Subject, QDistinct> distinctByCoefficient() {
    return addDistinctByInternal('coefficient');
  }

  QueryBuilder<Subject, Subject, QDistinct> distinctByColor(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('color', caseSensitive: caseSensitive);
  }

  QueryBuilder<Subject, Subject, QDistinct> distinctById(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('id', caseSensitive: caseSensitive);
  }

  QueryBuilder<Subject, Subject, QDistinct> distinctByIsarId() {
    return addDistinctByInternal('isarId');
  }

  QueryBuilder<Subject, Subject, QDistinct> distinctByMaxAverage() {
    return addDistinctByInternal('maxAverage');
  }

  QueryBuilder<Subject, Subject, QDistinct> distinctByMinAverage() {
    return addDistinctByInternal('minAverage');
  }

  QueryBuilder<Subject, Subject, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('name', caseSensitive: caseSensitive);
  }

  QueryBuilder<Subject, Subject, QDistinct> distinctByTeachers(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('teachers', caseSensitive: caseSensitive);
  }
}

extension SubjectQueryProperty
    on QueryBuilder<Subject, Subject, QQueryProperty> {
  QueryBuilder<Subject, double, QQueryOperations> averageProperty() {
    return addPropertyName('average');
  }

  QueryBuilder<Subject, double, QQueryOperations> classAverageProperty() {
    return addPropertyName('classAverage');
  }

  QueryBuilder<Subject, double, QQueryOperations> coefficientProperty() {
    return addPropertyName('coefficient');
  }

  QueryBuilder<Subject, YTColor, QQueryOperations> colorProperty() {
    return addPropertyName('color');
  }

  QueryBuilder<Subject, String, QQueryOperations> idProperty() {
    return addPropertyName('id');
  }

  QueryBuilder<Subject, int?, QQueryOperations> isarIdProperty() {
    return addPropertyName('isarId');
  }

  QueryBuilder<Subject, double, QQueryOperations> maxAverageProperty() {
    return addPropertyName('maxAverage');
  }

  QueryBuilder<Subject, double, QQueryOperations> minAverageProperty() {
    return addPropertyName('minAverage');
  }

  QueryBuilder<Subject, String, QQueryOperations> nameProperty() {
    return addPropertyName('name');
  }

  QueryBuilder<Subject, String, QQueryOperations> teachersProperty() {
    return addPropertyName('teachers');
  }
}

// ignore_for_file: non_constant_identifier_names, invalid_use_of_protected_member

extension GetSubjectsFilterCollection on Isar {
  IsarCollection<SubjectsFilter> get subjectsFilters {
    return getCollection('SubjectsFilter');
  }
}

final SubjectsFilterSchema = CollectionSchema(
  name: 'SubjectsFilter',
  schema:
      '{"name":"SubjectsFilter","properties":[{"name":"id","type":"String"},{"name":"name","type":"String"},{"name":"subjectsIds","type":"StringList"}],"indexes":[],"links":[]}',
  adapter: const _SubjectsFilterAdapter(),
  idName: 'isarId',
  propertyIds: {'id': 0, 'name': 1, 'subjectsIds': 2},
  indexIds: {},
  indexTypes: {},
  linkIds: {},
  backlinkIds: {},
  linkedCollections: [],
  getId: (obj) => obj.isarId,
  setId: (obj, id) => obj.isarId = id,
  getLinks: (obj) => [],
  version: 0,
);

class _SubjectsFilterAdapter extends IsarTypeAdapter<SubjectsFilter> {
  const _SubjectsFilterAdapter();

  @override
  int serialize(IsarCollection<SubjectsFilter> collection, RawObject rawObj,
      SubjectsFilter object, List<int> offsets,
      [int? existingBufferSize]) {
    rawObj.id = object.isarId ?? Isar.autoIncrement;
    var dynamicSize = 0;
    final value0 = object.id;
    Uint8List? _id;
    if (value0 != null) {
      _id = BinaryWriter.utf8Encoder.convert(value0);
    }
    dynamicSize += _id?.length ?? 0;
    final value1 = object.name;
    final _name = BinaryWriter.utf8Encoder.convert(value1);
    dynamicSize += _name.length;
    final value2 = object.subjectsIds;
    dynamicSize += (value2?.length ?? 0) * 8;
    List<Uint8List?>? bytesList2;
    if (value2 != null) {
      bytesList2 = [];
      for (var str in value2) {
        final bytes = BinaryWriter.utf8Encoder.convert(str);
        bytesList2.add(bytes);
        dynamicSize += bytes.length;
      }
    }
    final _subjectsIds = bytesList2;
    final size = dynamicSize + 34;

    late int bufferSize;
    if (existingBufferSize != null) {
      if (existingBufferSize < size) {
        malloc.free(rawObj.buffer);
        rawObj.buffer = malloc(size);
        bufferSize = size;
      } else {
        bufferSize = existingBufferSize;
      }
    } else {
      rawObj.buffer = malloc(size);
      bufferSize = size;
    }
    rawObj.buffer_length = size;
    final buffer = rawObj.buffer.asTypedList(size);
    final writer = BinaryWriter(buffer, 34);
    writer.writeBytes(offsets[0], _id);
    writer.writeBytes(offsets[1], _name);
    writer.writeStringList(offsets[2], _subjectsIds);
    return bufferSize;
  }

  @override
  SubjectsFilter deserialize(IsarCollection<SubjectsFilter> collection, int id,
      BinaryReader reader, List<int> offsets) {
    final object = SubjectsFilter(
      id: reader.readStringOrNull(offsets[0]),
      name: reader.readString(offsets[1]),
      subjectsIds: reader.readStringList(offsets[2]),
    );
    object.isarId = id;
    return object;
  }

  @override
  P deserializeProperty<P>(
      int id, BinaryReader reader, int propertyIndex, int offset) {
    switch (propertyIndex) {
      case -1:
        return id as P;
      case 0:
        return (reader.readStringOrNull(offset)) as P;
      case 1:
        return (reader.readString(offset)) as P;
      case 2:
        return (reader.readStringList(offset)) as P;
      default:
        throw 'Illegal propertyIndex';
    }
  }
}

extension SubjectsFilterQueryWhereSort
    on QueryBuilder<SubjectsFilter, SubjectsFilter, QWhere> {
  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterWhere> anyIsarId() {
    return addWhereClause(WhereClause(indexName: null));
  }
}

extension SubjectsFilterQueryWhere
    on QueryBuilder<SubjectsFilter, SubjectsFilter, QWhereClause> {
  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterWhereClause> isarIdEqualTo(
      int? isarId) {
    return addWhereClause(WhereClause(
      indexName: null,
      lower: [isarId],
      includeLower: true,
      upper: [isarId],
      includeUpper: true,
    ));
  }

  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterWhereClause>
      isarIdNotEqualTo(int? isarId) {
    if (whereSortInternal == Sort.asc) {
      return addWhereClause(WhereClause(
        indexName: null,
        upper: [isarId],
        includeUpper: false,
      )).addWhereClause(WhereClause(
        indexName: null,
        lower: [isarId],
        includeLower: false,
      ));
    } else {
      return addWhereClause(WhereClause(
        indexName: null,
        lower: [isarId],
        includeLower: false,
      )).addWhereClause(WhereClause(
        indexName: null,
        upper: [isarId],
        includeUpper: false,
      ));
    }
  }

  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterWhereClause>
      isarIdGreaterThan(
    int? isarId, {
    bool include = false,
  }) {
    return addWhereClause(WhereClause(
      indexName: null,
      lower: [isarId],
      includeLower: include,
    ));
  }

  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterWhereClause>
      isarIdLessThan(
    int? isarId, {
    bool include = false,
  }) {
    return addWhereClause(WhereClause(
      indexName: null,
      upper: [isarId],
      includeUpper: include,
    ));
  }

  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterWhereClause> isarIdBetween(
    int? lowerIsarId,
    int? upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addWhereClause(WhereClause(
      indexName: null,
      lower: [lowerIsarId],
      includeLower: includeLower,
      upper: [upperIsarId],
      includeUpper: includeUpper,
    ));
  }
}

extension SubjectsFilterQueryFilter
    on QueryBuilder<SubjectsFilter, SubjectsFilter, QFilterCondition> {
  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterFilterCondition>
      idIsNull() {
    return addFilterCondition(FilterCondition(
      type: ConditionType.isNull,
      property: 'id',
      value: null,
    ));
  }

  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterFilterCondition> idEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.eq,
      property: 'id',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterFilterCondition>
      idGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'id',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterFilterCondition>
      idLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'id',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterFilterCondition> idBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterCondition(FilterCondition.between(
      property: 'id',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterFilterCondition>
      idStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.startsWith,
      property: 'id',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterFilterCondition>
      idEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.endsWith,
      property: 'id',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterFilterCondition>
      idContains(String value, {bool caseSensitive = true}) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.contains,
      property: 'id',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterFilterCondition> idMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.matches,
      property: 'id',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterFilterCondition>
      isarIdIsNull() {
    return addFilterCondition(FilterCondition(
      type: ConditionType.isNull,
      property: 'isarId',
      value: null,
    ));
  }

  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterFilterCondition>
      isarIdEqualTo(int? value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.eq,
      property: 'isarId',
      value: value,
    ));
  }

  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterFilterCondition>
      isarIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'isarId',
      value: value,
    ));
  }

  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterFilterCondition>
      isarIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'isarId',
      value: value,
    ));
  }

  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterFilterCondition>
      isarIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterCondition(FilterCondition.between(
      property: 'isarId',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterFilterCondition>
      nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.eq,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterFilterCondition>
      nameGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterFilterCondition>
      nameLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterFilterCondition>
      nameBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterCondition(FilterCondition.between(
      property: 'name',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterFilterCondition>
      nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.startsWith,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterFilterCondition>
      nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.endsWith,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.contains,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterFilterCondition>
      nameMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.matches,
      property: 'name',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterFilterCondition>
      subjectsIdsIsNull() {
    return addFilterCondition(FilterCondition(
      type: ConditionType.isNull,
      property: 'subjectsIds',
      value: null,
    ));
  }

  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterFilterCondition>
      subjectsIdsAnyIsNull() {
    return addFilterCondition(FilterCondition(
      type: ConditionType.eq,
      property: 'subjectsIds',
      value: null,
    ));
  }

  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterFilterCondition>
      subjectsIdsAnyEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.eq,
      property: 'subjectsIds',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterFilterCondition>
      subjectsIdsAnyGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'subjectsIds',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterFilterCondition>
      subjectsIdsAnyLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'subjectsIds',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterFilterCondition>
      subjectsIdsAnyBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterCondition(FilterCondition.between(
      property: 'subjectsIds',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterFilterCondition>
      subjectsIdsAnyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.startsWith,
      property: 'subjectsIds',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterFilterCondition>
      subjectsIdsAnyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.endsWith,
      property: 'subjectsIds',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterFilterCondition>
      subjectsIdsAnyContains(String value, {bool caseSensitive = true}) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.contains,
      property: 'subjectsIds',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterFilterCondition>
      subjectsIdsAnyMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.matches,
      property: 'subjectsIds',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }
}

extension SubjectsFilterQueryWhereSortBy
    on QueryBuilder<SubjectsFilter, SubjectsFilter, QSortBy> {
  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterSortBy> sortByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterSortBy> sortByIsarId() {
    return addSortByInternal('isarId', Sort.asc);
  }

  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterSortBy>
      sortByIsarIdDesc() {
    return addSortByInternal('isarId', Sort.desc);
  }

  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterSortBy> sortByName() {
    return addSortByInternal('name', Sort.asc);
  }

  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterSortBy> sortByNameDesc() {
    return addSortByInternal('name', Sort.desc);
  }
}

extension SubjectsFilterQueryWhereSortThenBy
    on QueryBuilder<SubjectsFilter, SubjectsFilter, QSortThenBy> {
  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterSortBy> thenByIsarId() {
    return addSortByInternal('isarId', Sort.asc);
  }

  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterSortBy>
      thenByIsarIdDesc() {
    return addSortByInternal('isarId', Sort.desc);
  }

  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterSortBy> thenByName() {
    return addSortByInternal('name', Sort.asc);
  }

  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterSortBy> thenByNameDesc() {
    return addSortByInternal('name', Sort.desc);
  }
}

extension SubjectsFilterQueryWhereDistinct
    on QueryBuilder<SubjectsFilter, SubjectsFilter, QDistinct> {
  QueryBuilder<SubjectsFilter, SubjectsFilter, QDistinct> distinctById(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('id', caseSensitive: caseSensitive);
  }

  QueryBuilder<SubjectsFilter, SubjectsFilter, QDistinct> distinctByIsarId() {
    return addDistinctByInternal('isarId');
  }

  QueryBuilder<SubjectsFilter, SubjectsFilter, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('name', caseSensitive: caseSensitive);
  }
}

extension SubjectsFilterQueryProperty
    on QueryBuilder<SubjectsFilter, SubjectsFilter, QQueryProperty> {
  QueryBuilder<SubjectsFilter, String?, QQueryOperations> idProperty() {
    return addPropertyName('id');
  }

  QueryBuilder<SubjectsFilter, int?, QQueryOperations> isarIdProperty() {
    return addPropertyName('isarId');
  }

  QueryBuilder<SubjectsFilter, String, QQueryOperations> nameProperty() {
    return addPropertyName('name');
  }

  QueryBuilder<SubjectsFilter, List<String>?, QQueryOperations>
      subjectsIdsProperty() {
    return addPropertyName('subjectsIds');
  }
}
