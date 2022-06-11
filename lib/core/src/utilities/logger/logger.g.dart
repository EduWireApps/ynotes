// GENERATED CODE - DO NOT MODIFY BY HAND

part of logger;

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, unused_local_variable

extension GetLogCollection on Isar {
  IsarCollection<Log> get logs => getCollection();
}

const LogSchema = CollectionSchema(
  name: 'Log',
  schema:
      '{"name":"Log","idName":"id","properties":[{"name":"category","type":"String"},{"name":"comment","type":"String"},{"name":"date","type":"Long"},{"name":"stacktrace","type":"String"}],"indexes":[],"links":[]}',
  idName: 'id',
  propertyIds: {'category': 0, 'comment': 1, 'date': 2, 'stacktrace': 3},
  listProperties: {},
  indexIds: {},
  indexValueTypes: {},
  linkIds: {},
  backlinkLinkNames: {},
  getId: _logGetId,
  setId: _logSetId,
  getLinks: _logGetLinks,
  attachLinks: _logAttachLinks,
  serializeNative: _logSerializeNative,
  deserializeNative: _logDeserializeNative,
  deserializePropNative: _logDeserializePropNative,
  serializeWeb: _logSerializeWeb,
  deserializeWeb: _logDeserializeWeb,
  deserializePropWeb: _logDeserializePropWeb,
  version: 3,
);

int? _logGetId(Log object) {
  if (object.id == Isar.autoIncrement) {
    return null;
  } else {
    return object.id;
  }
}

void _logSetId(Log object, int id) {
  object.id = id;
}

List<IsarLinkBase> _logGetLinks(Log object) {
  return [];
}

void _logSerializeNative(IsarCollection<Log> collection, IsarRawObject rawObj,
    Log object, int staticSize, List<int> offsets, AdapterAlloc alloc) {
  var dynamicSize = 0;
  final value0 = object.category;
  final _category = IsarBinaryWriter.utf8Encoder.convert(value0);
  dynamicSize += (_category.length) as int;
  final value1 = object.comment;
  final _comment = IsarBinaryWriter.utf8Encoder.convert(value1);
  dynamicSize += (_comment.length) as int;
  final value2 = object.date;
  final _date = value2;
  final value3 = object.stacktrace;
  IsarUint8List? _stacktrace;
  if (value3 != null) {
    _stacktrace = IsarBinaryWriter.utf8Encoder.convert(value3);
  }
  dynamicSize += (_stacktrace?.length ?? 0) as int;
  final size = staticSize + dynamicSize;

  rawObj.buffer = alloc(size);
  rawObj.buffer_length = size;
  final buffer = IsarNative.bufAsBytes(rawObj.buffer, size);
  final writer = IsarBinaryWriter(buffer, staticSize);
  writer.writeBytes(offsets[0], _category);
  writer.writeBytes(offsets[1], _comment);
  writer.writeDateTime(offsets[2], _date);
  writer.writeBytes(offsets[3], _stacktrace);
}

Log _logDeserializeNative(IsarCollection<Log> collection, int id,
    IsarBinaryReader reader, List<int> offsets) {
  final object = Log(
    category: reader.readString(offsets[0]),
    comment: reader.readString(offsets[1]),
    stacktrace: reader.readStringOrNull(offsets[3]),
  );
  object.id = id;
  return object;
}

P _logDeserializePropNative<P>(
    int id, IsarBinaryReader reader, int propertyIndex, int offset) {
  switch (propertyIndex) {
    case -1:
      return id as P;
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw 'Illegal propertyIndex';
  }
}

dynamic _logSerializeWeb(IsarCollection<Log> collection, Log object) {
  final jsObj = IsarNative.newJsObject();
  IsarNative.jsObjectSet(jsObj, 'category', object.category);
  IsarNative.jsObjectSet(jsObj, 'comment', object.comment);
  IsarNative.jsObjectSet(
      jsObj, 'date', object.date.toUtc().millisecondsSinceEpoch);
  IsarNative.jsObjectSet(jsObj, 'id', object.id);
  IsarNative.jsObjectSet(jsObj, 'stacktrace', object.stacktrace);
  return jsObj;
}

Log _logDeserializeWeb(IsarCollection<Log> collection, dynamic jsObj) {
  final object = Log(
    category: IsarNative.jsObjectGet(jsObj, 'category') ?? '',
    comment: IsarNative.jsObjectGet(jsObj, 'comment') ?? '',
    stacktrace: IsarNative.jsObjectGet(jsObj, 'stacktrace'),
  );
  object.id = IsarNative.jsObjectGet(jsObj, 'id');
  return object;
}

P _logDeserializePropWeb<P>(Object jsObj, String propertyName) {
  switch (propertyName) {
    case 'category':
      return (IsarNative.jsObjectGet(jsObj, 'category') ?? '') as P;
    case 'comment':
      return (IsarNative.jsObjectGet(jsObj, 'comment') ?? '') as P;
    case 'date':
      return (IsarNative.jsObjectGet(jsObj, 'date') != null
          ? DateTime.fromMillisecondsSinceEpoch(
                  IsarNative.jsObjectGet(jsObj, 'date'),
                  isUtc: true)
              .toLocal()
          : DateTime.fromMillisecondsSinceEpoch(0)) as P;
    case 'id':
      return (IsarNative.jsObjectGet(jsObj, 'id')) as P;
    case 'stacktrace':
      return (IsarNative.jsObjectGet(jsObj, 'stacktrace')) as P;
    default:
      throw 'Illegal propertyName';
  }
}

void _logAttachLinks(IsarCollection col, int id, Log object) {}

extension LogQueryWhereSort on QueryBuilder<Log, Log, QWhere> {
  QueryBuilder<Log, Log, QAfterWhere> anyId() {
    return addWhereClauseInternal(const IdWhereClause.any());
  }
}

extension LogQueryWhere on QueryBuilder<Log, Log, QWhereClause> {
  QueryBuilder<Log, Log, QAfterWhereClause> idEqualTo(int id) {
    return addWhereClauseInternal(IdWhereClause.between(
      lower: id,
      includeLower: true,
      upper: id,
      includeUpper: true,
    ));
  }

  QueryBuilder<Log, Log, QAfterWhereClause> idNotEqualTo(int id) {
    if (whereSortInternal == Sort.asc) {
      return addWhereClauseInternal(
        IdWhereClause.lessThan(upper: id, includeUpper: false),
      ).addWhereClauseInternal(
        IdWhereClause.greaterThan(lower: id, includeLower: false),
      );
    } else {
      return addWhereClauseInternal(
        IdWhereClause.greaterThan(lower: id, includeLower: false),
      ).addWhereClauseInternal(
        IdWhereClause.lessThan(upper: id, includeUpper: false),
      );
    }
  }

  QueryBuilder<Log, Log, QAfterWhereClause> idGreaterThan(int id,
      {bool include = false}) {
    return addWhereClauseInternal(
      IdWhereClause.greaterThan(lower: id, includeLower: include),
    );
  }

  QueryBuilder<Log, Log, QAfterWhereClause> idLessThan(int id,
      {bool include = false}) {
    return addWhereClauseInternal(
      IdWhereClause.lessThan(upper: id, includeUpper: include),
    );
  }

  QueryBuilder<Log, Log, QAfterWhereClause> idBetween(
    int lowerId,
    int upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addWhereClauseInternal(IdWhereClause.between(
      lower: lowerId,
      includeLower: includeLower,
      upper: upperId,
      includeUpper: includeUpper,
    ));
  }
}

extension LogQueryFilter on QueryBuilder<Log, Log, QFilterCondition> {
  QueryBuilder<Log, Log, QAfterFilterCondition> categoryEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'category',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> categoryGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'category',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> categoryLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'category',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> categoryBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'category',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> categoryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'category',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> categoryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'category',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> categoryContains(String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'category',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> categoryMatches(String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'category',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> commentEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'comment',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> commentGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'comment',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> commentLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'comment',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> commentBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'comment',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> commentStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'comment',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> commentEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'comment',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> commentContains(String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'comment',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> commentMatches(String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'comment',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> dateEqualTo(DateTime value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'date',
      value: value,
    ));
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> dateGreaterThan(
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

  QueryBuilder<Log, Log, QAfterFilterCondition> dateLessThan(
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

  QueryBuilder<Log, Log, QAfterFilterCondition> dateBetween(
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

  QueryBuilder<Log, Log, QAfterFilterCondition> idIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'id',
      value: null,
    ));
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> idEqualTo(int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> idGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> idLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> idBetween(
    int lower,
    int upper, {
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

  QueryBuilder<Log, Log, QAfterFilterCondition> stacktraceIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'stacktrace',
      value: null,
    ));
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> stacktraceEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'stacktrace',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> stacktraceGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'stacktrace',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> stacktraceLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'stacktrace',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> stacktraceBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'stacktrace',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> stacktraceStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'stacktrace',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> stacktraceEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'stacktrace',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> stacktraceContains(String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'stacktrace',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Log, Log, QAfterFilterCondition> stacktraceMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'stacktrace',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }
}

extension LogQueryLinks on QueryBuilder<Log, Log, QFilterCondition> {}

extension LogQueryWhereSortBy on QueryBuilder<Log, Log, QSortBy> {
  QueryBuilder<Log, Log, QAfterSortBy> sortByCategory() {
    return addSortByInternal('category', Sort.asc);
  }

  QueryBuilder<Log, Log, QAfterSortBy> sortByCategoryDesc() {
    return addSortByInternal('category', Sort.desc);
  }

  QueryBuilder<Log, Log, QAfterSortBy> sortByComment() {
    return addSortByInternal('comment', Sort.asc);
  }

  QueryBuilder<Log, Log, QAfterSortBy> sortByCommentDesc() {
    return addSortByInternal('comment', Sort.desc);
  }

  QueryBuilder<Log, Log, QAfterSortBy> sortByDate() {
    return addSortByInternal('date', Sort.asc);
  }

  QueryBuilder<Log, Log, QAfterSortBy> sortByDateDesc() {
    return addSortByInternal('date', Sort.desc);
  }

  QueryBuilder<Log, Log, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<Log, Log, QAfterSortBy> sortByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<Log, Log, QAfterSortBy> sortByStacktrace() {
    return addSortByInternal('stacktrace', Sort.asc);
  }

  QueryBuilder<Log, Log, QAfterSortBy> sortByStacktraceDesc() {
    return addSortByInternal('stacktrace', Sort.desc);
  }
}

extension LogQueryWhereSortThenBy on QueryBuilder<Log, Log, QSortThenBy> {
  QueryBuilder<Log, Log, QAfterSortBy> thenByCategory() {
    return addSortByInternal('category', Sort.asc);
  }

  QueryBuilder<Log, Log, QAfterSortBy> thenByCategoryDesc() {
    return addSortByInternal('category', Sort.desc);
  }

  QueryBuilder<Log, Log, QAfterSortBy> thenByComment() {
    return addSortByInternal('comment', Sort.asc);
  }

  QueryBuilder<Log, Log, QAfterSortBy> thenByCommentDesc() {
    return addSortByInternal('comment', Sort.desc);
  }

  QueryBuilder<Log, Log, QAfterSortBy> thenByDate() {
    return addSortByInternal('date', Sort.asc);
  }

  QueryBuilder<Log, Log, QAfterSortBy> thenByDateDesc() {
    return addSortByInternal('date', Sort.desc);
  }

  QueryBuilder<Log, Log, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<Log, Log, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<Log, Log, QAfterSortBy> thenByStacktrace() {
    return addSortByInternal('stacktrace', Sort.asc);
  }

  QueryBuilder<Log, Log, QAfterSortBy> thenByStacktraceDesc() {
    return addSortByInternal('stacktrace', Sort.desc);
  }
}

extension LogQueryWhereDistinct on QueryBuilder<Log, Log, QDistinct> {
  QueryBuilder<Log, Log, QDistinct> distinctByCategory(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('category', caseSensitive: caseSensitive);
  }

  QueryBuilder<Log, Log, QDistinct> distinctByComment(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('comment', caseSensitive: caseSensitive);
  }

  QueryBuilder<Log, Log, QDistinct> distinctByDate() {
    return addDistinctByInternal('date');
  }

  QueryBuilder<Log, Log, QDistinct> distinctById() {
    return addDistinctByInternal('id');
  }

  QueryBuilder<Log, Log, QDistinct> distinctByStacktrace(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('stacktrace', caseSensitive: caseSensitive);
  }
}

extension LogQueryProperty on QueryBuilder<Log, Log, QQueryProperty> {
  QueryBuilder<Log, String, QQueryOperations> categoryProperty() {
    return addPropertyNameInternal('category');
  }

  QueryBuilder<Log, String, QQueryOperations> commentProperty() {
    return addPropertyNameInternal('comment');
  }

  QueryBuilder<Log, DateTime, QQueryOperations> dateProperty() {
    return addPropertyNameInternal('date');
  }

  QueryBuilder<Log, int?, QQueryOperations> idProperty() {
    return addPropertyNameInternal('id');
  }

  QueryBuilder<Log, String?, QQueryOperations> stacktraceProperty() {
    return addPropertyNameInternal('stacktrace');
  }
}