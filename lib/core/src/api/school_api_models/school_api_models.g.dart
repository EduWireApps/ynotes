// GENERATED CODE - DO NOT MODIFY BY HAND

part of models;

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// ignore_for_file: duplicate_ignore, non_constant_identifier_names, invalid_use_of_protected_member

extension GetGradeCollection on Isar {
  IsarCollection<Grade> get grades {
    return getCollection('Grade');
  }
}

final GradeSchema = CollectionSchema(
  name: 'Grade',
  schema:
      '{"name":"Grade","properties":[{"name":"classAverage","type":"Double"},{"name":"classMax","type":"Double"},{"name":"classMin","type":"Double"},{"name":"coefficient","type":"Double"},{"name":"custom","type":"Byte"},{"name":"date","type":"Long"},{"name":"entryDate","type":"Long"},{"name":"name","type":"String"},{"name":"outOf","type":"Double"},{"name":"realValue","type":"Double"},{"name":"significant","type":"Byte"},{"name":"type","type":"String"},{"name":"value","type":"Double"}],"indexes":[],"links":[{"name":"period","target":"Period"},{"name":"subject","target":"Subject"}]}',
  adapter: const _GradeAdapter(),
  idName: 'id',
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
    'realValue': 9,
    'significant': 10,
    'type': 11,
    'value': 12
  },
  indexIds: {},
  indexTypes: {},
  linkIds: {'period': 0, 'subject': 1},
  backlinkIds: {},
  linkedCollections: ['Period', 'Subject'],
  getId: (obj) => obj.id,
  setId: (obj, id) => obj.id = id,
  getLinks: (obj) => [obj.period, obj.subject],
  version: 1,
);

class _GradeAdapter extends IsarTypeAdapter<Grade> {
  const _GradeAdapter();

  @override
  void serialize(IsarCollection<Grade> collection, IsarRawObject rawObj,
      Grade object, List<int> offsets, AdapterAlloc alloc) {
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
    final value9 = object.realValue;
    final _realValue = value9;
    final value10 = object.significant;
    final _significant = value10;
    final value11 = object.type;
    final _type = BinaryWriter.utf8Encoder.convert(value11);
    dynamicSize += _type.length;
    final value12 = object.value;
    final _value = value12;
    final size = dynamicSize + 92;

    rawObj.buffer = alloc(size);
    rawObj.buffer_length = size;
    final buffer = bufAsBytes(rawObj.buffer, size);
    final writer = BinaryWriter(buffer, 92);
    writer.writeDouble(offsets[0], _classAverage);
    writer.writeDouble(offsets[1], _classMax);
    writer.writeDouble(offsets[2], _classMin);
    writer.writeDouble(offsets[3], _coefficient);
    writer.writeBool(offsets[4], _custom);
    writer.writeDateTime(offsets[5], _date);
    writer.writeDateTime(offsets[6], _entryDate);
    writer.writeBytes(offsets[7], _name);
    writer.writeDouble(offsets[8], _outOf);
    writer.writeDouble(offsets[9], _realValue);
    writer.writeBool(offsets[10], _significant);
    writer.writeBytes(offsets[11], _type);
    writer.writeDouble(offsets[12], _value);
    attachLinks(collection.isar, object);
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
      significant: reader.readBool(offsets[10]),
      type: reader.readString(offsets[11]),
      value: reader.readDouble(offsets[12]),
    );
    object.id = id;
    attachLinks(collection.isar, object);
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
        return (reader.readDouble(offset)) as P;
      case 10:
        return (reader.readBool(offset)) as P;
      case 11:
        return (reader.readString(offset)) as P;
      case 12:
        return (reader.readDouble(offset)) as P;
      default:
        throw 'Illegal propertyIndex';
    }
  }

  void attachLinks(Isar isar, Grade object) {
    object.period.attach(
      isar.grades,
      isar.getCollection<Period>("Period"),
      object,
      "period",
      false,
    );
    object.subject.attach(
      isar.grades,
      isar.getCollection<Subject>("Subject"),
      object,
      "subject",
      false,
    );
  }
}

extension GradeQueryWhereSort on QueryBuilder<Grade, Grade, QWhere> {
  QueryBuilder<Grade, Grade, QAfterWhere> anyId() {
    return addWhereClauseInternal(const WhereClause(indexName: null));
  }
}

extension GradeQueryWhere on QueryBuilder<Grade, Grade, QWhereClause> {
  QueryBuilder<Grade, Grade, QAfterWhereClause> idEqualTo(int? id) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [id],
      includeLower: true,
      upper: [id],
      includeUpper: true,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterWhereClause> idNotEqualTo(int? id) {
    if (whereSortInternal == Sort.asc) {
      return addWhereClauseInternal(WhereClause(
        indexName: null,
        upper: [id],
        includeUpper: false,
      )).addWhereClauseInternal(WhereClause(
        indexName: null,
        lower: [id],
        includeLower: false,
      ));
    } else {
      return addWhereClauseInternal(WhereClause(
        indexName: null,
        lower: [id],
        includeLower: false,
      )).addWhereClauseInternal(WhereClause(
        indexName: null,
        upper: [id],
        includeUpper: false,
      ));
    }
  }

  QueryBuilder<Grade, Grade, QAfterWhereClause> idGreaterThan(
    int? id, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [id],
      includeLower: include,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterWhereClause> idLessThan(
    int? id, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      upper: [id],
      includeUpper: include,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterWhereClause> idBetween(
    int? lowerId,
    int? upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [lowerId],
      includeLower: includeLower,
      upper: [upperId],
      includeUpper: includeUpper,
    ));
  }
}

extension GradeQueryFilter on QueryBuilder<Grade, Grade, QFilterCondition> {
  QueryBuilder<Grade, Grade, QAfterFilterCondition> classAverageGreaterThan(
      double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'classAverage',
      value: value,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> classAverageLessThan(
      double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'classAverage',
      value: value,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> classAverageBetween(
      double lower, double upper) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'classAverage',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> classMaxGreaterThan(
      double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'classMax',
      value: value,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> classMaxLessThan(
      double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'classMax',
      value: value,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> classMaxBetween(
      double lower, double upper) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'classMax',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> classMinGreaterThan(
      double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'classMin',
      value: value,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> classMinLessThan(
      double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'classMin',
      value: value,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> classMinBetween(
      double lower, double upper) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'classMin',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> coefficientGreaterThan(
      double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'coefficient',
      value: value,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> coefficientLessThan(
      double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'coefficient',
      value: value,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> coefficientBetween(
      double lower, double upper) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'coefficient',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> customEqualTo(bool value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'custom',
      value: value,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> dateEqualTo(
      DateTime value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'date',
      value: value,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> dateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
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
    return addFilterConditionInternal(FilterCondition(
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
    return addFilterConditionInternal(FilterCondition.between(
      property: 'date',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> entryDateEqualTo(
      DateTime value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'entryDate',
      value: value,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> entryDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
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
    return addFilterConditionInternal(FilterCondition(
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
    return addFilterConditionInternal(FilterCondition.between(
      property: 'entryDate',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> idIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'id',
      value: null,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> idEqualTo(int? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> idGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> idLessThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> idBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'id',
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
    return addFilterConditionInternal(FilterCondition(
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
    return addFilterConditionInternal(FilterCondition(
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
    return addFilterConditionInternal(FilterCondition(
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
    return addFilterConditionInternal(FilterCondition.between(
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
    return addFilterConditionInternal(FilterCondition(
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
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> nameContains(String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> nameMatches(String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'name',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> outOfGreaterThan(
      double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'outOf',
      value: value,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> outOfLessThan(
      double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'outOf',
      value: value,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> outOfBetween(
      double lower, double upper) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'outOf',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> realValueGreaterThan(
      double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'realValue',
      value: value,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> realValueLessThan(
      double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'realValue',
      value: value,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> realValueBetween(
      double lower, double upper) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'realValue',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> significantEqualTo(
      bool value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'significant',
      value: value,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> typeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
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
    return addFilterConditionInternal(FilterCondition(
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
    return addFilterConditionInternal(FilterCondition(
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
    return addFilterConditionInternal(FilterCondition.between(
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
    return addFilterConditionInternal(FilterCondition(
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
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'type',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> typeContains(String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'type',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> typeMatches(String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'type',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> valueGreaterThan(
      double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'value',
      value: value,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> valueLessThan(
      double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'value',
      value: value,
    ));
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> valueBetween(
      double lower, double upper) {
    return addFilterConditionInternal(FilterCondition.between(
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

  QueryBuilder<Grade, Grade, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> sortByIdDesc() {
    return addSortByInternal('id', Sort.desc);
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

  QueryBuilder<Grade, Grade, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.desc);
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

  QueryBuilder<Grade, Grade, QDistinct> distinctById() {
    return addDistinctByInternal('id');
  }

  QueryBuilder<Grade, Grade, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('name', caseSensitive: caseSensitive);
  }

  QueryBuilder<Grade, Grade, QDistinct> distinctByOutOf() {
    return addDistinctByInternal('outOf');
  }

  QueryBuilder<Grade, Grade, QDistinct> distinctByRealValue() {
    return addDistinctByInternal('realValue');
  }

  QueryBuilder<Grade, Grade, QDistinct> distinctBySignificant() {
    return addDistinctByInternal('significant');
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
    return addPropertyNameInternal('classAverage');
  }

  QueryBuilder<Grade, double, QQueryOperations> classMaxProperty() {
    return addPropertyNameInternal('classMax');
  }

  QueryBuilder<Grade, double, QQueryOperations> classMinProperty() {
    return addPropertyNameInternal('classMin');
  }

  QueryBuilder<Grade, double, QQueryOperations> coefficientProperty() {
    return addPropertyNameInternal('coefficient');
  }

  QueryBuilder<Grade, bool, QQueryOperations> customProperty() {
    return addPropertyNameInternal('custom');
  }

  QueryBuilder<Grade, DateTime, QQueryOperations> dateProperty() {
    return addPropertyNameInternal('date');
  }

  QueryBuilder<Grade, DateTime, QQueryOperations> entryDateProperty() {
    return addPropertyNameInternal('entryDate');
  }

  QueryBuilder<Grade, int?, QQueryOperations> idProperty() {
    return addPropertyNameInternal('id');
  }

  QueryBuilder<Grade, String, QQueryOperations> nameProperty() {
    return addPropertyNameInternal('name');
  }

  QueryBuilder<Grade, double, QQueryOperations> outOfProperty() {
    return addPropertyNameInternal('outOf');
  }

  QueryBuilder<Grade, double, QQueryOperations> realValueProperty() {
    return addPropertyNameInternal('realValue');
  }

  QueryBuilder<Grade, bool, QQueryOperations> significantProperty() {
    return addPropertyNameInternal('significant');
  }

  QueryBuilder<Grade, String, QQueryOperations> typeProperty() {
    return addPropertyNameInternal('type');
  }

  QueryBuilder<Grade, double, QQueryOperations> valueProperty() {
    return addPropertyNameInternal('value');
  }
}

// ignore_for_file: duplicate_ignore, non_constant_identifier_names, invalid_use_of_protected_member

extension GetSubjectCollection on Isar {
  IsarCollection<Subject> get subjects {
    return getCollection('Subject');
  }
}

final SubjectSchema = CollectionSchema(
  name: 'Subject',
  schema:
      '{"name":"Subject","properties":[{"name":"average","type":"Double"},{"name":"classAverage","type":"Double"},{"name":"coefficient","type":"Double"},{"name":"color","type":"String"},{"name":"entityId","type":"String"},{"name":"maxAverage","type":"Double"},{"name":"minAverage","type":"Double"},{"name":"name","type":"String"},{"name":"teachers","type":"String"}],"indexes":[],"links":[{"name":"period","target":"Period"}]}',
  adapter: const _SubjectAdapter(),
  idName: 'id',
  propertyIds: {
    'average': 0,
    'classAverage': 1,
    'coefficient': 2,
    'color': 3,
    'entityId': 4,
    'maxAverage': 5,
    'minAverage': 6,
    'name': 7,
    'teachers': 8
  },
  indexIds: {},
  indexTypes: {},
  linkIds: {'period': 0},
  backlinkIds: {'grades': 0},
  linkedCollections: ['Grade', 'Period'],
  getId: (obj) => obj.id,
  setId: (obj, id) => obj.id = id,
  getLinks: (obj) => [obj.grades, obj.period],
  version: 1,
);

class _SubjectAdapter extends IsarTypeAdapter<Subject> {
  const _SubjectAdapter();

  static const _yTColorConverter = YTColorConverter();

  @override
  void serialize(IsarCollection<Subject> collection, IsarRawObject rawObj,
      Subject object, List<int> offsets, AdapterAlloc alloc) {
    var dynamicSize = 0;
    final value0 = object.average;
    final _average = value0;
    final value1 = object.classAverage;
    final _classAverage = value1;
    final value2 = object.coefficient;
    final _coefficient = value2;
    final value3 = _SubjectAdapter._yTColorConverter.toIsar(object.color);
    final _color = BinaryWriter.utf8Encoder.convert(value3);
    dynamicSize += _color.length;
    final value4 = object.entityId;
    final _entityId = BinaryWriter.utf8Encoder.convert(value4);
    dynamicSize += _entityId.length;
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
    final size = dynamicSize + 74;

    rawObj.buffer = alloc(size);
    rawObj.buffer_length = size;
    final buffer = bufAsBytes(rawObj.buffer, size);
    final writer = BinaryWriter(buffer, 74);
    writer.writeDouble(offsets[0], _average);
    writer.writeDouble(offsets[1], _classAverage);
    writer.writeDouble(offsets[2], _coefficient);
    writer.writeBytes(offsets[3], _color);
    writer.writeBytes(offsets[4], _entityId);
    writer.writeDouble(offsets[5], _maxAverage);
    writer.writeDouble(offsets[6], _minAverage);
    writer.writeBytes(offsets[7], _name);
    writer.writeBytes(offsets[8], _teachers);
    attachLinks(collection.isar, object);
  }

  @override
  Subject deserialize(IsarCollection<Subject> collection, int id,
      BinaryReader reader, List<int> offsets) {
    final object = Subject(
      average: reader.readDouble(offsets[0]),
      classAverage: reader.readDouble(offsets[1]),
      coefficient: reader.readDouble(offsets[2]),
      color: _SubjectAdapter._yTColorConverter
          .fromIsar(reader.readString(offsets[3])),
      entityId: reader.readString(offsets[4]),
      maxAverage: reader.readDouble(offsets[5]),
      minAverage: reader.readDouble(offsets[6]),
      name: reader.readString(offsets[7]),
      teachers: reader.readString(offsets[8]),
    );
    object.id = id;
    attachLinks(collection.isar, object);
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
        return (_SubjectAdapter._yTColorConverter
            .fromIsar(reader.readString(offset))) as P;
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

  void attachLinks(Isar isar, Subject object) {
    object.grades.attach(
      isar.subjects,
      isar.getCollection<Grade>("Grade"),
      object,
      "grades",
      true,
    );
    object.period.attach(
      isar.subjects,
      isar.getCollection<Period>("Period"),
      object,
      "period",
      false,
    );
  }
}

extension SubjectQueryWhereSort on QueryBuilder<Subject, Subject, QWhere> {
  QueryBuilder<Subject, Subject, QAfterWhere> anyId() {
    return addWhereClauseInternal(const WhereClause(indexName: null));
  }
}

extension SubjectQueryWhere on QueryBuilder<Subject, Subject, QWhereClause> {
  QueryBuilder<Subject, Subject, QAfterWhereClause> idEqualTo(int? id) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [id],
      includeLower: true,
      upper: [id],
      includeUpper: true,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterWhereClause> idNotEqualTo(int? id) {
    if (whereSortInternal == Sort.asc) {
      return addWhereClauseInternal(WhereClause(
        indexName: null,
        upper: [id],
        includeUpper: false,
      )).addWhereClauseInternal(WhereClause(
        indexName: null,
        lower: [id],
        includeLower: false,
      ));
    } else {
      return addWhereClauseInternal(WhereClause(
        indexName: null,
        lower: [id],
        includeLower: false,
      )).addWhereClauseInternal(WhereClause(
        indexName: null,
        upper: [id],
        includeUpper: false,
      ));
    }
  }

  QueryBuilder<Subject, Subject, QAfterWhereClause> idGreaterThan(
    int? id, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [id],
      includeLower: include,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterWhereClause> idLessThan(
    int? id, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      upper: [id],
      includeUpper: include,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterWhereClause> idBetween(
    int? lowerId,
    int? upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [lowerId],
      includeLower: includeLower,
      upper: [upperId],
      includeUpper: includeUpper,
    ));
  }
}

extension SubjectQueryFilter
    on QueryBuilder<Subject, Subject, QFilterCondition> {
  QueryBuilder<Subject, Subject, QAfterFilterCondition> averageGreaterThan(
      double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'average',
      value: value,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> averageLessThan(
      double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'average',
      value: value,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> averageBetween(
      double lower, double upper) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'average',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> classAverageGreaterThan(
      double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'classAverage',
      value: value,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> classAverageLessThan(
      double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'classAverage',
      value: value,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> classAverageBetween(
      double lower, double upper) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'classAverage',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> coefficientGreaterThan(
      double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'coefficient',
      value: value,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> coefficientLessThan(
      double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'coefficient',
      value: value,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> coefficientBetween(
      double lower, double upper) {
    return addFilterConditionInternal(FilterCondition.between(
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
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'color',
      value: _SubjectAdapter._yTColorConverter.toIsar(value),
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> colorGreaterThan(
    YTColor value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'color',
      value: _SubjectAdapter._yTColorConverter.toIsar(value),
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> colorLessThan(
    YTColor value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'color',
      value: _SubjectAdapter._yTColorConverter.toIsar(value),
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
    return addFilterConditionInternal(FilterCondition.between(
      property: 'color',
      lower: _SubjectAdapter._yTColorConverter.toIsar(lower),
      includeLower: includeLower,
      upper: _SubjectAdapter._yTColorConverter.toIsar(upper),
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> colorStartsWith(
    YTColor value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'color',
      value: _SubjectAdapter._yTColorConverter.toIsar(value),
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> colorEndsWith(
    YTColor value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'color',
      value: _SubjectAdapter._yTColorConverter.toIsar(value),
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> colorContains(
      YTColor value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'color',
      value: _SubjectAdapter._yTColorConverter.toIsar(value),
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> colorMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'color',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> entityIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'entityId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> entityIdGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'entityId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> entityIdLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'entityId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> entityIdBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'entityId',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> entityIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'entityId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> entityIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'entityId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> entityIdContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'entityId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> entityIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'entityId',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> idIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'id',
      value: null,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> idEqualTo(int? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> idGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> idLessThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> idBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'id',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> maxAverageGreaterThan(
      double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'maxAverage',
      value: value,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> maxAverageLessThan(
      double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'maxAverage',
      value: value,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> maxAverageBetween(
      double lower, double upper) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'maxAverage',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> minAverageGreaterThan(
      double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'minAverage',
      value: value,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> minAverageLessThan(
      double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'minAverage',
      value: value,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> minAverageBetween(
      double lower, double upper) {
    return addFilterConditionInternal(FilterCondition.between(
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
    return addFilterConditionInternal(FilterCondition(
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
    return addFilterConditionInternal(FilterCondition(
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
    return addFilterConditionInternal(FilterCondition(
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
    return addFilterConditionInternal(FilterCondition.between(
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
    return addFilterConditionInternal(FilterCondition(
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
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
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
    return addFilterConditionInternal(FilterCondition(
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
    return addFilterConditionInternal(FilterCondition(
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
    return addFilterConditionInternal(FilterCondition(
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
    return addFilterConditionInternal(FilterCondition.between(
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
    return addFilterConditionInternal(FilterCondition(
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
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'teachers',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> teachersContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'teachers',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> teachersMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
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

  QueryBuilder<Subject, Subject, QAfterSortBy> sortByEntityId() {
    return addSortByInternal('entityId', Sort.asc);
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> sortByEntityIdDesc() {
    return addSortByInternal('entityId', Sort.desc);
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> sortByIdDesc() {
    return addSortByInternal('id', Sort.desc);
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

  QueryBuilder<Subject, Subject, QAfterSortBy> thenByEntityId() {
    return addSortByInternal('entityId', Sort.asc);
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> thenByEntityIdDesc() {
    return addSortByInternal('entityId', Sort.desc);
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.desc);
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

  QueryBuilder<Subject, Subject, QDistinct> distinctByEntityId(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('entityId', caseSensitive: caseSensitive);
  }

  QueryBuilder<Subject, Subject, QDistinct> distinctById() {
    return addDistinctByInternal('id');
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
    return addPropertyNameInternal('average');
  }

  QueryBuilder<Subject, double, QQueryOperations> classAverageProperty() {
    return addPropertyNameInternal('classAverage');
  }

  QueryBuilder<Subject, double, QQueryOperations> coefficientProperty() {
    return addPropertyNameInternal('coefficient');
  }

  QueryBuilder<Subject, YTColor, QQueryOperations> colorProperty() {
    return addPropertyNameInternal('color');
  }

  QueryBuilder<Subject, String, QQueryOperations> entityIdProperty() {
    return addPropertyNameInternal('entityId');
  }

  QueryBuilder<Subject, int?, QQueryOperations> idProperty() {
    return addPropertyNameInternal('id');
  }

  QueryBuilder<Subject, double, QQueryOperations> maxAverageProperty() {
    return addPropertyNameInternal('maxAverage');
  }

  QueryBuilder<Subject, double, QQueryOperations> minAverageProperty() {
    return addPropertyNameInternal('minAverage');
  }

  QueryBuilder<Subject, String, QQueryOperations> nameProperty() {
    return addPropertyNameInternal('name');
  }

  QueryBuilder<Subject, String, QQueryOperations> teachersProperty() {
    return addPropertyNameInternal('teachers');
  }
}

// ignore_for_file: duplicate_ignore, non_constant_identifier_names, invalid_use_of_protected_member

extension GetSubjectsFilterCollection on Isar {
  IsarCollection<SubjectsFilter> get subjectsFilters {
    return getCollection('SubjectsFilter');
  }
}

final SubjectsFilterSchema = CollectionSchema(
  name: 'SubjectsFilter',
  schema:
      '{"name":"SubjectsFilter","properties":[{"name":"entityId","type":"String"},{"name":"name","type":"String"}],"indexes":[],"links":[{"name":"subjects","target":"Subject"}]}',
  adapter: const _SubjectsFilterAdapter(),
  idName: 'id',
  propertyIds: {'entityId': 0, 'name': 1},
  indexIds: {},
  indexTypes: {},
  linkIds: {'subjects': 0},
  backlinkIds: {},
  linkedCollections: ['Subject'],
  getId: (obj) => obj.id,
  setId: (obj, id) => obj.id = id,
  getLinks: (obj) => [obj.subjects],
  version: 1,
);

class _SubjectsFilterAdapter extends IsarTypeAdapter<SubjectsFilter> {
  const _SubjectsFilterAdapter();

  @override
  void serialize(
      IsarCollection<SubjectsFilter> collection,
      IsarRawObject rawObj,
      SubjectsFilter object,
      List<int> offsets,
      AdapterAlloc alloc) {
    var dynamicSize = 0;
    final value0 = object.entityId;
    final _entityId = BinaryWriter.utf8Encoder.convert(value0);
    dynamicSize += _entityId.length;
    final value1 = object.name;
    final _name = BinaryWriter.utf8Encoder.convert(value1);
    dynamicSize += _name.length;
    final size = dynamicSize + 18;

    rawObj.buffer = alloc(size);
    rawObj.buffer_length = size;
    final buffer = bufAsBytes(rawObj.buffer, size);
    final writer = BinaryWriter(buffer, 18);
    writer.writeBytes(offsets[0], _entityId);
    writer.writeBytes(offsets[1], _name);
    attachLinks(collection.isar, object);
  }

  @override
  SubjectsFilter deserialize(IsarCollection<SubjectsFilter> collection, int id,
      BinaryReader reader, List<int> offsets) {
    final object = SubjectsFilter(
      entityId: reader.readString(offsets[0]),
      name: reader.readString(offsets[1]),
    );
    object.id = id;
    attachLinks(collection.isar, object);
    return object;
  }

  @override
  P deserializeProperty<P>(
      int id, BinaryReader reader, int propertyIndex, int offset) {
    switch (propertyIndex) {
      case -1:
        return id as P;
      case 0:
        return (reader.readString(offset)) as P;
      case 1:
        return (reader.readString(offset)) as P;
      default:
        throw 'Illegal propertyIndex';
    }
  }

  void attachLinks(Isar isar, SubjectsFilter object) {
    object.subjects.attach(
      isar.subjectsFilters,
      isar.getCollection<Subject>("Subject"),
      object,
      "subjects",
      false,
    );
  }
}

extension SubjectsFilterQueryWhereSort
    on QueryBuilder<SubjectsFilter, SubjectsFilter, QWhere> {
  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterWhere> anyId() {
    return addWhereClauseInternal(const WhereClause(indexName: null));
  }
}

extension SubjectsFilterQueryWhere
    on QueryBuilder<SubjectsFilter, SubjectsFilter, QWhereClause> {
  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterWhereClause> idEqualTo(
      int? id) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [id],
      includeLower: true,
      upper: [id],
      includeUpper: true,
    ));
  }

  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterWhereClause> idNotEqualTo(
      int? id) {
    if (whereSortInternal == Sort.asc) {
      return addWhereClauseInternal(WhereClause(
        indexName: null,
        upper: [id],
        includeUpper: false,
      )).addWhereClauseInternal(WhereClause(
        indexName: null,
        lower: [id],
        includeLower: false,
      ));
    } else {
      return addWhereClauseInternal(WhereClause(
        indexName: null,
        lower: [id],
        includeLower: false,
      )).addWhereClauseInternal(WhereClause(
        indexName: null,
        upper: [id],
        includeUpper: false,
      ));
    }
  }

  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterWhereClause> idGreaterThan(
    int? id, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [id],
      includeLower: include,
    ));
  }

  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterWhereClause> idLessThan(
    int? id, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      upper: [id],
      includeUpper: include,
    ));
  }

  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterWhereClause> idBetween(
    int? lowerId,
    int? upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [lowerId],
      includeLower: includeLower,
      upper: [upperId],
      includeUpper: includeUpper,
    ));
  }
}

extension SubjectsFilterQueryFilter
    on QueryBuilder<SubjectsFilter, SubjectsFilter, QFilterCondition> {
  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterFilterCondition>
      entityIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'entityId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterFilterCondition>
      entityIdGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'entityId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterFilterCondition>
      entityIdLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'entityId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterFilterCondition>
      entityIdBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'entityId',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterFilterCondition>
      entityIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'entityId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterFilterCondition>
      entityIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'entityId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterFilterCondition>
      entityIdContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'entityId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterFilterCondition>
      entityIdMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'entityId',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterFilterCondition>
      idIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'id',
      value: null,
    ));
  }

  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterFilterCondition> idEqualTo(
      int? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterFilterCondition>
      idGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterFilterCondition>
      idLessThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterFilterCondition> idBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'id',
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
    return addFilterConditionInternal(FilterCondition(
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
    return addFilterConditionInternal(FilterCondition(
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
    return addFilterConditionInternal(FilterCondition(
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
    return addFilterConditionInternal(FilterCondition.between(
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
    return addFilterConditionInternal(FilterCondition(
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
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterFilterCondition>
      nameMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'name',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }
}

extension SubjectsFilterQueryWhereSortBy
    on QueryBuilder<SubjectsFilter, SubjectsFilter, QSortBy> {
  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterSortBy> sortByEntityId() {
    return addSortByInternal('entityId', Sort.asc);
  }

  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterSortBy>
      sortByEntityIdDesc() {
    return addSortByInternal('entityId', Sort.desc);
  }

  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterSortBy> sortByIdDesc() {
    return addSortByInternal('id', Sort.desc);
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
  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterSortBy> thenByEntityId() {
    return addSortByInternal('entityId', Sort.asc);
  }

  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterSortBy>
      thenByEntityIdDesc() {
    return addSortByInternal('entityId', Sort.desc);
  }

  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<SubjectsFilter, SubjectsFilter, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.desc);
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
  QueryBuilder<SubjectsFilter, SubjectsFilter, QDistinct> distinctByEntityId(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('entityId', caseSensitive: caseSensitive);
  }

  QueryBuilder<SubjectsFilter, SubjectsFilter, QDistinct> distinctById() {
    return addDistinctByInternal('id');
  }

  QueryBuilder<SubjectsFilter, SubjectsFilter, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('name', caseSensitive: caseSensitive);
  }
}

extension SubjectsFilterQueryProperty
    on QueryBuilder<SubjectsFilter, SubjectsFilter, QQueryProperty> {
  QueryBuilder<SubjectsFilter, String, QQueryOperations> entityIdProperty() {
    return addPropertyNameInternal('entityId');
  }

  QueryBuilder<SubjectsFilter, int?, QQueryOperations> idProperty() {
    return addPropertyNameInternal('id');
  }

  QueryBuilder<SubjectsFilter, String, QQueryOperations> nameProperty() {
    return addPropertyNameInternal('name');
  }
}

// ignore_for_file: duplicate_ignore, non_constant_identifier_names, invalid_use_of_protected_member

extension GetPeriodCollection on Isar {
  IsarCollection<Period> get periods {
    return getCollection('Period');
  }
}

final PeriodSchema = CollectionSchema(
  name: 'Period',
  schema:
      '{"name":"Period","properties":[{"name":"classAverage","type":"Double"},{"name":"endDate","type":"Long"},{"name":"entityId","type":"String"},{"name":"headTeacher","type":"String"},{"name":"maxAverage","type":"Double"},{"name":"minAverage","type":"Double"},{"name":"name","type":"String"},{"name":"overallAverage","type":"Double"},{"name":"startDate","type":"Long"}],"indexes":[],"links":[]}',
  adapter: const _PeriodAdapter(),
  idName: 'id',
  propertyIds: {
    'classAverage': 0,
    'endDate': 1,
    'entityId': 2,
    'headTeacher': 3,
    'maxAverage': 4,
    'minAverage': 5,
    'name': 6,
    'overallAverage': 7,
    'startDate': 8
  },
  indexIds: {},
  indexTypes: {},
  linkIds: {},
  backlinkIds: {'grades': 0, 'subjects': 1},
  linkedCollections: ['Grade', 'Subject'],
  getId: (obj) => obj.id,
  setId: (obj, id) => obj.id = id,
  getLinks: (obj) => [obj.grades, obj.subjects],
  version: 1,
);

class _PeriodAdapter extends IsarTypeAdapter<Period> {
  const _PeriodAdapter();

  @override
  void serialize(IsarCollection<Period> collection, IsarRawObject rawObj,
      Period object, List<int> offsets, AdapterAlloc alloc) {
    var dynamicSize = 0;
    final value0 = object.classAverage;
    final _classAverage = value0;
    final value1 = object.endDate;
    final _endDate = value1;
    final value2 = object.entityId;
    final _entityId = BinaryWriter.utf8Encoder.convert(value2);
    dynamicSize += _entityId.length;
    final value3 = object.headTeacher;
    final _headTeacher = BinaryWriter.utf8Encoder.convert(value3);
    dynamicSize += _headTeacher.length;
    final value4 = object.maxAverage;
    final _maxAverage = value4;
    final value5 = object.minAverage;
    final _minAverage = value5;
    final value6 = object.name;
    final _name = BinaryWriter.utf8Encoder.convert(value6);
    dynamicSize += _name.length;
    final value7 = object.overallAverage;
    final _overallAverage = value7;
    final value8 = object.startDate;
    final _startDate = value8;
    final size = dynamicSize + 74;

    rawObj.buffer = alloc(size);
    rawObj.buffer_length = size;
    final buffer = bufAsBytes(rawObj.buffer, size);
    final writer = BinaryWriter(buffer, 74);
    writer.writeDouble(offsets[0], _classAverage);
    writer.writeDateTime(offsets[1], _endDate);
    writer.writeBytes(offsets[2], _entityId);
    writer.writeBytes(offsets[3], _headTeacher);
    writer.writeDouble(offsets[4], _maxAverage);
    writer.writeDouble(offsets[5], _minAverage);
    writer.writeBytes(offsets[6], _name);
    writer.writeDouble(offsets[7], _overallAverage);
    writer.writeDateTime(offsets[8], _startDate);
    attachLinks(collection.isar, object);
  }

  @override
  Period deserialize(IsarCollection<Period> collection, int id,
      BinaryReader reader, List<int> offsets) {
    final object = Period(
      classAverage: reader.readDouble(offsets[0]),
      endDate: reader.readDateTime(offsets[1]),
      entityId: reader.readString(offsets[2]),
      headTeacher: reader.readString(offsets[3]),
      maxAverage: reader.readDouble(offsets[4]),
      minAverage: reader.readDouble(offsets[5]),
      name: reader.readString(offsets[6]),
      overallAverage: reader.readDouble(offsets[7]),
      startDate: reader.readDateTime(offsets[8]),
    );
    object.id = id;
    attachLinks(collection.isar, object);
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
        return (reader.readDateTime(offset)) as P;
      case 2:
        return (reader.readString(offset)) as P;
      case 3:
        return (reader.readString(offset)) as P;
      case 4:
        return (reader.readDouble(offset)) as P;
      case 5:
        return (reader.readDouble(offset)) as P;
      case 6:
        return (reader.readString(offset)) as P;
      case 7:
        return (reader.readDouble(offset)) as P;
      case 8:
        return (reader.readDateTime(offset)) as P;
      default:
        throw 'Illegal propertyIndex';
    }
  }

  void attachLinks(Isar isar, Period object) {
    object.grades.attach(
      isar.periods,
      isar.getCollection<Grade>("Grade"),
      object,
      "grades",
      true,
    );
    object.subjects.attach(
      isar.periods,
      isar.getCollection<Subject>("Subject"),
      object,
      "subjects",
      true,
    );
  }
}

extension PeriodQueryWhereSort on QueryBuilder<Period, Period, QWhere> {
  QueryBuilder<Period, Period, QAfterWhere> anyId() {
    return addWhereClauseInternal(const WhereClause(indexName: null));
  }
}

extension PeriodQueryWhere on QueryBuilder<Period, Period, QWhereClause> {
  QueryBuilder<Period, Period, QAfterWhereClause> idEqualTo(int? id) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [id],
      includeLower: true,
      upper: [id],
      includeUpper: true,
    ));
  }

  QueryBuilder<Period, Period, QAfterWhereClause> idNotEqualTo(int? id) {
    if (whereSortInternal == Sort.asc) {
      return addWhereClauseInternal(WhereClause(
        indexName: null,
        upper: [id],
        includeUpper: false,
      )).addWhereClauseInternal(WhereClause(
        indexName: null,
        lower: [id],
        includeLower: false,
      ));
    } else {
      return addWhereClauseInternal(WhereClause(
        indexName: null,
        lower: [id],
        includeLower: false,
      )).addWhereClauseInternal(WhereClause(
        indexName: null,
        upper: [id],
        includeUpper: false,
      ));
    }
  }

  QueryBuilder<Period, Period, QAfterWhereClause> idGreaterThan(
    int? id, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [id],
      includeLower: include,
    ));
  }

  QueryBuilder<Period, Period, QAfterWhereClause> idLessThan(
    int? id, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      upper: [id],
      includeUpper: include,
    ));
  }

  QueryBuilder<Period, Period, QAfterWhereClause> idBetween(
    int? lowerId,
    int? upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [lowerId],
      includeLower: includeLower,
      upper: [upperId],
      includeUpper: includeUpper,
    ));
  }
}

extension PeriodQueryFilter on QueryBuilder<Period, Period, QFilterCondition> {
  QueryBuilder<Period, Period, QAfterFilterCondition> classAverageGreaterThan(
      double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'classAverage',
      value: value,
    ));
  }

  QueryBuilder<Period, Period, QAfterFilterCondition> classAverageLessThan(
      double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'classAverage',
      value: value,
    ));
  }

  QueryBuilder<Period, Period, QAfterFilterCondition> classAverageBetween(
      double lower, double upper) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'classAverage',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<Period, Period, QAfterFilterCondition> endDateEqualTo(
      DateTime value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'endDate',
      value: value,
    ));
  }

  QueryBuilder<Period, Period, QAfterFilterCondition> endDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'endDate',
      value: value,
    ));
  }

  QueryBuilder<Period, Period, QAfterFilterCondition> endDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'endDate',
      value: value,
    ));
  }

  QueryBuilder<Period, Period, QAfterFilterCondition> endDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'endDate',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Period, Period, QAfterFilterCondition> entityIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'entityId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Period, Period, QAfterFilterCondition> entityIdGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'entityId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Period, Period, QAfterFilterCondition> entityIdLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'entityId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Period, Period, QAfterFilterCondition> entityIdBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'entityId',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Period, Period, QAfterFilterCondition> entityIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'entityId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Period, Period, QAfterFilterCondition> entityIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'entityId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Period, Period, QAfterFilterCondition> entityIdContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'entityId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Period, Period, QAfterFilterCondition> entityIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'entityId',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Period, Period, QAfterFilterCondition> headTeacherEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'headTeacher',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Period, Period, QAfterFilterCondition> headTeacherGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'headTeacher',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Period, Period, QAfterFilterCondition> headTeacherLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'headTeacher',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Period, Period, QAfterFilterCondition> headTeacherBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'headTeacher',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Period, Period, QAfterFilterCondition> headTeacherStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'headTeacher',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Period, Period, QAfterFilterCondition> headTeacherEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'headTeacher',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Period, Period, QAfterFilterCondition> headTeacherContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'headTeacher',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Period, Period, QAfterFilterCondition> headTeacherMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'headTeacher',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Period, Period, QAfterFilterCondition> idIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'id',
      value: null,
    ));
  }

  QueryBuilder<Period, Period, QAfterFilterCondition> idEqualTo(int? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Period, Period, QAfterFilterCondition> idGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Period, Period, QAfterFilterCondition> idLessThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Period, Period, QAfterFilterCondition> idBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'id',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Period, Period, QAfterFilterCondition> maxAverageGreaterThan(
      double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'maxAverage',
      value: value,
    ));
  }

  QueryBuilder<Period, Period, QAfterFilterCondition> maxAverageLessThan(
      double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'maxAverage',
      value: value,
    ));
  }

  QueryBuilder<Period, Period, QAfterFilterCondition> maxAverageBetween(
      double lower, double upper) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'maxAverage',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<Period, Period, QAfterFilterCondition> minAverageGreaterThan(
      double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'minAverage',
      value: value,
    ));
  }

  QueryBuilder<Period, Period, QAfterFilterCondition> minAverageLessThan(
      double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'minAverage',
      value: value,
    ));
  }

  QueryBuilder<Period, Period, QAfterFilterCondition> minAverageBetween(
      double lower, double upper) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'minAverage',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<Period, Period, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Period, Period, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Period, Period, QAfterFilterCondition> nameLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Period, Period, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'name',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Period, Period, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Period, Period, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Period, Period, QAfterFilterCondition> nameContains(String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Period, Period, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'name',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Period, Period, QAfterFilterCondition> overallAverageGreaterThan(
      double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'overallAverage',
      value: value,
    ));
  }

  QueryBuilder<Period, Period, QAfterFilterCondition> overallAverageLessThan(
      double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'overallAverage',
      value: value,
    ));
  }

  QueryBuilder<Period, Period, QAfterFilterCondition> overallAverageBetween(
      double lower, double upper) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'overallAverage',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<Period, Period, QAfterFilterCondition> startDateEqualTo(
      DateTime value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'startDate',
      value: value,
    ));
  }

  QueryBuilder<Period, Period, QAfterFilterCondition> startDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'startDate',
      value: value,
    ));
  }

  QueryBuilder<Period, Period, QAfterFilterCondition> startDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'startDate',
      value: value,
    ));
  }

  QueryBuilder<Period, Period, QAfterFilterCondition> startDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'startDate',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }
}

extension PeriodQueryWhereSortBy on QueryBuilder<Period, Period, QSortBy> {
  QueryBuilder<Period, Period, QAfterSortBy> sortByClassAverage() {
    return addSortByInternal('classAverage', Sort.asc);
  }

  QueryBuilder<Period, Period, QAfterSortBy> sortByClassAverageDesc() {
    return addSortByInternal('classAverage', Sort.desc);
  }

  QueryBuilder<Period, Period, QAfterSortBy> sortByEndDate() {
    return addSortByInternal('endDate', Sort.asc);
  }

  QueryBuilder<Period, Period, QAfterSortBy> sortByEndDateDesc() {
    return addSortByInternal('endDate', Sort.desc);
  }

  QueryBuilder<Period, Period, QAfterSortBy> sortByEntityId() {
    return addSortByInternal('entityId', Sort.asc);
  }

  QueryBuilder<Period, Period, QAfterSortBy> sortByEntityIdDesc() {
    return addSortByInternal('entityId', Sort.desc);
  }

  QueryBuilder<Period, Period, QAfterSortBy> sortByHeadTeacher() {
    return addSortByInternal('headTeacher', Sort.asc);
  }

  QueryBuilder<Period, Period, QAfterSortBy> sortByHeadTeacherDesc() {
    return addSortByInternal('headTeacher', Sort.desc);
  }

  QueryBuilder<Period, Period, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<Period, Period, QAfterSortBy> sortByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<Period, Period, QAfterSortBy> sortByMaxAverage() {
    return addSortByInternal('maxAverage', Sort.asc);
  }

  QueryBuilder<Period, Period, QAfterSortBy> sortByMaxAverageDesc() {
    return addSortByInternal('maxAverage', Sort.desc);
  }

  QueryBuilder<Period, Period, QAfterSortBy> sortByMinAverage() {
    return addSortByInternal('minAverage', Sort.asc);
  }

  QueryBuilder<Period, Period, QAfterSortBy> sortByMinAverageDesc() {
    return addSortByInternal('minAverage', Sort.desc);
  }

  QueryBuilder<Period, Period, QAfterSortBy> sortByName() {
    return addSortByInternal('name', Sort.asc);
  }

  QueryBuilder<Period, Period, QAfterSortBy> sortByNameDesc() {
    return addSortByInternal('name', Sort.desc);
  }

  QueryBuilder<Period, Period, QAfterSortBy> sortByOverallAverage() {
    return addSortByInternal('overallAverage', Sort.asc);
  }

  QueryBuilder<Period, Period, QAfterSortBy> sortByOverallAverageDesc() {
    return addSortByInternal('overallAverage', Sort.desc);
  }

  QueryBuilder<Period, Period, QAfterSortBy> sortByStartDate() {
    return addSortByInternal('startDate', Sort.asc);
  }

  QueryBuilder<Period, Period, QAfterSortBy> sortByStartDateDesc() {
    return addSortByInternal('startDate', Sort.desc);
  }
}

extension PeriodQueryWhereSortThenBy
    on QueryBuilder<Period, Period, QSortThenBy> {
  QueryBuilder<Period, Period, QAfterSortBy> thenByClassAverage() {
    return addSortByInternal('classAverage', Sort.asc);
  }

  QueryBuilder<Period, Period, QAfterSortBy> thenByClassAverageDesc() {
    return addSortByInternal('classAverage', Sort.desc);
  }

  QueryBuilder<Period, Period, QAfterSortBy> thenByEndDate() {
    return addSortByInternal('endDate', Sort.asc);
  }

  QueryBuilder<Period, Period, QAfterSortBy> thenByEndDateDesc() {
    return addSortByInternal('endDate', Sort.desc);
  }

  QueryBuilder<Period, Period, QAfterSortBy> thenByEntityId() {
    return addSortByInternal('entityId', Sort.asc);
  }

  QueryBuilder<Period, Period, QAfterSortBy> thenByEntityIdDesc() {
    return addSortByInternal('entityId', Sort.desc);
  }

  QueryBuilder<Period, Period, QAfterSortBy> thenByHeadTeacher() {
    return addSortByInternal('headTeacher', Sort.asc);
  }

  QueryBuilder<Period, Period, QAfterSortBy> thenByHeadTeacherDesc() {
    return addSortByInternal('headTeacher', Sort.desc);
  }

  QueryBuilder<Period, Period, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<Period, Period, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<Period, Period, QAfterSortBy> thenByMaxAverage() {
    return addSortByInternal('maxAverage', Sort.asc);
  }

  QueryBuilder<Period, Period, QAfterSortBy> thenByMaxAverageDesc() {
    return addSortByInternal('maxAverage', Sort.desc);
  }

  QueryBuilder<Period, Period, QAfterSortBy> thenByMinAverage() {
    return addSortByInternal('minAverage', Sort.asc);
  }

  QueryBuilder<Period, Period, QAfterSortBy> thenByMinAverageDesc() {
    return addSortByInternal('minAverage', Sort.desc);
  }

  QueryBuilder<Period, Period, QAfterSortBy> thenByName() {
    return addSortByInternal('name', Sort.asc);
  }

  QueryBuilder<Period, Period, QAfterSortBy> thenByNameDesc() {
    return addSortByInternal('name', Sort.desc);
  }

  QueryBuilder<Period, Period, QAfterSortBy> thenByOverallAverage() {
    return addSortByInternal('overallAverage', Sort.asc);
  }

  QueryBuilder<Period, Period, QAfterSortBy> thenByOverallAverageDesc() {
    return addSortByInternal('overallAverage', Sort.desc);
  }

  QueryBuilder<Period, Period, QAfterSortBy> thenByStartDate() {
    return addSortByInternal('startDate', Sort.asc);
  }

  QueryBuilder<Period, Period, QAfterSortBy> thenByStartDateDesc() {
    return addSortByInternal('startDate', Sort.desc);
  }
}

extension PeriodQueryWhereDistinct on QueryBuilder<Period, Period, QDistinct> {
  QueryBuilder<Period, Period, QDistinct> distinctByClassAverage() {
    return addDistinctByInternal('classAverage');
  }

  QueryBuilder<Period, Period, QDistinct> distinctByEndDate() {
    return addDistinctByInternal('endDate');
  }

  QueryBuilder<Period, Period, QDistinct> distinctByEntityId(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('entityId', caseSensitive: caseSensitive);
  }

  QueryBuilder<Period, Period, QDistinct> distinctByHeadTeacher(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('headTeacher', caseSensitive: caseSensitive);
  }

  QueryBuilder<Period, Period, QDistinct> distinctById() {
    return addDistinctByInternal('id');
  }

  QueryBuilder<Period, Period, QDistinct> distinctByMaxAverage() {
    return addDistinctByInternal('maxAverage');
  }

  QueryBuilder<Period, Period, QDistinct> distinctByMinAverage() {
    return addDistinctByInternal('minAverage');
  }

  QueryBuilder<Period, Period, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('name', caseSensitive: caseSensitive);
  }

  QueryBuilder<Period, Period, QDistinct> distinctByOverallAverage() {
    return addDistinctByInternal('overallAverage');
  }

  QueryBuilder<Period, Period, QDistinct> distinctByStartDate() {
    return addDistinctByInternal('startDate');
  }
}

extension PeriodQueryProperty on QueryBuilder<Period, Period, QQueryProperty> {
  QueryBuilder<Period, double, QQueryOperations> classAverageProperty() {
    return addPropertyNameInternal('classAverage');
  }

  QueryBuilder<Period, DateTime, QQueryOperations> endDateProperty() {
    return addPropertyNameInternal('endDate');
  }

  QueryBuilder<Period, String, QQueryOperations> entityIdProperty() {
    return addPropertyNameInternal('entityId');
  }

  QueryBuilder<Period, String, QQueryOperations> headTeacherProperty() {
    return addPropertyNameInternal('headTeacher');
  }

  QueryBuilder<Period, int?, QQueryOperations> idProperty() {
    return addPropertyNameInternal('id');
  }

  QueryBuilder<Period, double, QQueryOperations> maxAverageProperty() {
    return addPropertyNameInternal('maxAverage');
  }

  QueryBuilder<Period, double, QQueryOperations> minAverageProperty() {
    return addPropertyNameInternal('minAverage');
  }

  QueryBuilder<Period, String, QQueryOperations> nameProperty() {
    return addPropertyNameInternal('name');
  }

  QueryBuilder<Period, double, QQueryOperations> overallAverageProperty() {
    return addPropertyNameInternal('overallAverage');
  }

  QueryBuilder<Period, DateTime, QQueryOperations> startDateProperty() {
    return addPropertyNameInternal('startDate');
  }
}

// ignore_for_file: duplicate_ignore, non_constant_identifier_names, invalid_use_of_protected_member

extension GetAppAccountCollection on Isar {
  IsarCollection<AppAccount> get appAccounts {
    return getCollection('AppAccount');
  }
}

final AppAccountSchema = CollectionSchema(
  name: 'AppAccount',
  schema:
      '{"name":"AppAccount","properties":[{"name":"entityId","type":"String"},{"name":"firstName","type":"String"},{"name":"fullName","type":"String"},{"name":"isParent","type":"Byte"},{"name":"lastName","type":"String"}],"indexes":[],"links":[{"name":"accounts","target":"SchoolAccount"}]}',
  adapter: const _AppAccountAdapter(),
  idName: 'id',
  propertyIds: {
    'entityId': 0,
    'firstName': 1,
    'fullName': 2,
    'isParent': 3,
    'lastName': 4
  },
  indexIds: {},
  indexTypes: {},
  linkIds: {'accounts': 0},
  backlinkIds: {},
  linkedCollections: ['SchoolAccount'],
  getId: (obj) => obj.id,
  setId: (obj, id) => obj.id = id,
  getLinks: (obj) => [obj.accounts],
  version: 1,
);

class _AppAccountAdapter extends IsarTypeAdapter<AppAccount> {
  const _AppAccountAdapter();

  @override
  void serialize(IsarCollection<AppAccount> collection, IsarRawObject rawObj,
      AppAccount object, List<int> offsets, AdapterAlloc alloc) {
    var dynamicSize = 0;
    final value0 = object.entityId;
    final _entityId = BinaryWriter.utf8Encoder.convert(value0);
    dynamicSize += _entityId.length;
    final value1 = object.firstName;
    final _firstName = BinaryWriter.utf8Encoder.convert(value1);
    dynamicSize += _firstName.length;
    final value2 = object.fullName;
    final _fullName = BinaryWriter.utf8Encoder.convert(value2);
    dynamicSize += _fullName.length;
    final value3 = object.isParent;
    final _isParent = value3;
    final value4 = object.lastName;
    final _lastName = BinaryWriter.utf8Encoder.convert(value4);
    dynamicSize += _lastName.length;
    final size = dynamicSize + 35;

    rawObj.buffer = alloc(size);
    rawObj.buffer_length = size;
    final buffer = bufAsBytes(rawObj.buffer, size);
    final writer = BinaryWriter(buffer, 35);
    writer.writeBytes(offsets[0], _entityId);
    writer.writeBytes(offsets[1], _firstName);
    writer.writeBytes(offsets[2], _fullName);
    writer.writeBool(offsets[3], _isParent);
    writer.writeBytes(offsets[4], _lastName);
    attachLinks(collection.isar, object);
  }

  @override
  AppAccount deserialize(IsarCollection<AppAccount> collection, int id,
      BinaryReader reader, List<int> offsets) {
    final object = AppAccount(
      entityId: reader.readString(offsets[0]),
      firstName: reader.readString(offsets[1]),
      lastName: reader.readString(offsets[4]),
    );
    object.id = id;
    attachLinks(collection.isar, object);
    return object;
  }

  @override
  P deserializeProperty<P>(
      int id, BinaryReader reader, int propertyIndex, int offset) {
    switch (propertyIndex) {
      case -1:
        return id as P;
      case 0:
        return (reader.readString(offset)) as P;
      case 1:
        return (reader.readString(offset)) as P;
      case 2:
        return (reader.readString(offset)) as P;
      case 3:
        return (reader.readBool(offset)) as P;
      case 4:
        return (reader.readString(offset)) as P;
      default:
        throw 'Illegal propertyIndex';
    }
  }

  void attachLinks(Isar isar, AppAccount object) {
    object.accounts.attach(
      isar.appAccounts,
      isar.getCollection<SchoolAccount>("SchoolAccount"),
      object,
      "accounts",
      false,
    );
  }
}

extension AppAccountQueryWhereSort
    on QueryBuilder<AppAccount, AppAccount, QWhere> {
  QueryBuilder<AppAccount, AppAccount, QAfterWhere> anyId() {
    return addWhereClauseInternal(const WhereClause(indexName: null));
  }
}

extension AppAccountQueryWhere
    on QueryBuilder<AppAccount, AppAccount, QWhereClause> {
  QueryBuilder<AppAccount, AppAccount, QAfterWhereClause> idEqualTo(int? id) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [id],
      includeLower: true,
      upper: [id],
      includeUpper: true,
    ));
  }

  QueryBuilder<AppAccount, AppAccount, QAfterWhereClause> idNotEqualTo(
      int? id) {
    if (whereSortInternal == Sort.asc) {
      return addWhereClauseInternal(WhereClause(
        indexName: null,
        upper: [id],
        includeUpper: false,
      )).addWhereClauseInternal(WhereClause(
        indexName: null,
        lower: [id],
        includeLower: false,
      ));
    } else {
      return addWhereClauseInternal(WhereClause(
        indexName: null,
        lower: [id],
        includeLower: false,
      )).addWhereClauseInternal(WhereClause(
        indexName: null,
        upper: [id],
        includeUpper: false,
      ));
    }
  }

  QueryBuilder<AppAccount, AppAccount, QAfterWhereClause> idGreaterThan(
    int? id, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [id],
      includeLower: include,
    ));
  }

  QueryBuilder<AppAccount, AppAccount, QAfterWhereClause> idLessThan(
    int? id, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      upper: [id],
      includeUpper: include,
    ));
  }

  QueryBuilder<AppAccount, AppAccount, QAfterWhereClause> idBetween(
    int? lowerId,
    int? upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [lowerId],
      includeLower: includeLower,
      upper: [upperId],
      includeUpper: includeUpper,
    ));
  }
}

extension AppAccountQueryFilter
    on QueryBuilder<AppAccount, AppAccount, QFilterCondition> {
  QueryBuilder<AppAccount, AppAccount, QAfterFilterCondition> entityIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'entityId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<AppAccount, AppAccount, QAfterFilterCondition>
      entityIdGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'entityId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<AppAccount, AppAccount, QAfterFilterCondition> entityIdLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'entityId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<AppAccount, AppAccount, QAfterFilterCondition> entityIdBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'entityId',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<AppAccount, AppAccount, QAfterFilterCondition>
      entityIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'entityId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<AppAccount, AppAccount, QAfterFilterCondition> entityIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'entityId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<AppAccount, AppAccount, QAfterFilterCondition> entityIdContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'entityId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<AppAccount, AppAccount, QAfterFilterCondition> entityIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'entityId',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<AppAccount, AppAccount, QAfterFilterCondition> firstNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'firstName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<AppAccount, AppAccount, QAfterFilterCondition>
      firstNameGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'firstName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<AppAccount, AppAccount, QAfterFilterCondition> firstNameLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'firstName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<AppAccount, AppAccount, QAfterFilterCondition> firstNameBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'firstName',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<AppAccount, AppAccount, QAfterFilterCondition>
      firstNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'firstName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<AppAccount, AppAccount, QAfterFilterCondition> firstNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'firstName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<AppAccount, AppAccount, QAfterFilterCondition> firstNameContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'firstName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<AppAccount, AppAccount, QAfterFilterCondition> firstNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'firstName',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<AppAccount, AppAccount, QAfterFilterCondition> fullNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'fullName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<AppAccount, AppAccount, QAfterFilterCondition>
      fullNameGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'fullName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<AppAccount, AppAccount, QAfterFilterCondition> fullNameLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'fullName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<AppAccount, AppAccount, QAfterFilterCondition> fullNameBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'fullName',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<AppAccount, AppAccount, QAfterFilterCondition>
      fullNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'fullName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<AppAccount, AppAccount, QAfterFilterCondition> fullNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'fullName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<AppAccount, AppAccount, QAfterFilterCondition> fullNameContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'fullName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<AppAccount, AppAccount, QAfterFilterCondition> fullNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'fullName',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<AppAccount, AppAccount, QAfterFilterCondition> idIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'id',
      value: null,
    ));
  }

  QueryBuilder<AppAccount, AppAccount, QAfterFilterCondition> idEqualTo(
      int? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<AppAccount, AppAccount, QAfterFilterCondition> idGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<AppAccount, AppAccount, QAfterFilterCondition> idLessThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<AppAccount, AppAccount, QAfterFilterCondition> idBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'id',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<AppAccount, AppAccount, QAfterFilterCondition> isParentEqualTo(
      bool value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'isParent',
      value: value,
    ));
  }

  QueryBuilder<AppAccount, AppAccount, QAfterFilterCondition> lastNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'lastName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<AppAccount, AppAccount, QAfterFilterCondition>
      lastNameGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'lastName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<AppAccount, AppAccount, QAfterFilterCondition> lastNameLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'lastName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<AppAccount, AppAccount, QAfterFilterCondition> lastNameBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'lastName',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<AppAccount, AppAccount, QAfterFilterCondition>
      lastNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'lastName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<AppAccount, AppAccount, QAfterFilterCondition> lastNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'lastName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<AppAccount, AppAccount, QAfterFilterCondition> lastNameContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'lastName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<AppAccount, AppAccount, QAfterFilterCondition> lastNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'lastName',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }
}

extension AppAccountQueryWhereSortBy
    on QueryBuilder<AppAccount, AppAccount, QSortBy> {
  QueryBuilder<AppAccount, AppAccount, QAfterSortBy> sortByEntityId() {
    return addSortByInternal('entityId', Sort.asc);
  }

  QueryBuilder<AppAccount, AppAccount, QAfterSortBy> sortByEntityIdDesc() {
    return addSortByInternal('entityId', Sort.desc);
  }

  QueryBuilder<AppAccount, AppAccount, QAfterSortBy> sortByFirstName() {
    return addSortByInternal('firstName', Sort.asc);
  }

  QueryBuilder<AppAccount, AppAccount, QAfterSortBy> sortByFirstNameDesc() {
    return addSortByInternal('firstName', Sort.desc);
  }

  QueryBuilder<AppAccount, AppAccount, QAfterSortBy> sortByFullName() {
    return addSortByInternal('fullName', Sort.asc);
  }

  QueryBuilder<AppAccount, AppAccount, QAfterSortBy> sortByFullNameDesc() {
    return addSortByInternal('fullName', Sort.desc);
  }

  QueryBuilder<AppAccount, AppAccount, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<AppAccount, AppAccount, QAfterSortBy> sortByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<AppAccount, AppAccount, QAfterSortBy> sortByIsParent() {
    return addSortByInternal('isParent', Sort.asc);
  }

  QueryBuilder<AppAccount, AppAccount, QAfterSortBy> sortByIsParentDesc() {
    return addSortByInternal('isParent', Sort.desc);
  }

  QueryBuilder<AppAccount, AppAccount, QAfterSortBy> sortByLastName() {
    return addSortByInternal('lastName', Sort.asc);
  }

  QueryBuilder<AppAccount, AppAccount, QAfterSortBy> sortByLastNameDesc() {
    return addSortByInternal('lastName', Sort.desc);
  }
}

extension AppAccountQueryWhereSortThenBy
    on QueryBuilder<AppAccount, AppAccount, QSortThenBy> {
  QueryBuilder<AppAccount, AppAccount, QAfterSortBy> thenByEntityId() {
    return addSortByInternal('entityId', Sort.asc);
  }

  QueryBuilder<AppAccount, AppAccount, QAfterSortBy> thenByEntityIdDesc() {
    return addSortByInternal('entityId', Sort.desc);
  }

  QueryBuilder<AppAccount, AppAccount, QAfterSortBy> thenByFirstName() {
    return addSortByInternal('firstName', Sort.asc);
  }

  QueryBuilder<AppAccount, AppAccount, QAfterSortBy> thenByFirstNameDesc() {
    return addSortByInternal('firstName', Sort.desc);
  }

  QueryBuilder<AppAccount, AppAccount, QAfterSortBy> thenByFullName() {
    return addSortByInternal('fullName', Sort.asc);
  }

  QueryBuilder<AppAccount, AppAccount, QAfterSortBy> thenByFullNameDesc() {
    return addSortByInternal('fullName', Sort.desc);
  }

  QueryBuilder<AppAccount, AppAccount, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<AppAccount, AppAccount, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<AppAccount, AppAccount, QAfterSortBy> thenByIsParent() {
    return addSortByInternal('isParent', Sort.asc);
  }

  QueryBuilder<AppAccount, AppAccount, QAfterSortBy> thenByIsParentDesc() {
    return addSortByInternal('isParent', Sort.desc);
  }

  QueryBuilder<AppAccount, AppAccount, QAfterSortBy> thenByLastName() {
    return addSortByInternal('lastName', Sort.asc);
  }

  QueryBuilder<AppAccount, AppAccount, QAfterSortBy> thenByLastNameDesc() {
    return addSortByInternal('lastName', Sort.desc);
  }
}

extension AppAccountQueryWhereDistinct
    on QueryBuilder<AppAccount, AppAccount, QDistinct> {
  QueryBuilder<AppAccount, AppAccount, QDistinct> distinctByEntityId(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('entityId', caseSensitive: caseSensitive);
  }

  QueryBuilder<AppAccount, AppAccount, QDistinct> distinctByFirstName(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('firstName', caseSensitive: caseSensitive);
  }

  QueryBuilder<AppAccount, AppAccount, QDistinct> distinctByFullName(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('fullName', caseSensitive: caseSensitive);
  }

  QueryBuilder<AppAccount, AppAccount, QDistinct> distinctById() {
    return addDistinctByInternal('id');
  }

  QueryBuilder<AppAccount, AppAccount, QDistinct> distinctByIsParent() {
    return addDistinctByInternal('isParent');
  }

  QueryBuilder<AppAccount, AppAccount, QDistinct> distinctByLastName(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('lastName', caseSensitive: caseSensitive);
  }
}

extension AppAccountQueryProperty
    on QueryBuilder<AppAccount, AppAccount, QQueryProperty> {
  QueryBuilder<AppAccount, String, QQueryOperations> entityIdProperty() {
    return addPropertyNameInternal('entityId');
  }

  QueryBuilder<AppAccount, String, QQueryOperations> firstNameProperty() {
    return addPropertyNameInternal('firstName');
  }

  QueryBuilder<AppAccount, String, QQueryOperations> fullNameProperty() {
    return addPropertyNameInternal('fullName');
  }

  QueryBuilder<AppAccount, int?, QQueryOperations> idProperty() {
    return addPropertyNameInternal('id');
  }

  QueryBuilder<AppAccount, bool, QQueryOperations> isParentProperty() {
    return addPropertyNameInternal('isParent');
  }

  QueryBuilder<AppAccount, String, QQueryOperations> lastNameProperty() {
    return addPropertyNameInternal('lastName');
  }
}

// ignore_for_file: duplicate_ignore, non_constant_identifier_names, invalid_use_of_protected_member

extension GetDocumentCollection on Isar {
  IsarCollection<Document> get documents {
    return getCollection('Document');
  }
}

final DocumentSchema = CollectionSchema(
  name: 'Document',
  schema:
      '{"name":"Document","properties":[{"name":"entityId","type":"String"},{"name":"fileName","type":"String"},{"name":"name","type":"String"},{"name":"saved","type":"Byte"},{"name":"type","type":"String"}],"indexes":[],"links":[]}',
  adapter: const _DocumentAdapter(),
  idName: 'id',
  propertyIds: {'entityId': 0, 'fileName': 1, 'name': 2, 'saved': 3, 'type': 4},
  indexIds: {},
  indexTypes: {},
  linkIds: {},
  backlinkIds: {},
  linkedCollections: [],
  getId: (obj) => obj.id,
  setId: (obj, id) => obj.id = id,
  getLinks: (obj) => [],
  version: 1,
);

class _DocumentAdapter extends IsarTypeAdapter<Document> {
  const _DocumentAdapter();

  @override
  void serialize(IsarCollection<Document> collection, IsarRawObject rawObj,
      Document object, List<int> offsets, AdapterAlloc alloc) {
    var dynamicSize = 0;
    final value0 = object.entityId;
    final _entityId = BinaryWriter.utf8Encoder.convert(value0);
    dynamicSize += _entityId.length;
    final value1 = object.fileName;
    final _fileName = BinaryWriter.utf8Encoder.convert(value1);
    dynamicSize += _fileName.length;
    final value2 = object.name;
    final _name = BinaryWriter.utf8Encoder.convert(value2);
    dynamicSize += _name.length;
    final value3 = object.saved;
    final _saved = value3;
    final value4 = object.type;
    final _type = BinaryWriter.utf8Encoder.convert(value4);
    dynamicSize += _type.length;
    final size = dynamicSize + 35;

    rawObj.buffer = alloc(size);
    rawObj.buffer_length = size;
    final buffer = bufAsBytes(rawObj.buffer, size);
    final writer = BinaryWriter(buffer, 35);
    writer.writeBytes(offsets[0], _entityId);
    writer.writeBytes(offsets[1], _fileName);
    writer.writeBytes(offsets[2], _name);
    writer.writeBool(offsets[3], _saved);
    writer.writeBytes(offsets[4], _type);
  }

  @override
  Document deserialize(IsarCollection<Document> collection, int id,
      BinaryReader reader, List<int> offsets) {
    final object = Document(
      entityId: reader.readString(offsets[0]),
      name: reader.readString(offsets[2]),
      saved: reader.readBool(offsets[3]),
      type: reader.readString(offsets[4]),
    );
    object.id = id;
    return object;
  }

  @override
  P deserializeProperty<P>(
      int id, BinaryReader reader, int propertyIndex, int offset) {
    switch (propertyIndex) {
      case -1:
        return id as P;
      case 0:
        return (reader.readString(offset)) as P;
      case 1:
        return (reader.readString(offset)) as P;
      case 2:
        return (reader.readString(offset)) as P;
      case 3:
        return (reader.readBool(offset)) as P;
      case 4:
        return (reader.readString(offset)) as P;
      default:
        throw 'Illegal propertyIndex';
    }
  }
}

extension DocumentQueryWhereSort on QueryBuilder<Document, Document, QWhere> {
  QueryBuilder<Document, Document, QAfterWhere> anyId() {
    return addWhereClauseInternal(const WhereClause(indexName: null));
  }
}

extension DocumentQueryWhere on QueryBuilder<Document, Document, QWhereClause> {
  QueryBuilder<Document, Document, QAfterWhereClause> idEqualTo(int? id) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [id],
      includeLower: true,
      upper: [id],
      includeUpper: true,
    ));
  }

  QueryBuilder<Document, Document, QAfterWhereClause> idNotEqualTo(int? id) {
    if (whereSortInternal == Sort.asc) {
      return addWhereClauseInternal(WhereClause(
        indexName: null,
        upper: [id],
        includeUpper: false,
      )).addWhereClauseInternal(WhereClause(
        indexName: null,
        lower: [id],
        includeLower: false,
      ));
    } else {
      return addWhereClauseInternal(WhereClause(
        indexName: null,
        lower: [id],
        includeLower: false,
      )).addWhereClauseInternal(WhereClause(
        indexName: null,
        upper: [id],
        includeUpper: false,
      ));
    }
  }

  QueryBuilder<Document, Document, QAfterWhereClause> idGreaterThan(
    int? id, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [id],
      includeLower: include,
    ));
  }

  QueryBuilder<Document, Document, QAfterWhereClause> idLessThan(
    int? id, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      upper: [id],
      includeUpper: include,
    ));
  }

  QueryBuilder<Document, Document, QAfterWhereClause> idBetween(
    int? lowerId,
    int? upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [lowerId],
      includeLower: includeLower,
      upper: [upperId],
      includeUpper: includeUpper,
    ));
  }
}

extension DocumentQueryFilter
    on QueryBuilder<Document, Document, QFilterCondition> {
  QueryBuilder<Document, Document, QAfterFilterCondition> entityIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'entityId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> entityIdGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'entityId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> entityIdLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'entityId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> entityIdBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'entityId',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> entityIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'entityId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> entityIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'entityId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> entityIdContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'entityId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> entityIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'entityId',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> fileNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'fileName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> fileNameGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'fileName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> fileNameLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'fileName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> fileNameBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'fileName',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> fileNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'fileName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> fileNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'fileName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> fileNameContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'fileName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> fileNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'fileName',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> idIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'id',
      value: null,
    ));
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> idEqualTo(
      int? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> idGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> idLessThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> idBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'id',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> nameLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'name',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'name',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> savedEqualTo(
      bool value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'saved',
      value: value,
    ));
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> typeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'type',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> typeGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'type',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> typeLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'type',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> typeBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'type',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> typeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'type',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> typeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'type',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> typeContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'type',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> typeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'type',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }
}

extension DocumentQueryWhereSortBy
    on QueryBuilder<Document, Document, QSortBy> {
  QueryBuilder<Document, Document, QAfterSortBy> sortByEntityId() {
    return addSortByInternal('entityId', Sort.asc);
  }

  QueryBuilder<Document, Document, QAfterSortBy> sortByEntityIdDesc() {
    return addSortByInternal('entityId', Sort.desc);
  }

  QueryBuilder<Document, Document, QAfterSortBy> sortByFileName() {
    return addSortByInternal('fileName', Sort.asc);
  }

  QueryBuilder<Document, Document, QAfterSortBy> sortByFileNameDesc() {
    return addSortByInternal('fileName', Sort.desc);
  }

  QueryBuilder<Document, Document, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<Document, Document, QAfterSortBy> sortByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<Document, Document, QAfterSortBy> sortByName() {
    return addSortByInternal('name', Sort.asc);
  }

  QueryBuilder<Document, Document, QAfterSortBy> sortByNameDesc() {
    return addSortByInternal('name', Sort.desc);
  }

  QueryBuilder<Document, Document, QAfterSortBy> sortBySaved() {
    return addSortByInternal('saved', Sort.asc);
  }

  QueryBuilder<Document, Document, QAfterSortBy> sortBySavedDesc() {
    return addSortByInternal('saved', Sort.desc);
  }

  QueryBuilder<Document, Document, QAfterSortBy> sortByType() {
    return addSortByInternal('type', Sort.asc);
  }

  QueryBuilder<Document, Document, QAfterSortBy> sortByTypeDesc() {
    return addSortByInternal('type', Sort.desc);
  }
}

extension DocumentQueryWhereSortThenBy
    on QueryBuilder<Document, Document, QSortThenBy> {
  QueryBuilder<Document, Document, QAfterSortBy> thenByEntityId() {
    return addSortByInternal('entityId', Sort.asc);
  }

  QueryBuilder<Document, Document, QAfterSortBy> thenByEntityIdDesc() {
    return addSortByInternal('entityId', Sort.desc);
  }

  QueryBuilder<Document, Document, QAfterSortBy> thenByFileName() {
    return addSortByInternal('fileName', Sort.asc);
  }

  QueryBuilder<Document, Document, QAfterSortBy> thenByFileNameDesc() {
    return addSortByInternal('fileName', Sort.desc);
  }

  QueryBuilder<Document, Document, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<Document, Document, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<Document, Document, QAfterSortBy> thenByName() {
    return addSortByInternal('name', Sort.asc);
  }

  QueryBuilder<Document, Document, QAfterSortBy> thenByNameDesc() {
    return addSortByInternal('name', Sort.desc);
  }

  QueryBuilder<Document, Document, QAfterSortBy> thenBySaved() {
    return addSortByInternal('saved', Sort.asc);
  }

  QueryBuilder<Document, Document, QAfterSortBy> thenBySavedDesc() {
    return addSortByInternal('saved', Sort.desc);
  }

  QueryBuilder<Document, Document, QAfterSortBy> thenByType() {
    return addSortByInternal('type', Sort.asc);
  }

  QueryBuilder<Document, Document, QAfterSortBy> thenByTypeDesc() {
    return addSortByInternal('type', Sort.desc);
  }
}

extension DocumentQueryWhereDistinct
    on QueryBuilder<Document, Document, QDistinct> {
  QueryBuilder<Document, Document, QDistinct> distinctByEntityId(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('entityId', caseSensitive: caseSensitive);
  }

  QueryBuilder<Document, Document, QDistinct> distinctByFileName(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('fileName', caseSensitive: caseSensitive);
  }

  QueryBuilder<Document, Document, QDistinct> distinctById() {
    return addDistinctByInternal('id');
  }

  QueryBuilder<Document, Document, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('name', caseSensitive: caseSensitive);
  }

  QueryBuilder<Document, Document, QDistinct> distinctBySaved() {
    return addDistinctByInternal('saved');
  }

  QueryBuilder<Document, Document, QDistinct> distinctByType(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('type', caseSensitive: caseSensitive);
  }
}

extension DocumentQueryProperty
    on QueryBuilder<Document, Document, QQueryProperty> {
  QueryBuilder<Document, String, QQueryOperations> entityIdProperty() {
    return addPropertyNameInternal('entityId');
  }

  QueryBuilder<Document, String, QQueryOperations> fileNameProperty() {
    return addPropertyNameInternal('fileName');
  }

  QueryBuilder<Document, int?, QQueryOperations> idProperty() {
    return addPropertyNameInternal('id');
  }

  QueryBuilder<Document, String, QQueryOperations> nameProperty() {
    return addPropertyNameInternal('name');
  }

  QueryBuilder<Document, bool, QQueryOperations> savedProperty() {
    return addPropertyNameInternal('saved');
  }

  QueryBuilder<Document, String, QQueryOperations> typeProperty() {
    return addPropertyNameInternal('type');
  }
}

// ignore_for_file: duplicate_ignore, non_constant_identifier_names, invalid_use_of_protected_member

extension GetEmailCollection on Isar {
  IsarCollection<Email> get emails {
    return getCollection('Email');
  }
}

final EmailSchema = CollectionSchema(
  name: 'Email',
  schema:
      '{"name":"Email","properties":[{"name":"content","type":"String"},{"name":"date","type":"Long"},{"name":"entityId","type":"String"},{"name":"favorite","type":"Byte"},{"name":"read","type":"Byte"},{"name":"subject","type":"String"}],"indexes":[],"links":[{"name":"documents","target":"Document"},{"name":"from","target":"Recipient"},{"name":"to","target":"Recipient"}]}',
  adapter: const _EmailAdapter(),
  idName: 'id',
  propertyIds: {
    'content': 0,
    'date': 1,
    'entityId': 2,
    'favorite': 3,
    'read': 4,
    'subject': 5
  },
  indexIds: {},
  indexTypes: {},
  linkIds: {'documents': 0, 'from': 1, 'to': 2},
  backlinkIds: {},
  linkedCollections: ['Document', 'Recipient'],
  getId: (obj) => obj.id,
  setId: (obj, id) => obj.id = id,
  getLinks: (obj) => [obj.documents, obj.from, obj.to],
  version: 1,
);

class _EmailAdapter extends IsarTypeAdapter<Email> {
  const _EmailAdapter();

  @override
  void serialize(IsarCollection<Email> collection, IsarRawObject rawObj,
      Email object, List<int> offsets, AdapterAlloc alloc) {
    var dynamicSize = 0;
    final value0 = object.content;
    IsarUint8List? _content;
    if (value0 != null) {
      _content = BinaryWriter.utf8Encoder.convert(value0);
    }
    dynamicSize += _content?.length ?? 0;
    final value1 = object.date;
    final _date = value1;
    final value2 = object.entityId;
    final _entityId = BinaryWriter.utf8Encoder.convert(value2);
    dynamicSize += _entityId.length;
    final value3 = object.favorite;
    final _favorite = value3;
    final value4 = object.read;
    final _read = value4;
    final value5 = object.subject;
    final _subject = BinaryWriter.utf8Encoder.convert(value5);
    dynamicSize += _subject.length;
    final size = dynamicSize + 36;

    rawObj.buffer = alloc(size);
    rawObj.buffer_length = size;
    final buffer = bufAsBytes(rawObj.buffer, size);
    final writer = BinaryWriter(buffer, 36);
    writer.writeBytes(offsets[0], _content);
    writer.writeDateTime(offsets[1], _date);
    writer.writeBytes(offsets[2], _entityId);
    writer.writeBool(offsets[3], _favorite);
    writer.writeBool(offsets[4], _read);
    writer.writeBytes(offsets[5], _subject);
    attachLinks(collection.isar, object);
  }

  @override
  Email deserialize(IsarCollection<Email> collection, int id,
      BinaryReader reader, List<int> offsets) {
    final object = Email(
      content: reader.readStringOrNull(offsets[0]),
      date: reader.readDateTime(offsets[1]),
      entityId: reader.readString(offsets[2]),
      read: reader.readBool(offsets[4]),
      subject: reader.readString(offsets[5]),
    );
    object.favorite = reader.readBool(offsets[3]);
    object.id = id;
    attachLinks(collection.isar, object);
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
        return (reader.readDateTime(offset)) as P;
      case 2:
        return (reader.readString(offset)) as P;
      case 3:
        return (reader.readBool(offset)) as P;
      case 4:
        return (reader.readBool(offset)) as P;
      case 5:
        return (reader.readString(offset)) as P;
      default:
        throw 'Illegal propertyIndex';
    }
  }

  void attachLinks(Isar isar, Email object) {
    object.documents.attach(
      isar.emails,
      isar.getCollection<Document>("Document"),
      object,
      "documents",
      false,
    );
    object.from.attach(
      isar.emails,
      isar.getCollection<Recipient>("Recipient"),
      object,
      "from",
      false,
    );
    object.to.attach(
      isar.emails,
      isar.getCollection<Recipient>("Recipient"),
      object,
      "to",
      false,
    );
  }
}

extension EmailQueryWhereSort on QueryBuilder<Email, Email, QWhere> {
  QueryBuilder<Email, Email, QAfterWhere> anyId() {
    return addWhereClauseInternal(const WhereClause(indexName: null));
  }
}

extension EmailQueryWhere on QueryBuilder<Email, Email, QWhereClause> {
  QueryBuilder<Email, Email, QAfterWhereClause> idEqualTo(int? id) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [id],
      includeLower: true,
      upper: [id],
      includeUpper: true,
    ));
  }

  QueryBuilder<Email, Email, QAfterWhereClause> idNotEqualTo(int? id) {
    if (whereSortInternal == Sort.asc) {
      return addWhereClauseInternal(WhereClause(
        indexName: null,
        upper: [id],
        includeUpper: false,
      )).addWhereClauseInternal(WhereClause(
        indexName: null,
        lower: [id],
        includeLower: false,
      ));
    } else {
      return addWhereClauseInternal(WhereClause(
        indexName: null,
        lower: [id],
        includeLower: false,
      )).addWhereClauseInternal(WhereClause(
        indexName: null,
        upper: [id],
        includeUpper: false,
      ));
    }
  }

  QueryBuilder<Email, Email, QAfterWhereClause> idGreaterThan(
    int? id, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [id],
      includeLower: include,
    ));
  }

  QueryBuilder<Email, Email, QAfterWhereClause> idLessThan(
    int? id, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      upper: [id],
      includeUpper: include,
    ));
  }

  QueryBuilder<Email, Email, QAfterWhereClause> idBetween(
    int? lowerId,
    int? upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [lowerId],
      includeLower: includeLower,
      upper: [upperId],
      includeUpper: includeUpper,
    ));
  }
}

extension EmailQueryFilter on QueryBuilder<Email, Email, QFilterCondition> {
  QueryBuilder<Email, Email, QAfterFilterCondition> contentIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'content',
      value: null,
    ));
  }

  QueryBuilder<Email, Email, QAfterFilterCondition> contentEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'content',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Email, Email, QAfterFilterCondition> contentGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'content',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Email, Email, QAfterFilterCondition> contentLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'content',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Email, Email, QAfterFilterCondition> contentBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'content',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Email, Email, QAfterFilterCondition> contentStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'content',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Email, Email, QAfterFilterCondition> contentEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'content',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Email, Email, QAfterFilterCondition> contentContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'content',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Email, Email, QAfterFilterCondition> contentMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'content',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Email, Email, QAfterFilterCondition> dateEqualTo(
      DateTime value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'date',
      value: value,
    ));
  }

  QueryBuilder<Email, Email, QAfterFilterCondition> dateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'date',
      value: value,
    ));
  }

  QueryBuilder<Email, Email, QAfterFilterCondition> dateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'date',
      value: value,
    ));
  }

  QueryBuilder<Email, Email, QAfterFilterCondition> dateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'date',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Email, Email, QAfterFilterCondition> entityIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'entityId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Email, Email, QAfterFilterCondition> entityIdGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'entityId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Email, Email, QAfterFilterCondition> entityIdLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'entityId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Email, Email, QAfterFilterCondition> entityIdBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'entityId',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Email, Email, QAfterFilterCondition> entityIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'entityId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Email, Email, QAfterFilterCondition> entityIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'entityId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Email, Email, QAfterFilterCondition> entityIdContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'entityId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Email, Email, QAfterFilterCondition> entityIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'entityId',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Email, Email, QAfterFilterCondition> favoriteEqualTo(
      bool value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'favorite',
      value: value,
    ));
  }

  QueryBuilder<Email, Email, QAfterFilterCondition> idIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'id',
      value: null,
    ));
  }

  QueryBuilder<Email, Email, QAfterFilterCondition> idEqualTo(int? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Email, Email, QAfterFilterCondition> idGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Email, Email, QAfterFilterCondition> idLessThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Email, Email, QAfterFilterCondition> idBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'id',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Email, Email, QAfterFilterCondition> readEqualTo(bool value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'read',
      value: value,
    ));
  }

  QueryBuilder<Email, Email, QAfterFilterCondition> subjectEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'subject',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Email, Email, QAfterFilterCondition> subjectGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'subject',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Email, Email, QAfterFilterCondition> subjectLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'subject',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Email, Email, QAfterFilterCondition> subjectBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'subject',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Email, Email, QAfterFilterCondition> subjectStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'subject',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Email, Email, QAfterFilterCondition> subjectEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'subject',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Email, Email, QAfterFilterCondition> subjectContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'subject',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Email, Email, QAfterFilterCondition> subjectMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'subject',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }
}

extension EmailQueryWhereSortBy on QueryBuilder<Email, Email, QSortBy> {
  QueryBuilder<Email, Email, QAfterSortBy> sortByContent() {
    return addSortByInternal('content', Sort.asc);
  }

  QueryBuilder<Email, Email, QAfterSortBy> sortByContentDesc() {
    return addSortByInternal('content', Sort.desc);
  }

  QueryBuilder<Email, Email, QAfterSortBy> sortByDate() {
    return addSortByInternal('date', Sort.asc);
  }

  QueryBuilder<Email, Email, QAfterSortBy> sortByDateDesc() {
    return addSortByInternal('date', Sort.desc);
  }

  QueryBuilder<Email, Email, QAfterSortBy> sortByEntityId() {
    return addSortByInternal('entityId', Sort.asc);
  }

  QueryBuilder<Email, Email, QAfterSortBy> sortByEntityIdDesc() {
    return addSortByInternal('entityId', Sort.desc);
  }

  QueryBuilder<Email, Email, QAfterSortBy> sortByFavorite() {
    return addSortByInternal('favorite', Sort.asc);
  }

  QueryBuilder<Email, Email, QAfterSortBy> sortByFavoriteDesc() {
    return addSortByInternal('favorite', Sort.desc);
  }

  QueryBuilder<Email, Email, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<Email, Email, QAfterSortBy> sortByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<Email, Email, QAfterSortBy> sortByRead() {
    return addSortByInternal('read', Sort.asc);
  }

  QueryBuilder<Email, Email, QAfterSortBy> sortByReadDesc() {
    return addSortByInternal('read', Sort.desc);
  }

  QueryBuilder<Email, Email, QAfterSortBy> sortBySubject() {
    return addSortByInternal('subject', Sort.asc);
  }

  QueryBuilder<Email, Email, QAfterSortBy> sortBySubjectDesc() {
    return addSortByInternal('subject', Sort.desc);
  }
}

extension EmailQueryWhereSortThenBy on QueryBuilder<Email, Email, QSortThenBy> {
  QueryBuilder<Email, Email, QAfterSortBy> thenByContent() {
    return addSortByInternal('content', Sort.asc);
  }

  QueryBuilder<Email, Email, QAfterSortBy> thenByContentDesc() {
    return addSortByInternal('content', Sort.desc);
  }

  QueryBuilder<Email, Email, QAfterSortBy> thenByDate() {
    return addSortByInternal('date', Sort.asc);
  }

  QueryBuilder<Email, Email, QAfterSortBy> thenByDateDesc() {
    return addSortByInternal('date', Sort.desc);
  }

  QueryBuilder<Email, Email, QAfterSortBy> thenByEntityId() {
    return addSortByInternal('entityId', Sort.asc);
  }

  QueryBuilder<Email, Email, QAfterSortBy> thenByEntityIdDesc() {
    return addSortByInternal('entityId', Sort.desc);
  }

  QueryBuilder<Email, Email, QAfterSortBy> thenByFavorite() {
    return addSortByInternal('favorite', Sort.asc);
  }

  QueryBuilder<Email, Email, QAfterSortBy> thenByFavoriteDesc() {
    return addSortByInternal('favorite', Sort.desc);
  }

  QueryBuilder<Email, Email, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<Email, Email, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<Email, Email, QAfterSortBy> thenByRead() {
    return addSortByInternal('read', Sort.asc);
  }

  QueryBuilder<Email, Email, QAfterSortBy> thenByReadDesc() {
    return addSortByInternal('read', Sort.desc);
  }

  QueryBuilder<Email, Email, QAfterSortBy> thenBySubject() {
    return addSortByInternal('subject', Sort.asc);
  }

  QueryBuilder<Email, Email, QAfterSortBy> thenBySubjectDesc() {
    return addSortByInternal('subject', Sort.desc);
  }
}

extension EmailQueryWhereDistinct on QueryBuilder<Email, Email, QDistinct> {
  QueryBuilder<Email, Email, QDistinct> distinctByContent(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('content', caseSensitive: caseSensitive);
  }

  QueryBuilder<Email, Email, QDistinct> distinctByDate() {
    return addDistinctByInternal('date');
  }

  QueryBuilder<Email, Email, QDistinct> distinctByEntityId(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('entityId', caseSensitive: caseSensitive);
  }

  QueryBuilder<Email, Email, QDistinct> distinctByFavorite() {
    return addDistinctByInternal('favorite');
  }

  QueryBuilder<Email, Email, QDistinct> distinctById() {
    return addDistinctByInternal('id');
  }

  QueryBuilder<Email, Email, QDistinct> distinctByRead() {
    return addDistinctByInternal('read');
  }

  QueryBuilder<Email, Email, QDistinct> distinctBySubject(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('subject', caseSensitive: caseSensitive);
  }
}

extension EmailQueryProperty on QueryBuilder<Email, Email, QQueryProperty> {
  QueryBuilder<Email, String?, QQueryOperations> contentProperty() {
    return addPropertyNameInternal('content');
  }

  QueryBuilder<Email, DateTime, QQueryOperations> dateProperty() {
    return addPropertyNameInternal('date');
  }

  QueryBuilder<Email, String, QQueryOperations> entityIdProperty() {
    return addPropertyNameInternal('entityId');
  }

  QueryBuilder<Email, bool, QQueryOperations> favoriteProperty() {
    return addPropertyNameInternal('favorite');
  }

  QueryBuilder<Email, int?, QQueryOperations> idProperty() {
    return addPropertyNameInternal('id');
  }

  QueryBuilder<Email, bool, QQueryOperations> readProperty() {
    return addPropertyNameInternal('read');
  }

  QueryBuilder<Email, String, QQueryOperations> subjectProperty() {
    return addPropertyNameInternal('subject');
  }
}

// ignore_for_file: duplicate_ignore, non_constant_identifier_names, invalid_use_of_protected_member

extension GetHomeworkCollection on Isar {
  IsarCollection<Homework> get homeworks {
    return getCollection('Homework');
  }
}

final HomeworkSchema = CollectionSchema(
  name: 'Homework',
  schema:
      '{"name":"Homework","properties":[{"name":"assessment","type":"Byte"},{"name":"content","type":"String"},{"name":"date","type":"Long"},{"name":"done","type":"Byte"},{"name":"due","type":"Byte"},{"name":"entityId","type":"String"},{"name":"entryDate","type":"Long"},{"name":"pinned","type":"Byte"}],"indexes":[],"links":[{"name":"documents","target":"Document"},{"name":"subject","target":"Subject"}]}',
  adapter: const _HomeworkAdapter(),
  idName: 'id',
  propertyIds: {
    'assessment': 0,
    'content': 1,
    'date': 2,
    'done': 3,
    'due': 4,
    'entityId': 5,
    'entryDate': 6,
    'pinned': 7
  },
  indexIds: {},
  indexTypes: {},
  linkIds: {'documents': 0, 'subject': 1},
  backlinkIds: {},
  linkedCollections: ['Document', 'Subject'],
  getId: (obj) => obj.id,
  setId: (obj, id) => obj.id = id,
  getLinks: (obj) => [obj.documents, obj.subject],
  version: 1,
);

class _HomeworkAdapter extends IsarTypeAdapter<Homework> {
  const _HomeworkAdapter();

  @override
  void serialize(IsarCollection<Homework> collection, IsarRawObject rawObj,
      Homework object, List<int> offsets, AdapterAlloc alloc) {
    var dynamicSize = 0;
    final value0 = object.assessment;
    final _assessment = value0;
    final value1 = object.content;
    IsarUint8List? _content;
    if (value1 != null) {
      _content = BinaryWriter.utf8Encoder.convert(value1);
    }
    dynamicSize += _content?.length ?? 0;
    final value2 = object.date;
    final _date = value2;
    final value3 = object.done;
    final _done = value3;
    final value4 = object.due;
    final _due = value4;
    final value5 = object.entityId;
    final _entityId = BinaryWriter.utf8Encoder.convert(value5);
    dynamicSize += _entityId.length;
    final value6 = object.entryDate;
    final _entryDate = value6;
    final value7 = object.pinned;
    final _pinned = value7;
    final size = dynamicSize + 38;

    rawObj.buffer = alloc(size);
    rawObj.buffer_length = size;
    final buffer = bufAsBytes(rawObj.buffer, size);
    final writer = BinaryWriter(buffer, 38);
    writer.writeBool(offsets[0], _assessment);
    writer.writeBytes(offsets[1], _content);
    writer.writeDateTime(offsets[2], _date);
    writer.writeBool(offsets[3], _done);
    writer.writeBool(offsets[4], _due);
    writer.writeBytes(offsets[5], _entityId);
    writer.writeDateTime(offsets[6], _entryDate);
    writer.writeBool(offsets[7], _pinned);
    attachLinks(collection.isar, object);
  }

  @override
  Homework deserialize(IsarCollection<Homework> collection, int id,
      BinaryReader reader, List<int> offsets) {
    final object = Homework(
      assessment: reader.readBool(offsets[0]),
      content: reader.readStringOrNull(offsets[1]),
      date: reader.readDateTime(offsets[2]),
      done: reader.readBool(offsets[3]),
      due: reader.readBool(offsets[4]),
      entityId: reader.readString(offsets[5]),
      entryDate: reader.readDateTime(offsets[6]),
      pinned: reader.readBool(offsets[7]),
    );
    object.id = id;
    attachLinks(collection.isar, object);
    return object;
  }

  @override
  P deserializeProperty<P>(
      int id, BinaryReader reader, int propertyIndex, int offset) {
    switch (propertyIndex) {
      case -1:
        return id as P;
      case 0:
        return (reader.readBool(offset)) as P;
      case 1:
        return (reader.readStringOrNull(offset)) as P;
      case 2:
        return (reader.readDateTime(offset)) as P;
      case 3:
        return (reader.readBool(offset)) as P;
      case 4:
        return (reader.readBool(offset)) as P;
      case 5:
        return (reader.readString(offset)) as P;
      case 6:
        return (reader.readDateTime(offset)) as P;
      case 7:
        return (reader.readBool(offset)) as P;
      default:
        throw 'Illegal propertyIndex';
    }
  }

  void attachLinks(Isar isar, Homework object) {
    object.documents.attach(
      isar.homeworks,
      isar.getCollection<Document>("Document"),
      object,
      "documents",
      false,
    );
    object.subject.attach(
      isar.homeworks,
      isar.getCollection<Subject>("Subject"),
      object,
      "subject",
      false,
    );
  }
}

extension HomeworkQueryWhereSort on QueryBuilder<Homework, Homework, QWhere> {
  QueryBuilder<Homework, Homework, QAfterWhere> anyId() {
    return addWhereClauseInternal(const WhereClause(indexName: null));
  }
}

extension HomeworkQueryWhere on QueryBuilder<Homework, Homework, QWhereClause> {
  QueryBuilder<Homework, Homework, QAfterWhereClause> idEqualTo(int? id) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [id],
      includeLower: true,
      upper: [id],
      includeUpper: true,
    ));
  }

  QueryBuilder<Homework, Homework, QAfterWhereClause> idNotEqualTo(int? id) {
    if (whereSortInternal == Sort.asc) {
      return addWhereClauseInternal(WhereClause(
        indexName: null,
        upper: [id],
        includeUpper: false,
      )).addWhereClauseInternal(WhereClause(
        indexName: null,
        lower: [id],
        includeLower: false,
      ));
    } else {
      return addWhereClauseInternal(WhereClause(
        indexName: null,
        lower: [id],
        includeLower: false,
      )).addWhereClauseInternal(WhereClause(
        indexName: null,
        upper: [id],
        includeUpper: false,
      ));
    }
  }

  QueryBuilder<Homework, Homework, QAfterWhereClause> idGreaterThan(
    int? id, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [id],
      includeLower: include,
    ));
  }

  QueryBuilder<Homework, Homework, QAfterWhereClause> idLessThan(
    int? id, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      upper: [id],
      includeUpper: include,
    ));
  }

  QueryBuilder<Homework, Homework, QAfterWhereClause> idBetween(
    int? lowerId,
    int? upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [lowerId],
      includeLower: includeLower,
      upper: [upperId],
      includeUpper: includeUpper,
    ));
  }
}

extension HomeworkQueryFilter
    on QueryBuilder<Homework, Homework, QFilterCondition> {
  QueryBuilder<Homework, Homework, QAfterFilterCondition> assessmentEqualTo(
      bool value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'assessment',
      value: value,
    ));
  }

  QueryBuilder<Homework, Homework, QAfterFilterCondition> contentIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'content',
      value: null,
    ));
  }

  QueryBuilder<Homework, Homework, QAfterFilterCondition> contentEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'content',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Homework, Homework, QAfterFilterCondition> contentGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'content',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Homework, Homework, QAfterFilterCondition> contentLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'content',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Homework, Homework, QAfterFilterCondition> contentBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'content',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Homework, Homework, QAfterFilterCondition> contentStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'content',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Homework, Homework, QAfterFilterCondition> contentEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'content',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Homework, Homework, QAfterFilterCondition> contentContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'content',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Homework, Homework, QAfterFilterCondition> contentMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'content',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Homework, Homework, QAfterFilterCondition> dateEqualTo(
      DateTime value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'date',
      value: value,
    ));
  }

  QueryBuilder<Homework, Homework, QAfterFilterCondition> dateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'date',
      value: value,
    ));
  }

  QueryBuilder<Homework, Homework, QAfterFilterCondition> dateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'date',
      value: value,
    ));
  }

  QueryBuilder<Homework, Homework, QAfterFilterCondition> dateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'date',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Homework, Homework, QAfterFilterCondition> doneEqualTo(
      bool value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'done',
      value: value,
    ));
  }

  QueryBuilder<Homework, Homework, QAfterFilterCondition> dueEqualTo(
      bool value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'due',
      value: value,
    ));
  }

  QueryBuilder<Homework, Homework, QAfterFilterCondition> entityIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'entityId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Homework, Homework, QAfterFilterCondition> entityIdGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'entityId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Homework, Homework, QAfterFilterCondition> entityIdLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'entityId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Homework, Homework, QAfterFilterCondition> entityIdBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'entityId',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Homework, Homework, QAfterFilterCondition> entityIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'entityId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Homework, Homework, QAfterFilterCondition> entityIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'entityId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Homework, Homework, QAfterFilterCondition> entityIdContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'entityId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Homework, Homework, QAfterFilterCondition> entityIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'entityId',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Homework, Homework, QAfterFilterCondition> entryDateEqualTo(
      DateTime value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'entryDate',
      value: value,
    ));
  }

  QueryBuilder<Homework, Homework, QAfterFilterCondition> entryDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'entryDate',
      value: value,
    ));
  }

  QueryBuilder<Homework, Homework, QAfterFilterCondition> entryDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'entryDate',
      value: value,
    ));
  }

  QueryBuilder<Homework, Homework, QAfterFilterCondition> entryDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'entryDate',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Homework, Homework, QAfterFilterCondition> idIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'id',
      value: null,
    ));
  }

  QueryBuilder<Homework, Homework, QAfterFilterCondition> idEqualTo(
      int? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Homework, Homework, QAfterFilterCondition> idGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Homework, Homework, QAfterFilterCondition> idLessThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Homework, Homework, QAfterFilterCondition> idBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'id',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Homework, Homework, QAfterFilterCondition> pinnedEqualTo(
      bool value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'pinned',
      value: value,
    ));
  }
}

extension HomeworkQueryWhereSortBy
    on QueryBuilder<Homework, Homework, QSortBy> {
  QueryBuilder<Homework, Homework, QAfterSortBy> sortByAssessment() {
    return addSortByInternal('assessment', Sort.asc);
  }

  QueryBuilder<Homework, Homework, QAfterSortBy> sortByAssessmentDesc() {
    return addSortByInternal('assessment', Sort.desc);
  }

  QueryBuilder<Homework, Homework, QAfterSortBy> sortByContent() {
    return addSortByInternal('content', Sort.asc);
  }

  QueryBuilder<Homework, Homework, QAfterSortBy> sortByContentDesc() {
    return addSortByInternal('content', Sort.desc);
  }

  QueryBuilder<Homework, Homework, QAfterSortBy> sortByDate() {
    return addSortByInternal('date', Sort.asc);
  }

  QueryBuilder<Homework, Homework, QAfterSortBy> sortByDateDesc() {
    return addSortByInternal('date', Sort.desc);
  }

  QueryBuilder<Homework, Homework, QAfterSortBy> sortByDone() {
    return addSortByInternal('done', Sort.asc);
  }

  QueryBuilder<Homework, Homework, QAfterSortBy> sortByDoneDesc() {
    return addSortByInternal('done', Sort.desc);
  }

  QueryBuilder<Homework, Homework, QAfterSortBy> sortByDue() {
    return addSortByInternal('due', Sort.asc);
  }

  QueryBuilder<Homework, Homework, QAfterSortBy> sortByDueDesc() {
    return addSortByInternal('due', Sort.desc);
  }

  QueryBuilder<Homework, Homework, QAfterSortBy> sortByEntityId() {
    return addSortByInternal('entityId', Sort.asc);
  }

  QueryBuilder<Homework, Homework, QAfterSortBy> sortByEntityIdDesc() {
    return addSortByInternal('entityId', Sort.desc);
  }

  QueryBuilder<Homework, Homework, QAfterSortBy> sortByEntryDate() {
    return addSortByInternal('entryDate', Sort.asc);
  }

  QueryBuilder<Homework, Homework, QAfterSortBy> sortByEntryDateDesc() {
    return addSortByInternal('entryDate', Sort.desc);
  }

  QueryBuilder<Homework, Homework, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<Homework, Homework, QAfterSortBy> sortByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<Homework, Homework, QAfterSortBy> sortByPinned() {
    return addSortByInternal('pinned', Sort.asc);
  }

  QueryBuilder<Homework, Homework, QAfterSortBy> sortByPinnedDesc() {
    return addSortByInternal('pinned', Sort.desc);
  }
}

extension HomeworkQueryWhereSortThenBy
    on QueryBuilder<Homework, Homework, QSortThenBy> {
  QueryBuilder<Homework, Homework, QAfterSortBy> thenByAssessment() {
    return addSortByInternal('assessment', Sort.asc);
  }

  QueryBuilder<Homework, Homework, QAfterSortBy> thenByAssessmentDesc() {
    return addSortByInternal('assessment', Sort.desc);
  }

  QueryBuilder<Homework, Homework, QAfterSortBy> thenByContent() {
    return addSortByInternal('content', Sort.asc);
  }

  QueryBuilder<Homework, Homework, QAfterSortBy> thenByContentDesc() {
    return addSortByInternal('content', Sort.desc);
  }

  QueryBuilder<Homework, Homework, QAfterSortBy> thenByDate() {
    return addSortByInternal('date', Sort.asc);
  }

  QueryBuilder<Homework, Homework, QAfterSortBy> thenByDateDesc() {
    return addSortByInternal('date', Sort.desc);
  }

  QueryBuilder<Homework, Homework, QAfterSortBy> thenByDone() {
    return addSortByInternal('done', Sort.asc);
  }

  QueryBuilder<Homework, Homework, QAfterSortBy> thenByDoneDesc() {
    return addSortByInternal('done', Sort.desc);
  }

  QueryBuilder<Homework, Homework, QAfterSortBy> thenByDue() {
    return addSortByInternal('due', Sort.asc);
  }

  QueryBuilder<Homework, Homework, QAfterSortBy> thenByDueDesc() {
    return addSortByInternal('due', Sort.desc);
  }

  QueryBuilder<Homework, Homework, QAfterSortBy> thenByEntityId() {
    return addSortByInternal('entityId', Sort.asc);
  }

  QueryBuilder<Homework, Homework, QAfterSortBy> thenByEntityIdDesc() {
    return addSortByInternal('entityId', Sort.desc);
  }

  QueryBuilder<Homework, Homework, QAfterSortBy> thenByEntryDate() {
    return addSortByInternal('entryDate', Sort.asc);
  }

  QueryBuilder<Homework, Homework, QAfterSortBy> thenByEntryDateDesc() {
    return addSortByInternal('entryDate', Sort.desc);
  }

  QueryBuilder<Homework, Homework, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<Homework, Homework, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<Homework, Homework, QAfterSortBy> thenByPinned() {
    return addSortByInternal('pinned', Sort.asc);
  }

  QueryBuilder<Homework, Homework, QAfterSortBy> thenByPinnedDesc() {
    return addSortByInternal('pinned', Sort.desc);
  }
}

extension HomeworkQueryWhereDistinct
    on QueryBuilder<Homework, Homework, QDistinct> {
  QueryBuilder<Homework, Homework, QDistinct> distinctByAssessment() {
    return addDistinctByInternal('assessment');
  }

  QueryBuilder<Homework, Homework, QDistinct> distinctByContent(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('content', caseSensitive: caseSensitive);
  }

  QueryBuilder<Homework, Homework, QDistinct> distinctByDate() {
    return addDistinctByInternal('date');
  }

  QueryBuilder<Homework, Homework, QDistinct> distinctByDone() {
    return addDistinctByInternal('done');
  }

  QueryBuilder<Homework, Homework, QDistinct> distinctByDue() {
    return addDistinctByInternal('due');
  }

  QueryBuilder<Homework, Homework, QDistinct> distinctByEntityId(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('entityId', caseSensitive: caseSensitive);
  }

  QueryBuilder<Homework, Homework, QDistinct> distinctByEntryDate() {
    return addDistinctByInternal('entryDate');
  }

  QueryBuilder<Homework, Homework, QDistinct> distinctById() {
    return addDistinctByInternal('id');
  }

  QueryBuilder<Homework, Homework, QDistinct> distinctByPinned() {
    return addDistinctByInternal('pinned');
  }
}

extension HomeworkQueryProperty
    on QueryBuilder<Homework, Homework, QQueryProperty> {
  QueryBuilder<Homework, bool, QQueryOperations> assessmentProperty() {
    return addPropertyNameInternal('assessment');
  }

  QueryBuilder<Homework, String?, QQueryOperations> contentProperty() {
    return addPropertyNameInternal('content');
  }

  QueryBuilder<Homework, DateTime, QQueryOperations> dateProperty() {
    return addPropertyNameInternal('date');
  }

  QueryBuilder<Homework, bool, QQueryOperations> doneProperty() {
    return addPropertyNameInternal('done');
  }

  QueryBuilder<Homework, bool, QQueryOperations> dueProperty() {
    return addPropertyNameInternal('due');
  }

  QueryBuilder<Homework, String, QQueryOperations> entityIdProperty() {
    return addPropertyNameInternal('entityId');
  }

  QueryBuilder<Homework, DateTime, QQueryOperations> entryDateProperty() {
    return addPropertyNameInternal('entryDate');
  }

  QueryBuilder<Homework, int?, QQueryOperations> idProperty() {
    return addPropertyNameInternal('id');
  }

  QueryBuilder<Homework, bool, QQueryOperations> pinnedProperty() {
    return addPropertyNameInternal('pinned');
  }
}

// ignore_for_file: duplicate_ignore, non_constant_identifier_names, invalid_use_of_protected_member

extension GetRecipientCollection on Isar {
  IsarCollection<Recipient> get recipients {
    return getCollection('Recipient');
  }
}

final RecipientSchema = CollectionSchema(
  name: 'Recipient',
  schema:
      '{"name":"Recipient","properties":[{"name":"civility","type":"String"},{"name":"entityId","type":"String"},{"name":"firstName","type":"String"},{"name":"fullName","type":"String"},{"name":"headTeacher","type":"Byte"},{"name":"lastName","type":"String"},{"name":"subjects","type":"StringList"}],"indexes":[],"links":[]}',
  adapter: const _RecipientAdapter(),
  idName: 'id',
  propertyIds: {
    'civility': 0,
    'entityId': 1,
    'firstName': 2,
    'fullName': 3,
    'headTeacher': 4,
    'lastName': 5,
    'subjects': 6
  },
  indexIds: {},
  indexTypes: {},
  linkIds: {},
  backlinkIds: {},
  linkedCollections: [],
  getId: (obj) => obj.id,
  setId: (obj, id) => obj.id = id,
  getLinks: (obj) => [],
  version: 1,
);

class _RecipientAdapter extends IsarTypeAdapter<Recipient> {
  const _RecipientAdapter();

  @override
  void serialize(IsarCollection<Recipient> collection, IsarRawObject rawObj,
      Recipient object, List<int> offsets, AdapterAlloc alloc) {
    var dynamicSize = 0;
    final value0 = object.civility;
    final _civility = BinaryWriter.utf8Encoder.convert(value0);
    dynamicSize += _civility.length;
    final value1 = object.entityId;
    final _entityId = BinaryWriter.utf8Encoder.convert(value1);
    dynamicSize += _entityId.length;
    final value2 = object.firstName;
    final _firstName = BinaryWriter.utf8Encoder.convert(value2);
    dynamicSize += _firstName.length;
    final value3 = object.fullName;
    final _fullName = BinaryWriter.utf8Encoder.convert(value3);
    dynamicSize += _fullName.length;
    final value4 = object.headTeacher;
    final _headTeacher = value4;
    final value5 = object.lastName;
    final _lastName = BinaryWriter.utf8Encoder.convert(value5);
    dynamicSize += _lastName.length;
    final value6 = object.subjects;
    dynamicSize += (value6.length) * 8;
    final bytesList6 = <IsarUint8List>[];
    for (var str in value6) {
      final bytes = BinaryWriter.utf8Encoder.convert(str);
      bytesList6.add(bytes);
      dynamicSize += bytes.length;
    }
    final _subjects = bytesList6;
    final size = dynamicSize + 51;

    rawObj.buffer = alloc(size);
    rawObj.buffer_length = size;
    final buffer = bufAsBytes(rawObj.buffer, size);
    final writer = BinaryWriter(buffer, 51);
    writer.writeBytes(offsets[0], _civility);
    writer.writeBytes(offsets[1], _entityId);
    writer.writeBytes(offsets[2], _firstName);
    writer.writeBytes(offsets[3], _fullName);
    writer.writeBool(offsets[4], _headTeacher);
    writer.writeBytes(offsets[5], _lastName);
    writer.writeStringList(offsets[6], _subjects);
  }

  @override
  Recipient deserialize(IsarCollection<Recipient> collection, int id,
      BinaryReader reader, List<int> offsets) {
    final object = Recipient(
      civility: reader.readString(offsets[0]),
      entityId: reader.readString(offsets[1]),
      firstName: reader.readString(offsets[2]),
      headTeacher: reader.readBool(offsets[4]),
      lastName: reader.readString(offsets[5]),
      subjects: reader.readStringList(offsets[6]) ?? [],
    );
    object.id = id;
    return object;
  }

  @override
  P deserializeProperty<P>(
      int id, BinaryReader reader, int propertyIndex, int offset) {
    switch (propertyIndex) {
      case -1:
        return id as P;
      case 0:
        return (reader.readString(offset)) as P;
      case 1:
        return (reader.readString(offset)) as P;
      case 2:
        return (reader.readString(offset)) as P;
      case 3:
        return (reader.readString(offset)) as P;
      case 4:
        return (reader.readBool(offset)) as P;
      case 5:
        return (reader.readString(offset)) as P;
      case 6:
        return (reader.readStringList(offset) ?? []) as P;
      default:
        throw 'Illegal propertyIndex';
    }
  }
}

extension RecipientQueryWhereSort
    on QueryBuilder<Recipient, Recipient, QWhere> {
  QueryBuilder<Recipient, Recipient, QAfterWhere> anyId() {
    return addWhereClauseInternal(const WhereClause(indexName: null));
  }
}

extension RecipientQueryWhere
    on QueryBuilder<Recipient, Recipient, QWhereClause> {
  QueryBuilder<Recipient, Recipient, QAfterWhereClause> idEqualTo(int? id) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [id],
      includeLower: true,
      upper: [id],
      includeUpper: true,
    ));
  }

  QueryBuilder<Recipient, Recipient, QAfterWhereClause> idNotEqualTo(int? id) {
    if (whereSortInternal == Sort.asc) {
      return addWhereClauseInternal(WhereClause(
        indexName: null,
        upper: [id],
        includeUpper: false,
      )).addWhereClauseInternal(WhereClause(
        indexName: null,
        lower: [id],
        includeLower: false,
      ));
    } else {
      return addWhereClauseInternal(WhereClause(
        indexName: null,
        lower: [id],
        includeLower: false,
      )).addWhereClauseInternal(WhereClause(
        indexName: null,
        upper: [id],
        includeUpper: false,
      ));
    }
  }

  QueryBuilder<Recipient, Recipient, QAfterWhereClause> idGreaterThan(
    int? id, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [id],
      includeLower: include,
    ));
  }

  QueryBuilder<Recipient, Recipient, QAfterWhereClause> idLessThan(
    int? id, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      upper: [id],
      includeUpper: include,
    ));
  }

  QueryBuilder<Recipient, Recipient, QAfterWhereClause> idBetween(
    int? lowerId,
    int? upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [lowerId],
      includeLower: includeLower,
      upper: [upperId],
      includeUpper: includeUpper,
    ));
  }
}

extension RecipientQueryFilter
    on QueryBuilder<Recipient, Recipient, QFilterCondition> {
  QueryBuilder<Recipient, Recipient, QAfterFilterCondition> civilityEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'civility',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Recipient, Recipient, QAfterFilterCondition> civilityGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'civility',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Recipient, Recipient, QAfterFilterCondition> civilityLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'civility',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Recipient, Recipient, QAfterFilterCondition> civilityBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'civility',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Recipient, Recipient, QAfterFilterCondition> civilityStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'civility',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Recipient, Recipient, QAfterFilterCondition> civilityEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'civility',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Recipient, Recipient, QAfterFilterCondition> civilityContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'civility',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Recipient, Recipient, QAfterFilterCondition> civilityMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'civility',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Recipient, Recipient, QAfterFilterCondition> entityIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'entityId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Recipient, Recipient, QAfterFilterCondition> entityIdGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'entityId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Recipient, Recipient, QAfterFilterCondition> entityIdLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'entityId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Recipient, Recipient, QAfterFilterCondition> entityIdBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'entityId',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Recipient, Recipient, QAfterFilterCondition> entityIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'entityId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Recipient, Recipient, QAfterFilterCondition> entityIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'entityId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Recipient, Recipient, QAfterFilterCondition> entityIdContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'entityId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Recipient, Recipient, QAfterFilterCondition> entityIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'entityId',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Recipient, Recipient, QAfterFilterCondition> firstNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'firstName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Recipient, Recipient, QAfterFilterCondition>
      firstNameGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'firstName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Recipient, Recipient, QAfterFilterCondition> firstNameLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'firstName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Recipient, Recipient, QAfterFilterCondition> firstNameBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'firstName',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Recipient, Recipient, QAfterFilterCondition> firstNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'firstName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Recipient, Recipient, QAfterFilterCondition> firstNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'firstName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Recipient, Recipient, QAfterFilterCondition> firstNameContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'firstName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Recipient, Recipient, QAfterFilterCondition> firstNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'firstName',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Recipient, Recipient, QAfterFilterCondition> fullNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'fullName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Recipient, Recipient, QAfterFilterCondition> fullNameGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'fullName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Recipient, Recipient, QAfterFilterCondition> fullNameLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'fullName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Recipient, Recipient, QAfterFilterCondition> fullNameBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'fullName',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Recipient, Recipient, QAfterFilterCondition> fullNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'fullName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Recipient, Recipient, QAfterFilterCondition> fullNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'fullName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Recipient, Recipient, QAfterFilterCondition> fullNameContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'fullName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Recipient, Recipient, QAfterFilterCondition> fullNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'fullName',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Recipient, Recipient, QAfterFilterCondition> headTeacherEqualTo(
      bool value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'headTeacher',
      value: value,
    ));
  }

  QueryBuilder<Recipient, Recipient, QAfterFilterCondition> idIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'id',
      value: null,
    ));
  }

  QueryBuilder<Recipient, Recipient, QAfterFilterCondition> idEqualTo(
      int? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Recipient, Recipient, QAfterFilterCondition> idGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Recipient, Recipient, QAfterFilterCondition> idLessThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Recipient, Recipient, QAfterFilterCondition> idBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'id',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Recipient, Recipient, QAfterFilterCondition> lastNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'lastName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Recipient, Recipient, QAfterFilterCondition> lastNameGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'lastName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Recipient, Recipient, QAfterFilterCondition> lastNameLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'lastName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Recipient, Recipient, QAfterFilterCondition> lastNameBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'lastName',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Recipient, Recipient, QAfterFilterCondition> lastNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'lastName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Recipient, Recipient, QAfterFilterCondition> lastNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'lastName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Recipient, Recipient, QAfterFilterCondition> lastNameContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'lastName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Recipient, Recipient, QAfterFilterCondition> lastNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'lastName',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Recipient, Recipient, QAfterFilterCondition> subjectsAnyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'subjects',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Recipient, Recipient, QAfterFilterCondition>
      subjectsAnyGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'subjects',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Recipient, Recipient, QAfterFilterCondition> subjectsAnyLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'subjects',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Recipient, Recipient, QAfterFilterCondition> subjectsAnyBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'subjects',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Recipient, Recipient, QAfterFilterCondition>
      subjectsAnyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'subjects',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Recipient, Recipient, QAfterFilterCondition> subjectsAnyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'subjects',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Recipient, Recipient, QAfterFilterCondition> subjectsAnyContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'subjects',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Recipient, Recipient, QAfterFilterCondition> subjectsAnyMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'subjects',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }
}

extension RecipientQueryWhereSortBy
    on QueryBuilder<Recipient, Recipient, QSortBy> {
  QueryBuilder<Recipient, Recipient, QAfterSortBy> sortByCivility() {
    return addSortByInternal('civility', Sort.asc);
  }

  QueryBuilder<Recipient, Recipient, QAfterSortBy> sortByCivilityDesc() {
    return addSortByInternal('civility', Sort.desc);
  }

  QueryBuilder<Recipient, Recipient, QAfterSortBy> sortByEntityId() {
    return addSortByInternal('entityId', Sort.asc);
  }

  QueryBuilder<Recipient, Recipient, QAfterSortBy> sortByEntityIdDesc() {
    return addSortByInternal('entityId', Sort.desc);
  }

  QueryBuilder<Recipient, Recipient, QAfterSortBy> sortByFirstName() {
    return addSortByInternal('firstName', Sort.asc);
  }

  QueryBuilder<Recipient, Recipient, QAfterSortBy> sortByFirstNameDesc() {
    return addSortByInternal('firstName', Sort.desc);
  }

  QueryBuilder<Recipient, Recipient, QAfterSortBy> sortByFullName() {
    return addSortByInternal('fullName', Sort.asc);
  }

  QueryBuilder<Recipient, Recipient, QAfterSortBy> sortByFullNameDesc() {
    return addSortByInternal('fullName', Sort.desc);
  }

  QueryBuilder<Recipient, Recipient, QAfterSortBy> sortByHeadTeacher() {
    return addSortByInternal('headTeacher', Sort.asc);
  }

  QueryBuilder<Recipient, Recipient, QAfterSortBy> sortByHeadTeacherDesc() {
    return addSortByInternal('headTeacher', Sort.desc);
  }

  QueryBuilder<Recipient, Recipient, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<Recipient, Recipient, QAfterSortBy> sortByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<Recipient, Recipient, QAfterSortBy> sortByLastName() {
    return addSortByInternal('lastName', Sort.asc);
  }

  QueryBuilder<Recipient, Recipient, QAfterSortBy> sortByLastNameDesc() {
    return addSortByInternal('lastName', Sort.desc);
  }
}

extension RecipientQueryWhereSortThenBy
    on QueryBuilder<Recipient, Recipient, QSortThenBy> {
  QueryBuilder<Recipient, Recipient, QAfterSortBy> thenByCivility() {
    return addSortByInternal('civility', Sort.asc);
  }

  QueryBuilder<Recipient, Recipient, QAfterSortBy> thenByCivilityDesc() {
    return addSortByInternal('civility', Sort.desc);
  }

  QueryBuilder<Recipient, Recipient, QAfterSortBy> thenByEntityId() {
    return addSortByInternal('entityId', Sort.asc);
  }

  QueryBuilder<Recipient, Recipient, QAfterSortBy> thenByEntityIdDesc() {
    return addSortByInternal('entityId', Sort.desc);
  }

  QueryBuilder<Recipient, Recipient, QAfterSortBy> thenByFirstName() {
    return addSortByInternal('firstName', Sort.asc);
  }

  QueryBuilder<Recipient, Recipient, QAfterSortBy> thenByFirstNameDesc() {
    return addSortByInternal('firstName', Sort.desc);
  }

  QueryBuilder<Recipient, Recipient, QAfterSortBy> thenByFullName() {
    return addSortByInternal('fullName', Sort.asc);
  }

  QueryBuilder<Recipient, Recipient, QAfterSortBy> thenByFullNameDesc() {
    return addSortByInternal('fullName', Sort.desc);
  }

  QueryBuilder<Recipient, Recipient, QAfterSortBy> thenByHeadTeacher() {
    return addSortByInternal('headTeacher', Sort.asc);
  }

  QueryBuilder<Recipient, Recipient, QAfterSortBy> thenByHeadTeacherDesc() {
    return addSortByInternal('headTeacher', Sort.desc);
  }

  QueryBuilder<Recipient, Recipient, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<Recipient, Recipient, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<Recipient, Recipient, QAfterSortBy> thenByLastName() {
    return addSortByInternal('lastName', Sort.asc);
  }

  QueryBuilder<Recipient, Recipient, QAfterSortBy> thenByLastNameDesc() {
    return addSortByInternal('lastName', Sort.desc);
  }
}

extension RecipientQueryWhereDistinct
    on QueryBuilder<Recipient, Recipient, QDistinct> {
  QueryBuilder<Recipient, Recipient, QDistinct> distinctByCivility(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('civility', caseSensitive: caseSensitive);
  }

  QueryBuilder<Recipient, Recipient, QDistinct> distinctByEntityId(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('entityId', caseSensitive: caseSensitive);
  }

  QueryBuilder<Recipient, Recipient, QDistinct> distinctByFirstName(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('firstName', caseSensitive: caseSensitive);
  }

  QueryBuilder<Recipient, Recipient, QDistinct> distinctByFullName(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('fullName', caseSensitive: caseSensitive);
  }

  QueryBuilder<Recipient, Recipient, QDistinct> distinctByHeadTeacher() {
    return addDistinctByInternal('headTeacher');
  }

  QueryBuilder<Recipient, Recipient, QDistinct> distinctById() {
    return addDistinctByInternal('id');
  }

  QueryBuilder<Recipient, Recipient, QDistinct> distinctByLastName(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('lastName', caseSensitive: caseSensitive);
  }
}

extension RecipientQueryProperty
    on QueryBuilder<Recipient, Recipient, QQueryProperty> {
  QueryBuilder<Recipient, String, QQueryOperations> civilityProperty() {
    return addPropertyNameInternal('civility');
  }

  QueryBuilder<Recipient, String, QQueryOperations> entityIdProperty() {
    return addPropertyNameInternal('entityId');
  }

  QueryBuilder<Recipient, String, QQueryOperations> firstNameProperty() {
    return addPropertyNameInternal('firstName');
  }

  QueryBuilder<Recipient, String, QQueryOperations> fullNameProperty() {
    return addPropertyNameInternal('fullName');
  }

  QueryBuilder<Recipient, bool, QQueryOperations> headTeacherProperty() {
    return addPropertyNameInternal('headTeacher');
  }

  QueryBuilder<Recipient, int?, QQueryOperations> idProperty() {
    return addPropertyNameInternal('id');
  }

  QueryBuilder<Recipient, String, QQueryOperations> lastNameProperty() {
    return addPropertyNameInternal('lastName');
  }

  QueryBuilder<Recipient, List<String>, QQueryOperations> subjectsProperty() {
    return addPropertyNameInternal('subjects');
  }
}

// ignore_for_file: duplicate_ignore, non_constant_identifier_names, invalid_use_of_protected_member

extension GetSchoolAccountCollection on Isar {
  IsarCollection<SchoolAccount> get schoolAccounts {
    return getCollection('SchoolAccount');
  }
}

final SchoolAccountSchema = CollectionSchema(
  name: 'SchoolAccount',
  schema:
      '{"name":"SchoolAccount","properties":[{"name":"className","type":"String"},{"name":"entityId","type":"String"},{"name":"firstName","type":"String"},{"name":"fullName","type":"String"},{"name":"lastName","type":"String"},{"name":"profilePicture","type":"String"},{"name":"school","type":"String"}],"indexes":[],"links":[]}',
  adapter: const _SchoolAccountAdapter(),
  idName: 'id',
  propertyIds: {
    'className': 0,
    'entityId': 1,
    'firstName': 2,
    'fullName': 3,
    'lastName': 4,
    'profilePicture': 5,
    'school': 6
  },
  indexIds: {},
  indexTypes: {},
  linkIds: {},
  backlinkIds: {},
  linkedCollections: [],
  getId: (obj) => obj.id,
  setId: (obj, id) => obj.id = id,
  getLinks: (obj) => [],
  version: 1,
);

class _SchoolAccountAdapter extends IsarTypeAdapter<SchoolAccount> {
  const _SchoolAccountAdapter();

  @override
  void serialize(IsarCollection<SchoolAccount> collection, IsarRawObject rawObj,
      SchoolAccount object, List<int> offsets, AdapterAlloc alloc) {
    var dynamicSize = 0;
    final value0 = object.className;
    final _className = BinaryWriter.utf8Encoder.convert(value0);
    dynamicSize += _className.length;
    final value1 = object.entityId;
    final _entityId = BinaryWriter.utf8Encoder.convert(value1);
    dynamicSize += _entityId.length;
    final value2 = object.firstName;
    final _firstName = BinaryWriter.utf8Encoder.convert(value2);
    dynamicSize += _firstName.length;
    final value3 = object.fullName;
    final _fullName = BinaryWriter.utf8Encoder.convert(value3);
    dynamicSize += _fullName.length;
    final value4 = object.lastName;
    final _lastName = BinaryWriter.utf8Encoder.convert(value4);
    dynamicSize += _lastName.length;
    final value5 = object.profilePicture;
    final _profilePicture = BinaryWriter.utf8Encoder.convert(value5);
    dynamicSize += _profilePicture.length;
    final value6 = object.school;
    final _school = BinaryWriter.utf8Encoder.convert(value6);
    dynamicSize += _school.length;
    final size = dynamicSize + 58;

    rawObj.buffer = alloc(size);
    rawObj.buffer_length = size;
    final buffer = bufAsBytes(rawObj.buffer, size);
    final writer = BinaryWriter(buffer, 58);
    writer.writeBytes(offsets[0], _className);
    writer.writeBytes(offsets[1], _entityId);
    writer.writeBytes(offsets[2], _firstName);
    writer.writeBytes(offsets[3], _fullName);
    writer.writeBytes(offsets[4], _lastName);
    writer.writeBytes(offsets[5], _profilePicture);
    writer.writeBytes(offsets[6], _school);
  }

  @override
  SchoolAccount deserialize(IsarCollection<SchoolAccount> collection, int id,
      BinaryReader reader, List<int> offsets) {
    final object = SchoolAccount(
      className: reader.readString(offsets[0]),
      entityId: reader.readString(offsets[1]),
      firstName: reader.readString(offsets[2]),
      lastName: reader.readString(offsets[4]),
      profilePicture: reader.readString(offsets[5]),
      school: reader.readString(offsets[6]),
    );
    object.id = id;
    return object;
  }

  @override
  P deserializeProperty<P>(
      int id, BinaryReader reader, int propertyIndex, int offset) {
    switch (propertyIndex) {
      case -1:
        return id as P;
      case 0:
        return (reader.readString(offset)) as P;
      case 1:
        return (reader.readString(offset)) as P;
      case 2:
        return (reader.readString(offset)) as P;
      case 3:
        return (reader.readString(offset)) as P;
      case 4:
        return (reader.readString(offset)) as P;
      case 5:
        return (reader.readString(offset)) as P;
      case 6:
        return (reader.readString(offset)) as P;
      default:
        throw 'Illegal propertyIndex';
    }
  }
}

extension SchoolAccountQueryWhereSort
    on QueryBuilder<SchoolAccount, SchoolAccount, QWhere> {
  QueryBuilder<SchoolAccount, SchoolAccount, QAfterWhere> anyId() {
    return addWhereClauseInternal(const WhereClause(indexName: null));
  }
}

extension SchoolAccountQueryWhere
    on QueryBuilder<SchoolAccount, SchoolAccount, QWhereClause> {
  QueryBuilder<SchoolAccount, SchoolAccount, QAfterWhereClause> idEqualTo(
      int? id) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [id],
      includeLower: true,
      upper: [id],
      includeUpper: true,
    ));
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterWhereClause> idNotEqualTo(
      int? id) {
    if (whereSortInternal == Sort.asc) {
      return addWhereClauseInternal(WhereClause(
        indexName: null,
        upper: [id],
        includeUpper: false,
      )).addWhereClauseInternal(WhereClause(
        indexName: null,
        lower: [id],
        includeLower: false,
      ));
    } else {
      return addWhereClauseInternal(WhereClause(
        indexName: null,
        lower: [id],
        includeLower: false,
      )).addWhereClauseInternal(WhereClause(
        indexName: null,
        upper: [id],
        includeUpper: false,
      ));
    }
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterWhereClause> idGreaterThan(
    int? id, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [id],
      includeLower: include,
    ));
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterWhereClause> idLessThan(
    int? id, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      upper: [id],
      includeUpper: include,
    ));
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterWhereClause> idBetween(
    int? lowerId,
    int? upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [lowerId],
      includeLower: includeLower,
      upper: [upperId],
      includeUpper: includeUpper,
    ));
  }
}

extension SchoolAccountQueryFilter
    on QueryBuilder<SchoolAccount, SchoolAccount, QFilterCondition> {
  QueryBuilder<SchoolAccount, SchoolAccount, QAfterFilterCondition>
      classNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'className',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterFilterCondition>
      classNameGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'className',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterFilterCondition>
      classNameLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'className',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterFilterCondition>
      classNameBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'className',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterFilterCondition>
      classNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'className',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterFilterCondition>
      classNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'className',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterFilterCondition>
      classNameContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'className',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterFilterCondition>
      classNameMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'className',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterFilterCondition>
      entityIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'entityId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterFilterCondition>
      entityIdGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'entityId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterFilterCondition>
      entityIdLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'entityId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterFilterCondition>
      entityIdBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'entityId',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterFilterCondition>
      entityIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'entityId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterFilterCondition>
      entityIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'entityId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterFilterCondition>
      entityIdContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'entityId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterFilterCondition>
      entityIdMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'entityId',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterFilterCondition>
      firstNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'firstName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterFilterCondition>
      firstNameGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'firstName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterFilterCondition>
      firstNameLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'firstName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterFilterCondition>
      firstNameBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'firstName',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterFilterCondition>
      firstNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'firstName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterFilterCondition>
      firstNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'firstName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterFilterCondition>
      firstNameContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'firstName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterFilterCondition>
      firstNameMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'firstName',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterFilterCondition>
      fullNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'fullName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterFilterCondition>
      fullNameGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'fullName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterFilterCondition>
      fullNameLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'fullName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterFilterCondition>
      fullNameBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'fullName',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterFilterCondition>
      fullNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'fullName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterFilterCondition>
      fullNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'fullName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterFilterCondition>
      fullNameContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'fullName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterFilterCondition>
      fullNameMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'fullName',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterFilterCondition> idIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'id',
      value: null,
    ));
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterFilterCondition> idEqualTo(
      int? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterFilterCondition>
      idGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterFilterCondition> idLessThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterFilterCondition> idBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'id',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterFilterCondition>
      lastNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'lastName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterFilterCondition>
      lastNameGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'lastName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterFilterCondition>
      lastNameLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'lastName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterFilterCondition>
      lastNameBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'lastName',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterFilterCondition>
      lastNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'lastName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterFilterCondition>
      lastNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'lastName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterFilterCondition>
      lastNameContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'lastName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterFilterCondition>
      lastNameMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'lastName',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterFilterCondition>
      profilePictureEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'profilePicture',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterFilterCondition>
      profilePictureGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'profilePicture',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterFilterCondition>
      profilePictureLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'profilePicture',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterFilterCondition>
      profilePictureBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'profilePicture',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterFilterCondition>
      profilePictureStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'profilePicture',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterFilterCondition>
      profilePictureEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'profilePicture',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterFilterCondition>
      profilePictureContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'profilePicture',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterFilterCondition>
      profilePictureMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'profilePicture',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterFilterCondition>
      schoolEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'school',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterFilterCondition>
      schoolGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'school',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterFilterCondition>
      schoolLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'school',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterFilterCondition>
      schoolBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'school',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterFilterCondition>
      schoolStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'school',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterFilterCondition>
      schoolEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'school',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterFilterCondition>
      schoolContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'school',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterFilterCondition>
      schoolMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'school',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }
}

extension SchoolAccountQueryWhereSortBy
    on QueryBuilder<SchoolAccount, SchoolAccount, QSortBy> {
  QueryBuilder<SchoolAccount, SchoolAccount, QAfterSortBy> sortByClassName() {
    return addSortByInternal('className', Sort.asc);
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterSortBy>
      sortByClassNameDesc() {
    return addSortByInternal('className', Sort.desc);
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterSortBy> sortByEntityId() {
    return addSortByInternal('entityId', Sort.asc);
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterSortBy>
      sortByEntityIdDesc() {
    return addSortByInternal('entityId', Sort.desc);
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterSortBy> sortByFirstName() {
    return addSortByInternal('firstName', Sort.asc);
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterSortBy>
      sortByFirstNameDesc() {
    return addSortByInternal('firstName', Sort.desc);
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterSortBy> sortByFullName() {
    return addSortByInternal('fullName', Sort.asc);
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterSortBy>
      sortByFullNameDesc() {
    return addSortByInternal('fullName', Sort.desc);
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterSortBy> sortByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterSortBy> sortByLastName() {
    return addSortByInternal('lastName', Sort.asc);
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterSortBy>
      sortByLastNameDesc() {
    return addSortByInternal('lastName', Sort.desc);
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterSortBy>
      sortByProfilePicture() {
    return addSortByInternal('profilePicture', Sort.asc);
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterSortBy>
      sortByProfilePictureDesc() {
    return addSortByInternal('profilePicture', Sort.desc);
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterSortBy> sortBySchool() {
    return addSortByInternal('school', Sort.asc);
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterSortBy> sortBySchoolDesc() {
    return addSortByInternal('school', Sort.desc);
  }
}

extension SchoolAccountQueryWhereSortThenBy
    on QueryBuilder<SchoolAccount, SchoolAccount, QSortThenBy> {
  QueryBuilder<SchoolAccount, SchoolAccount, QAfterSortBy> thenByClassName() {
    return addSortByInternal('className', Sort.asc);
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterSortBy>
      thenByClassNameDesc() {
    return addSortByInternal('className', Sort.desc);
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterSortBy> thenByEntityId() {
    return addSortByInternal('entityId', Sort.asc);
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterSortBy>
      thenByEntityIdDesc() {
    return addSortByInternal('entityId', Sort.desc);
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterSortBy> thenByFirstName() {
    return addSortByInternal('firstName', Sort.asc);
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterSortBy>
      thenByFirstNameDesc() {
    return addSortByInternal('firstName', Sort.desc);
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterSortBy> thenByFullName() {
    return addSortByInternal('fullName', Sort.asc);
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterSortBy>
      thenByFullNameDesc() {
    return addSortByInternal('fullName', Sort.desc);
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterSortBy> thenByLastName() {
    return addSortByInternal('lastName', Sort.asc);
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterSortBy>
      thenByLastNameDesc() {
    return addSortByInternal('lastName', Sort.desc);
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterSortBy>
      thenByProfilePicture() {
    return addSortByInternal('profilePicture', Sort.asc);
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterSortBy>
      thenByProfilePictureDesc() {
    return addSortByInternal('profilePicture', Sort.desc);
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterSortBy> thenBySchool() {
    return addSortByInternal('school', Sort.asc);
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QAfterSortBy> thenBySchoolDesc() {
    return addSortByInternal('school', Sort.desc);
  }
}

extension SchoolAccountQueryWhereDistinct
    on QueryBuilder<SchoolAccount, SchoolAccount, QDistinct> {
  QueryBuilder<SchoolAccount, SchoolAccount, QDistinct> distinctByClassName(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('className', caseSensitive: caseSensitive);
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QDistinct> distinctByEntityId(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('entityId', caseSensitive: caseSensitive);
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QDistinct> distinctByFirstName(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('firstName', caseSensitive: caseSensitive);
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QDistinct> distinctByFullName(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('fullName', caseSensitive: caseSensitive);
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QDistinct> distinctById() {
    return addDistinctByInternal('id');
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QDistinct> distinctByLastName(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('lastName', caseSensitive: caseSensitive);
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QDistinct>
      distinctByProfilePicture({bool caseSensitive = true}) {
    return addDistinctByInternal('profilePicture',
        caseSensitive: caseSensitive);
  }

  QueryBuilder<SchoolAccount, SchoolAccount, QDistinct> distinctBySchool(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('school', caseSensitive: caseSensitive);
  }
}

extension SchoolAccountQueryProperty
    on QueryBuilder<SchoolAccount, SchoolAccount, QQueryProperty> {
  QueryBuilder<SchoolAccount, String, QQueryOperations> classNameProperty() {
    return addPropertyNameInternal('className');
  }

  QueryBuilder<SchoolAccount, String, QQueryOperations> entityIdProperty() {
    return addPropertyNameInternal('entityId');
  }

  QueryBuilder<SchoolAccount, String, QQueryOperations> firstNameProperty() {
    return addPropertyNameInternal('firstName');
  }

  QueryBuilder<SchoolAccount, String, QQueryOperations> fullNameProperty() {
    return addPropertyNameInternal('fullName');
  }

  QueryBuilder<SchoolAccount, int?, QQueryOperations> idProperty() {
    return addPropertyNameInternal('id');
  }

  QueryBuilder<SchoolAccount, String, QQueryOperations> lastNameProperty() {
    return addPropertyNameInternal('lastName');
  }

  QueryBuilder<SchoolAccount, String, QQueryOperations>
      profilePictureProperty() {
    return addPropertyNameInternal('profilePicture');
  }

  QueryBuilder<SchoolAccount, String, QQueryOperations> schoolProperty() {
    return addPropertyNameInternal('school');
  }
}

// ignore_for_file: duplicate_ignore, non_constant_identifier_names, invalid_use_of_protected_member

extension GetSchoolLifeSanctionCollection on Isar {
  IsarCollection<SchoolLifeSanction> get schoolLifeSanctions {
    return getCollection('SchoolLifeSanction');
  }
}

final SchoolLifeSanctionSchema = CollectionSchema(
  name: 'SchoolLifeSanction',
  schema:
      '{"name":"SchoolLifeSanction","properties":[{"name":"by","type":"String"},{"name":"date","type":"Long"},{"name":"reason","type":"String"},{"name":"registrationDate","type":"String"},{"name":"sanction","type":"String"},{"name":"type","type":"String"},{"name":"work","type":"String"}],"indexes":[],"links":[]}',
  adapter: const _SchoolLifeSanctionAdapter(),
  idName: 'id',
  propertyIds: {
    'by': 0,
    'date': 1,
    'reason': 2,
    'registrationDate': 3,
    'sanction': 4,
    'type': 5,
    'work': 6
  },
  indexIds: {},
  indexTypes: {},
  linkIds: {},
  backlinkIds: {},
  linkedCollections: [],
  getId: (obj) => obj.id,
  setId: (obj, id) => obj.id = id,
  getLinks: (obj) => [],
  version: 1,
);

class _SchoolLifeSanctionAdapter extends IsarTypeAdapter<SchoolLifeSanction> {
  const _SchoolLifeSanctionAdapter();

  @override
  void serialize(
      IsarCollection<SchoolLifeSanction> collection,
      IsarRawObject rawObj,
      SchoolLifeSanction object,
      List<int> offsets,
      AdapterAlloc alloc) {
    var dynamicSize = 0;
    final value0 = object.by;
    final _by = BinaryWriter.utf8Encoder.convert(value0);
    dynamicSize += _by.length;
    final value1 = object.date;
    final _date = value1;
    final value2 = object.reason;
    final _reason = BinaryWriter.utf8Encoder.convert(value2);
    dynamicSize += _reason.length;
    final value3 = object.registrationDate;
    final _registrationDate = BinaryWriter.utf8Encoder.convert(value3);
    dynamicSize += _registrationDate.length;
    final value4 = object.sanction;
    final _sanction = BinaryWriter.utf8Encoder.convert(value4);
    dynamicSize += _sanction.length;
    final value5 = object.type;
    final _type = BinaryWriter.utf8Encoder.convert(value5);
    dynamicSize += _type.length;
    final value6 = object.work;
    final _work = BinaryWriter.utf8Encoder.convert(value6);
    dynamicSize += _work.length;
    final size = dynamicSize + 58;

    rawObj.buffer = alloc(size);
    rawObj.buffer_length = size;
    final buffer = bufAsBytes(rawObj.buffer, size);
    final writer = BinaryWriter(buffer, 58);
    writer.writeBytes(offsets[0], _by);
    writer.writeDateTime(offsets[1], _date);
    writer.writeBytes(offsets[2], _reason);
    writer.writeBytes(offsets[3], _registrationDate);
    writer.writeBytes(offsets[4], _sanction);
    writer.writeBytes(offsets[5], _type);
    writer.writeBytes(offsets[6], _work);
  }

  @override
  SchoolLifeSanction deserialize(IsarCollection<SchoolLifeSanction> collection,
      int id, BinaryReader reader, List<int> offsets) {
    final object = SchoolLifeSanction(
      by: reader.readString(offsets[0]),
      date: reader.readDateTime(offsets[1]),
      reason: reader.readString(offsets[2]),
      registrationDate: reader.readString(offsets[3]),
      sanction: reader.readString(offsets[4]),
      type: reader.readString(offsets[5]),
      work: reader.readString(offsets[6]),
    );
    object.id = id;
    return object;
  }

  @override
  P deserializeProperty<P>(
      int id, BinaryReader reader, int propertyIndex, int offset) {
    switch (propertyIndex) {
      case -1:
        return id as P;
      case 0:
        return (reader.readString(offset)) as P;
      case 1:
        return (reader.readDateTime(offset)) as P;
      case 2:
        return (reader.readString(offset)) as P;
      case 3:
        return (reader.readString(offset)) as P;
      case 4:
        return (reader.readString(offset)) as P;
      case 5:
        return (reader.readString(offset)) as P;
      case 6:
        return (reader.readString(offset)) as P;
      default:
        throw 'Illegal propertyIndex';
    }
  }
}

extension SchoolLifeSanctionQueryWhereSort
    on QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QWhere> {
  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterWhere> anyId() {
    return addWhereClauseInternal(const WhereClause(indexName: null));
  }
}

extension SchoolLifeSanctionQueryWhere
    on QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QWhereClause> {
  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterWhereClause>
      idEqualTo(int? id) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [id],
      includeLower: true,
      upper: [id],
      includeUpper: true,
    ));
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterWhereClause>
      idNotEqualTo(int? id) {
    if (whereSortInternal == Sort.asc) {
      return addWhereClauseInternal(WhereClause(
        indexName: null,
        upper: [id],
        includeUpper: false,
      )).addWhereClauseInternal(WhereClause(
        indexName: null,
        lower: [id],
        includeLower: false,
      ));
    } else {
      return addWhereClauseInternal(WhereClause(
        indexName: null,
        lower: [id],
        includeLower: false,
      )).addWhereClauseInternal(WhereClause(
        indexName: null,
        upper: [id],
        includeUpper: false,
      ));
    }
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterWhereClause>
      idGreaterThan(
    int? id, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [id],
      includeLower: include,
    ));
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterWhereClause>
      idLessThan(
    int? id, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      upper: [id],
      includeUpper: include,
    ));
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterWhereClause>
      idBetween(
    int? lowerId,
    int? upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [lowerId],
      includeLower: includeLower,
      upper: [upperId],
      includeUpper: includeUpper,
    ));
  }
}

extension SchoolLifeSanctionQueryFilter
    on QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QFilterCondition> {
  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterFilterCondition>
      byEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'by',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterFilterCondition>
      byGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'by',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterFilterCondition>
      byLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'by',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterFilterCondition>
      byBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'by',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterFilterCondition>
      byStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'by',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterFilterCondition>
      byEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'by',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterFilterCondition>
      byContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'by',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterFilterCondition>
      byMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'by',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterFilterCondition>
      dateEqualTo(DateTime value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'date',
      value: value,
    ));
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterFilterCondition>
      dateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'date',
      value: value,
    ));
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterFilterCondition>
      dateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'date',
      value: value,
    ));
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterFilterCondition>
      dateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'date',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterFilterCondition>
      idIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'id',
      value: null,
    ));
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterFilterCondition>
      idEqualTo(int? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterFilterCondition>
      idGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterFilterCondition>
      idLessThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterFilterCondition>
      idBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'id',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterFilterCondition>
      reasonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'reason',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterFilterCondition>
      reasonGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'reason',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterFilterCondition>
      reasonLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'reason',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterFilterCondition>
      reasonBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'reason',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterFilterCondition>
      reasonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'reason',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterFilterCondition>
      reasonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'reason',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterFilterCondition>
      reasonContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'reason',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterFilterCondition>
      reasonMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'reason',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterFilterCondition>
      registrationDateEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'registrationDate',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterFilterCondition>
      registrationDateGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'registrationDate',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterFilterCondition>
      registrationDateLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'registrationDate',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterFilterCondition>
      registrationDateBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'registrationDate',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterFilterCondition>
      registrationDateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'registrationDate',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterFilterCondition>
      registrationDateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'registrationDate',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterFilterCondition>
      registrationDateContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'registrationDate',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterFilterCondition>
      registrationDateMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'registrationDate',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterFilterCondition>
      sanctionEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'sanction',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterFilterCondition>
      sanctionGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'sanction',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterFilterCondition>
      sanctionLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'sanction',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterFilterCondition>
      sanctionBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'sanction',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterFilterCondition>
      sanctionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'sanction',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterFilterCondition>
      sanctionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'sanction',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterFilterCondition>
      sanctionContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'sanction',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterFilterCondition>
      sanctionMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'sanction',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterFilterCondition>
      typeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'type',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterFilterCondition>
      typeGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'type',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterFilterCondition>
      typeLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'type',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterFilterCondition>
      typeBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'type',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterFilterCondition>
      typeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'type',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterFilterCondition>
      typeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'type',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterFilterCondition>
      typeContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'type',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterFilterCondition>
      typeMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'type',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterFilterCondition>
      workEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'work',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterFilterCondition>
      workGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'work',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterFilterCondition>
      workLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'work',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterFilterCondition>
      workBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'work',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterFilterCondition>
      workStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'work',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterFilterCondition>
      workEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'work',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterFilterCondition>
      workContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'work',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterFilterCondition>
      workMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'work',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }
}

extension SchoolLifeSanctionQueryWhereSortBy
    on QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QSortBy> {
  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterSortBy>
      sortByBy() {
    return addSortByInternal('by', Sort.asc);
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterSortBy>
      sortByByDesc() {
    return addSortByInternal('by', Sort.desc);
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterSortBy>
      sortByDate() {
    return addSortByInternal('date', Sort.asc);
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterSortBy>
      sortByDateDesc() {
    return addSortByInternal('date', Sort.desc);
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterSortBy>
      sortById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterSortBy>
      sortByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterSortBy>
      sortByReason() {
    return addSortByInternal('reason', Sort.asc);
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterSortBy>
      sortByReasonDesc() {
    return addSortByInternal('reason', Sort.desc);
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterSortBy>
      sortByRegistrationDate() {
    return addSortByInternal('registrationDate', Sort.asc);
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterSortBy>
      sortByRegistrationDateDesc() {
    return addSortByInternal('registrationDate', Sort.desc);
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterSortBy>
      sortBySanction() {
    return addSortByInternal('sanction', Sort.asc);
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterSortBy>
      sortBySanctionDesc() {
    return addSortByInternal('sanction', Sort.desc);
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterSortBy>
      sortByType() {
    return addSortByInternal('type', Sort.asc);
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterSortBy>
      sortByTypeDesc() {
    return addSortByInternal('type', Sort.desc);
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterSortBy>
      sortByWork() {
    return addSortByInternal('work', Sort.asc);
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterSortBy>
      sortByWorkDesc() {
    return addSortByInternal('work', Sort.desc);
  }
}

extension SchoolLifeSanctionQueryWhereSortThenBy
    on QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QSortThenBy> {
  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterSortBy>
      thenByBy() {
    return addSortByInternal('by', Sort.asc);
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterSortBy>
      thenByByDesc() {
    return addSortByInternal('by', Sort.desc);
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterSortBy>
      thenByDate() {
    return addSortByInternal('date', Sort.asc);
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterSortBy>
      thenByDateDesc() {
    return addSortByInternal('date', Sort.desc);
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterSortBy>
      thenById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterSortBy>
      thenByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterSortBy>
      thenByReason() {
    return addSortByInternal('reason', Sort.asc);
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterSortBy>
      thenByReasonDesc() {
    return addSortByInternal('reason', Sort.desc);
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterSortBy>
      thenByRegistrationDate() {
    return addSortByInternal('registrationDate', Sort.asc);
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterSortBy>
      thenByRegistrationDateDesc() {
    return addSortByInternal('registrationDate', Sort.desc);
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterSortBy>
      thenBySanction() {
    return addSortByInternal('sanction', Sort.asc);
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterSortBy>
      thenBySanctionDesc() {
    return addSortByInternal('sanction', Sort.desc);
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterSortBy>
      thenByType() {
    return addSortByInternal('type', Sort.asc);
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterSortBy>
      thenByTypeDesc() {
    return addSortByInternal('type', Sort.desc);
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterSortBy>
      thenByWork() {
    return addSortByInternal('work', Sort.asc);
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QAfterSortBy>
      thenByWorkDesc() {
    return addSortByInternal('work', Sort.desc);
  }
}

extension SchoolLifeSanctionQueryWhereDistinct
    on QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QDistinct> {
  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QDistinct> distinctByBy(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('by', caseSensitive: caseSensitive);
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QDistinct>
      distinctByDate() {
    return addDistinctByInternal('date');
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QDistinct>
      distinctById() {
    return addDistinctByInternal('id');
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QDistinct>
      distinctByReason({bool caseSensitive = true}) {
    return addDistinctByInternal('reason', caseSensitive: caseSensitive);
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QDistinct>
      distinctByRegistrationDate({bool caseSensitive = true}) {
    return addDistinctByInternal('registrationDate',
        caseSensitive: caseSensitive);
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QDistinct>
      distinctBySanction({bool caseSensitive = true}) {
    return addDistinctByInternal('sanction', caseSensitive: caseSensitive);
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QDistinct>
      distinctByType({bool caseSensitive = true}) {
    return addDistinctByInternal('type', caseSensitive: caseSensitive);
  }

  QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QDistinct>
      distinctByWork({bool caseSensitive = true}) {
    return addDistinctByInternal('work', caseSensitive: caseSensitive);
  }
}

extension SchoolLifeSanctionQueryProperty
    on QueryBuilder<SchoolLifeSanction, SchoolLifeSanction, QQueryProperty> {
  QueryBuilder<SchoolLifeSanction, String, QQueryOperations> byProperty() {
    return addPropertyNameInternal('by');
  }

  QueryBuilder<SchoolLifeSanction, DateTime, QQueryOperations> dateProperty() {
    return addPropertyNameInternal('date');
  }

  QueryBuilder<SchoolLifeSanction, int?, QQueryOperations> idProperty() {
    return addPropertyNameInternal('id');
  }

  QueryBuilder<SchoolLifeSanction, String, QQueryOperations> reasonProperty() {
    return addPropertyNameInternal('reason');
  }

  QueryBuilder<SchoolLifeSanction, String, QQueryOperations>
      registrationDateProperty() {
    return addPropertyNameInternal('registrationDate');
  }

  QueryBuilder<SchoolLifeSanction, String, QQueryOperations>
      sanctionProperty() {
    return addPropertyNameInternal('sanction');
  }

  QueryBuilder<SchoolLifeSanction, String, QQueryOperations> typeProperty() {
    return addPropertyNameInternal('type');
  }

  QueryBuilder<SchoolLifeSanction, String, QQueryOperations> workProperty() {
    return addPropertyNameInternal('work');
  }
}

// ignore_for_file: duplicate_ignore, non_constant_identifier_names, invalid_use_of_protected_member

extension GetSchoolLifeTicketCollection on Isar {
  IsarCollection<SchoolLifeTicket> get schoolLifeTickets {
    return getCollection('SchoolLifeTicket');
  }
}

final SchoolLifeTicketSchema = CollectionSchema(
  name: 'SchoolLifeTicket',
  schema:
      '{"name":"SchoolLifeTicket","properties":[{"name":"date","type":"Long"},{"name":"displayDate","type":"String"},{"name":"duration","type":"String"},{"name":"isJustified","type":"Byte"},{"name":"reason","type":"String"},{"name":"type","type":"String"}],"indexes":[],"links":[]}',
  adapter: const _SchoolLifeTicketAdapter(),
  idName: 'id',
  propertyIds: {
    'date': 0,
    'displayDate': 1,
    'duration': 2,
    'isJustified': 3,
    'reason': 4,
    'type': 5
  },
  indexIds: {},
  indexTypes: {},
  linkIds: {},
  backlinkIds: {},
  linkedCollections: [],
  getId: (obj) => obj.id,
  setId: (obj, id) => obj.id = id,
  getLinks: (obj) => [],
  version: 1,
);

class _SchoolLifeTicketAdapter extends IsarTypeAdapter<SchoolLifeTicket> {
  const _SchoolLifeTicketAdapter();

  @override
  void serialize(
      IsarCollection<SchoolLifeTicket> collection,
      IsarRawObject rawObj,
      SchoolLifeTicket object,
      List<int> offsets,
      AdapterAlloc alloc) {
    var dynamicSize = 0;
    final value0 = object.date;
    final _date = value0;
    final value1 = object.displayDate;
    final _displayDate = BinaryWriter.utf8Encoder.convert(value1);
    dynamicSize += _displayDate.length;
    final value2 = object.duration;
    final _duration = BinaryWriter.utf8Encoder.convert(value2);
    dynamicSize += _duration.length;
    final value3 = object.isJustified;
    final _isJustified = value3;
    final value4 = object.reason;
    final _reason = BinaryWriter.utf8Encoder.convert(value4);
    dynamicSize += _reason.length;
    final value5 = object.type;
    final _type = BinaryWriter.utf8Encoder.convert(value5);
    dynamicSize += _type.length;
    final size = dynamicSize + 43;

    rawObj.buffer = alloc(size);
    rawObj.buffer_length = size;
    final buffer = bufAsBytes(rawObj.buffer, size);
    final writer = BinaryWriter(buffer, 43);
    writer.writeDateTime(offsets[0], _date);
    writer.writeBytes(offsets[1], _displayDate);
    writer.writeBytes(offsets[2], _duration);
    writer.writeBool(offsets[3], _isJustified);
    writer.writeBytes(offsets[4], _reason);
    writer.writeBytes(offsets[5], _type);
  }

  @override
  SchoolLifeTicket deserialize(IsarCollection<SchoolLifeTicket> collection,
      int id, BinaryReader reader, List<int> offsets) {
    final object = SchoolLifeTicket(
      date: reader.readDateTime(offsets[0]),
      displayDate: reader.readString(offsets[1]),
      duration: reader.readString(offsets[2]),
      isJustified: reader.readBool(offsets[3]),
      reason: reader.readString(offsets[4]),
      type: reader.readString(offsets[5]),
    );
    object.id = id;
    return object;
  }

  @override
  P deserializeProperty<P>(
      int id, BinaryReader reader, int propertyIndex, int offset) {
    switch (propertyIndex) {
      case -1:
        return id as P;
      case 0:
        return (reader.readDateTime(offset)) as P;
      case 1:
        return (reader.readString(offset)) as P;
      case 2:
        return (reader.readString(offset)) as P;
      case 3:
        return (reader.readBool(offset)) as P;
      case 4:
        return (reader.readString(offset)) as P;
      case 5:
        return (reader.readString(offset)) as P;
      default:
        throw 'Illegal propertyIndex';
    }
  }
}

extension SchoolLifeTicketQueryWhereSort
    on QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QWhere> {
  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QAfterWhere> anyId() {
    return addWhereClauseInternal(const WhereClause(indexName: null));
  }
}

extension SchoolLifeTicketQueryWhere
    on QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QWhereClause> {
  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QAfterWhereClause> idEqualTo(
      int? id) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [id],
      includeLower: true,
      upper: [id],
      includeUpper: true,
    ));
  }

  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QAfterWhereClause>
      idNotEqualTo(int? id) {
    if (whereSortInternal == Sort.asc) {
      return addWhereClauseInternal(WhereClause(
        indexName: null,
        upper: [id],
        includeUpper: false,
      )).addWhereClauseInternal(WhereClause(
        indexName: null,
        lower: [id],
        includeLower: false,
      ));
    } else {
      return addWhereClauseInternal(WhereClause(
        indexName: null,
        lower: [id],
        includeLower: false,
      )).addWhereClauseInternal(WhereClause(
        indexName: null,
        upper: [id],
        includeUpper: false,
      ));
    }
  }

  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QAfterWhereClause>
      idGreaterThan(
    int? id, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [id],
      includeLower: include,
    ));
  }

  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QAfterWhereClause>
      idLessThan(
    int? id, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      upper: [id],
      includeUpper: include,
    ));
  }

  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QAfterWhereClause> idBetween(
    int? lowerId,
    int? upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [lowerId],
      includeLower: includeLower,
      upper: [upperId],
      includeUpper: includeUpper,
    ));
  }
}

extension SchoolLifeTicketQueryFilter
    on QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QFilterCondition> {
  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QAfterFilterCondition>
      dateEqualTo(DateTime value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'date',
      value: value,
    ));
  }

  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QAfterFilterCondition>
      dateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'date',
      value: value,
    ));
  }

  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QAfterFilterCondition>
      dateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'date',
      value: value,
    ));
  }

  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QAfterFilterCondition>
      dateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'date',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QAfterFilterCondition>
      displayDateEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'displayDate',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QAfterFilterCondition>
      displayDateGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'displayDate',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QAfterFilterCondition>
      displayDateLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'displayDate',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QAfterFilterCondition>
      displayDateBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'displayDate',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QAfterFilterCondition>
      displayDateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'displayDate',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QAfterFilterCondition>
      displayDateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'displayDate',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QAfterFilterCondition>
      displayDateContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'displayDate',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QAfterFilterCondition>
      displayDateMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'displayDate',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QAfterFilterCondition>
      durationEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'duration',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QAfterFilterCondition>
      durationGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'duration',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QAfterFilterCondition>
      durationLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'duration',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QAfterFilterCondition>
      durationBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'duration',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QAfterFilterCondition>
      durationStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'duration',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QAfterFilterCondition>
      durationEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'duration',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QAfterFilterCondition>
      durationContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'duration',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QAfterFilterCondition>
      durationMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'duration',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QAfterFilterCondition>
      idIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'id',
      value: null,
    ));
  }

  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QAfterFilterCondition>
      idEqualTo(int? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QAfterFilterCondition>
      idGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QAfterFilterCondition>
      idLessThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QAfterFilterCondition>
      idBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'id',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QAfterFilterCondition>
      isJustifiedEqualTo(bool value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'isJustified',
      value: value,
    ));
  }

  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QAfterFilterCondition>
      reasonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'reason',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QAfterFilterCondition>
      reasonGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'reason',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QAfterFilterCondition>
      reasonLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'reason',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QAfterFilterCondition>
      reasonBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'reason',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QAfterFilterCondition>
      reasonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'reason',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QAfterFilterCondition>
      reasonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'reason',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QAfterFilterCondition>
      reasonContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'reason',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QAfterFilterCondition>
      reasonMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'reason',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QAfterFilterCondition>
      typeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'type',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QAfterFilterCondition>
      typeGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'type',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QAfterFilterCondition>
      typeLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'type',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QAfterFilterCondition>
      typeBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'type',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QAfterFilterCondition>
      typeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'type',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QAfterFilterCondition>
      typeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'type',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QAfterFilterCondition>
      typeContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'type',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QAfterFilterCondition>
      typeMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'type',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }
}

extension SchoolLifeTicketQueryWhereSortBy
    on QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QSortBy> {
  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QAfterSortBy> sortByDate() {
    return addSortByInternal('date', Sort.asc);
  }

  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QAfterSortBy>
      sortByDateDesc() {
    return addSortByInternal('date', Sort.desc);
  }

  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QAfterSortBy>
      sortByDisplayDate() {
    return addSortByInternal('displayDate', Sort.asc);
  }

  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QAfterSortBy>
      sortByDisplayDateDesc() {
    return addSortByInternal('displayDate', Sort.desc);
  }

  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QAfterSortBy>
      sortByDuration() {
    return addSortByInternal('duration', Sort.asc);
  }

  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QAfterSortBy>
      sortByDurationDesc() {
    return addSortByInternal('duration', Sort.desc);
  }

  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QAfterSortBy>
      sortByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QAfterSortBy>
      sortByIsJustified() {
    return addSortByInternal('isJustified', Sort.asc);
  }

  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QAfterSortBy>
      sortByIsJustifiedDesc() {
    return addSortByInternal('isJustified', Sort.desc);
  }

  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QAfterSortBy>
      sortByReason() {
    return addSortByInternal('reason', Sort.asc);
  }

  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QAfterSortBy>
      sortByReasonDesc() {
    return addSortByInternal('reason', Sort.desc);
  }

  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QAfterSortBy> sortByType() {
    return addSortByInternal('type', Sort.asc);
  }

  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QAfterSortBy>
      sortByTypeDesc() {
    return addSortByInternal('type', Sort.desc);
  }
}

extension SchoolLifeTicketQueryWhereSortThenBy
    on QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QSortThenBy> {
  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QAfterSortBy> thenByDate() {
    return addSortByInternal('date', Sort.asc);
  }

  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QAfterSortBy>
      thenByDateDesc() {
    return addSortByInternal('date', Sort.desc);
  }

  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QAfterSortBy>
      thenByDisplayDate() {
    return addSortByInternal('displayDate', Sort.asc);
  }

  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QAfterSortBy>
      thenByDisplayDateDesc() {
    return addSortByInternal('displayDate', Sort.desc);
  }

  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QAfterSortBy>
      thenByDuration() {
    return addSortByInternal('duration', Sort.asc);
  }

  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QAfterSortBy>
      thenByDurationDesc() {
    return addSortByInternal('duration', Sort.desc);
  }

  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QAfterSortBy>
      thenByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QAfterSortBy>
      thenByIsJustified() {
    return addSortByInternal('isJustified', Sort.asc);
  }

  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QAfterSortBy>
      thenByIsJustifiedDesc() {
    return addSortByInternal('isJustified', Sort.desc);
  }

  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QAfterSortBy>
      thenByReason() {
    return addSortByInternal('reason', Sort.asc);
  }

  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QAfterSortBy>
      thenByReasonDesc() {
    return addSortByInternal('reason', Sort.desc);
  }

  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QAfterSortBy> thenByType() {
    return addSortByInternal('type', Sort.asc);
  }

  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QAfterSortBy>
      thenByTypeDesc() {
    return addSortByInternal('type', Sort.desc);
  }
}

extension SchoolLifeTicketQueryWhereDistinct
    on QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QDistinct> {
  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QDistinct> distinctByDate() {
    return addDistinctByInternal('date');
  }

  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QDistinct>
      distinctByDisplayDate({bool caseSensitive = true}) {
    return addDistinctByInternal('displayDate', caseSensitive: caseSensitive);
  }

  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QDistinct>
      distinctByDuration({bool caseSensitive = true}) {
    return addDistinctByInternal('duration', caseSensitive: caseSensitive);
  }

  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QDistinct> distinctById() {
    return addDistinctByInternal('id');
  }

  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QDistinct>
      distinctByIsJustified() {
    return addDistinctByInternal('isJustified');
  }

  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QDistinct> distinctByReason(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('reason', caseSensitive: caseSensitive);
  }

  QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QDistinct> distinctByType(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('type', caseSensitive: caseSensitive);
  }
}

extension SchoolLifeTicketQueryProperty
    on QueryBuilder<SchoolLifeTicket, SchoolLifeTicket, QQueryProperty> {
  QueryBuilder<SchoolLifeTicket, DateTime, QQueryOperations> dateProperty() {
    return addPropertyNameInternal('date');
  }

  QueryBuilder<SchoolLifeTicket, String, QQueryOperations>
      displayDateProperty() {
    return addPropertyNameInternal('displayDate');
  }

  QueryBuilder<SchoolLifeTicket, String, QQueryOperations> durationProperty() {
    return addPropertyNameInternal('duration');
  }

  QueryBuilder<SchoolLifeTicket, int?, QQueryOperations> idProperty() {
    return addPropertyNameInternal('id');
  }

  QueryBuilder<SchoolLifeTicket, bool, QQueryOperations> isJustifiedProperty() {
    return addPropertyNameInternal('isJustified');
  }

  QueryBuilder<SchoolLifeTicket, String, QQueryOperations> reasonProperty() {
    return addPropertyNameInternal('reason');
  }

  QueryBuilder<SchoolLifeTicket, String, QQueryOperations> typeProperty() {
    return addPropertyNameInternal('type');
  }
}
