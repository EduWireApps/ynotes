// ignore_for_file: unused_import, implementation_imports

import 'dart:ffi';
import 'dart:convert';
import 'dart:isolate';
import 'dart:typed_data';
import 'dart:io';
import 'package:isar/isar.dart';
import 'package:isar/src/isar_native.dart';
import 'package:isar/src/query_builder.dart';
import 'package:ffi/ffi.dart';
import 'package:path/path.dart' as p;
import 'core/logic/shared/models.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/widgets.dart';

const _utf8Encoder = Utf8Encoder();

final _schema =
    '[{"name":"Document","idProperty":"dbId","properties":[{"name":"dbId","type":3},{"name":"documentName","type":5},{"name":"id","type":5},{"name":"type","type":5},{"name":"length","type":3}],"indexes":[],"links":[]}]';

Future<Isar> openIsar(
    {String name = 'isar',
    String? directory,
    int maxSize = 1000000000,
    Uint8List? encryptionKey}) async {
  final path = await _preparePath(directory);
  return openIsarInternal(
      name: name,
      directory: path,
      maxSize: maxSize,
      encryptionKey: encryptionKey,
      schema: _schema,
      getCollections: (isar) {
        final collectionPtrPtr = malloc<Pointer>();
        final propertyOffsetsPtr = malloc<Uint32>(5);
        final propertyOffsets = propertyOffsetsPtr.asTypedList(5);
        final collections = <String, IsarCollection>{};
        nCall(IC.isar_get_collection(isar.ptr, collectionPtrPtr, 0));
        IC.isar_get_property_offsets(
            collectionPtrPtr.value, propertyOffsetsPtr);
        collections['Document'] = IsarCollectionImpl<Document>(
          isar: isar,
          adapter: _DocumentAdapter(),
          ptr: collectionPtrPtr.value,
          propertyOffsets: propertyOffsets.sublist(0, 5),
          propertyIds: {
            'dbId': 0,
            'documentName': 1,
            'id': 2,
            'type': 3,
            'length': 4
          },
          indexIds: {},
          linkIds: {},
          backlinkIds: {},
          getId: (obj) => obj.dbId,
          setId: (obj, id) => obj.dbId = id,
        );
        malloc.free(propertyOffsetsPtr);
        malloc.free(collectionPtrPtr);

        return collections;
      });
}

Future<String> _preparePath(String? path) async {
  if (path == null || p.isRelative(path)) {
    WidgetsFlutterBinding.ensureInitialized();
    final dir = await getApplicationDocumentsDirectory();
    return p.join(dir.path, path ?? 'isar');
  } else {
    return path;
  }
}

class _DocumentAdapter extends TypeAdapter<Document> {
  @override
  int serialize(IsarCollectionImpl<Document> collection, RawObject rawObj,
      Document object, List<int> offsets,
      [int? existingBufferSize]) {
    var dynamicSize = 0;
    final value0 = object.dbId;
    final _dbId = value0;
    final value1 = object.documentName;
    Uint8List? _documentName;
    if (value1 != null) {
      _documentName = _utf8Encoder.convert(value1);
    }
    dynamicSize += _documentName?.length ?? 0;
    final value2 = object.id;
    Uint8List? _id;
    if (value2 != null) {
      _id = _utf8Encoder.convert(value2);
    }
    dynamicSize += _id?.length ?? 0;
    final value3 = object.type;
    Uint8List? _type;
    if (value3 != null) {
      _type = _utf8Encoder.convert(value3);
    }
    dynamicSize += _type?.length ?? 0;
    final value4 = object.length;
    final _length = value4;
    final size = dynamicSize + 42;

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
    final writer = BinaryWriter(buffer, 42);
    writer.writeLong(offsets[0], _dbId);
    writer.writeBytes(offsets[1], _documentName);
    writer.writeBytes(offsets[2], _id);
    writer.writeBytes(offsets[3], _type);
    writer.writeLong(offsets[4], _length);
    return bufferSize;
  }

  @override
  Document deserialize(IsarCollectionImpl<Document> collection,
      BinaryReader reader, List<int> offsets) {
    final object = Document();
    object.dbId = reader.readLongOrNull(offsets[0]);
    object.documentName = reader.readStringOrNull(offsets[1]);
    object.id = reader.readStringOrNull(offsets[2]);
    object.type = reader.readStringOrNull(offsets[3]);
    object.length = reader.readLongOrNull(offsets[4]);
    return object;
  }

  @override
  P deserializeProperty<P>(BinaryReader reader, int propertyIndex, int offset) {
    switch (propertyIndex) {
      case 0:
        return (reader.readLongOrNull(offset)) as P;
      case 1:
        return (reader.readStringOrNull(offset)) as P;
      case 2:
        return (reader.readStringOrNull(offset)) as P;
      case 3:
        return (reader.readStringOrNull(offset)) as P;
      case 4:
        return (reader.readLongOrNull(offset)) as P;
      default:
        throw 'Illegal propertyIndex';
    }
  }
}

extension GetCollection on Isar {
  IsarCollection<Document> get documents {
    return getCollection('Document');
  }
}

extension DocumentQueryWhereSort on QueryBuilder<Document, QWhere> {
  QueryBuilder<Document, QAfterWhere> anyDbId() {
    return addWhereClause(WhereClause(indexName: 'dbId'));
  }
}

extension DocumentQueryWhere on QueryBuilder<Document, QWhereClause> {}

extension DocumentQueryFilter on QueryBuilder<Document, QFilterCondition> {
  QueryBuilder<Document, QAfterFilterCondition> dbIdIsNull() {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'dbId',
      value: null,
    ));
  }

  QueryBuilder<Document, QAfterFilterCondition> dbIdEqualTo(int? value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'dbId',
      value: value,
    ));
  }

  QueryBuilder<Document, QAfterFilterCondition> dbIdGreaterThan(int? value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Gt,
      property: 'dbId',
      value: value,
    ));
  }

  QueryBuilder<Document, QAfterFilterCondition> dbIdLessThan(int? value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Lt,
      property: 'dbId',
      value: value,
    ));
  }

  QueryBuilder<Document, QAfterFilterCondition> dbIdBetween(
      int? lower, int? upper) {
    return addFilterCondition(FilterCondition.between(
      property: 'dbId',
      lower: lower,
      upper: upper,
    ));
  }

  QueryBuilder<Document, QAfterFilterCondition> documentNameIsNull() {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'documentName',
      value: null,
    ));
  }

  QueryBuilder<Document, QAfterFilterCondition> documentNameEqualTo(
      String? value,
      {bool caseSensitive = true}) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'documentName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Document, QAfterFilterCondition> documentNameStartsWith(
      String? value,
      {bool caseSensitive = true}) {
    final convertedValue = value;
    assert(convertedValue != null, 'Null values are not allowed');
    return addFilterCondition(FilterCondition(
      type: ConditionType.StartsWith,
      property: 'documentName',
      value: convertedValue,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Document, QAfterFilterCondition> documentNameEndsWith(
      String? value,
      {bool caseSensitive = true}) {
    final convertedValue = value;
    assert(convertedValue != null, 'Null values are not allowed');
    return addFilterCondition(FilterCondition(
      type: ConditionType.EndsWith,
      property: 'documentName',
      value: convertedValue,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Document, QAfterFilterCondition> documentNameContains(
      String? value,
      {bool caseSensitive = true}) {
    final convertedValue = value;
    assert(convertedValue != null, 'Null values are not allowed');
    return addFilterCondition(FilterCondition(
      type: ConditionType.Matches,
      property: 'documentName',
      value: '*$convertedValue*',
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Document, QAfterFilterCondition> documentNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Matches,
      property: 'documentName',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Document, QAfterFilterCondition> idIsNull() {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'id',
      value: null,
    ));
  }

  QueryBuilder<Document, QAfterFilterCondition> idEqualTo(String? value,
      {bool caseSensitive = true}) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'id',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Document, QAfterFilterCondition> idStartsWith(String? value,
      {bool caseSensitive = true}) {
    final convertedValue = value;
    assert(convertedValue != null, 'Null values are not allowed');
    return addFilterCondition(FilterCondition(
      type: ConditionType.StartsWith,
      property: 'id',
      value: convertedValue,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Document, QAfterFilterCondition> idEndsWith(String? value,
      {bool caseSensitive = true}) {
    final convertedValue = value;
    assert(convertedValue != null, 'Null values are not allowed');
    return addFilterCondition(FilterCondition(
      type: ConditionType.EndsWith,
      property: 'id',
      value: convertedValue,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Document, QAfterFilterCondition> idContains(String? value,
      {bool caseSensitive = true}) {
    final convertedValue = value;
    assert(convertedValue != null, 'Null values are not allowed');
    return addFilterCondition(FilterCondition(
      type: ConditionType.Matches,
      property: 'id',
      value: '*$convertedValue*',
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Document, QAfterFilterCondition> idMatches(String pattern,
      {bool caseSensitive = true}) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Matches,
      property: 'id',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Document, QAfterFilterCondition> typeIsNull() {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'type',
      value: null,
    ));
  }

  QueryBuilder<Document, QAfterFilterCondition> typeEqualTo(String? value,
      {bool caseSensitive = true}) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'type',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Document, QAfterFilterCondition> typeStartsWith(String? value,
      {bool caseSensitive = true}) {
    final convertedValue = value;
    assert(convertedValue != null, 'Null values are not allowed');
    return addFilterCondition(FilterCondition(
      type: ConditionType.StartsWith,
      property: 'type',
      value: convertedValue,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Document, QAfterFilterCondition> typeEndsWith(String? value,
      {bool caseSensitive = true}) {
    final convertedValue = value;
    assert(convertedValue != null, 'Null values are not allowed');
    return addFilterCondition(FilterCondition(
      type: ConditionType.EndsWith,
      property: 'type',
      value: convertedValue,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Document, QAfterFilterCondition> typeContains(String? value,
      {bool caseSensitive = true}) {
    final convertedValue = value;
    assert(convertedValue != null, 'Null values are not allowed');
    return addFilterCondition(FilterCondition(
      type: ConditionType.Matches,
      property: 'type',
      value: '*$convertedValue*',
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Document, QAfterFilterCondition> typeMatches(String pattern,
      {bool caseSensitive = true}) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Matches,
      property: 'type',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Document, QAfterFilterCondition> lengthIsNull() {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'length',
      value: null,
    ));
  }

  QueryBuilder<Document, QAfterFilterCondition> lengthEqualTo(int? value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Eq,
      property: 'length',
      value: value,
    ));
  }

  QueryBuilder<Document, QAfterFilterCondition> lengthGreaterThan(int? value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Gt,
      property: 'length',
      value: value,
    ));
  }

  QueryBuilder<Document, QAfterFilterCondition> lengthLessThan(int? value) {
    return addFilterCondition(FilterCondition(
      type: ConditionType.Lt,
      property: 'length',
      value: value,
    ));
  }

  QueryBuilder<Document, QAfterFilterCondition> lengthBetween(
      int? lower, int? upper) {
    return addFilterCondition(FilterCondition.between(
      property: 'length',
      lower: lower,
      upper: upper,
    ));
  }
}

extension DocumentQueryLinks on QueryBuilder<Document, QFilterCondition> {}

extension DocumentQueryWhereSortBy on QueryBuilder<Document, QSortBy> {
  QueryBuilder<Document, QAfterSortBy> sortByDbId() {
    return addSortByInternal('dbId', Sort.Asc);
  }

  QueryBuilder<Document, QAfterSortBy> sortByDbIdDesc() {
    return addSortByInternal('dbId', Sort.Desc);
  }

  QueryBuilder<Document, QAfterSortBy> sortByDocumentName() {
    return addSortByInternal('documentName', Sort.Asc);
  }

  QueryBuilder<Document, QAfterSortBy> sortByDocumentNameDesc() {
    return addSortByInternal('documentName', Sort.Desc);
  }

  QueryBuilder<Document, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.Asc);
  }

  QueryBuilder<Document, QAfterSortBy> sortByIdDesc() {
    return addSortByInternal('id', Sort.Desc);
  }

  QueryBuilder<Document, QAfterSortBy> sortByType() {
    return addSortByInternal('type', Sort.Asc);
  }

  QueryBuilder<Document, QAfterSortBy> sortByTypeDesc() {
    return addSortByInternal('type', Sort.Desc);
  }

  QueryBuilder<Document, QAfterSortBy> sortByLength() {
    return addSortByInternal('length', Sort.Asc);
  }

  QueryBuilder<Document, QAfterSortBy> sortByLengthDesc() {
    return addSortByInternal('length', Sort.Desc);
  }
}

extension DocumentQueryWhereSortThenBy on QueryBuilder<Document, QSortThenBy> {
  QueryBuilder<Document, QAfterSortBy> thenByDbId() {
    return addSortByInternal('dbId', Sort.Asc);
  }

  QueryBuilder<Document, QAfterSortBy> thenByDbIdDesc() {
    return addSortByInternal('dbId', Sort.Desc);
  }

  QueryBuilder<Document, QAfterSortBy> thenByDocumentName() {
    return addSortByInternal('documentName', Sort.Asc);
  }

  QueryBuilder<Document, QAfterSortBy> thenByDocumentNameDesc() {
    return addSortByInternal('documentName', Sort.Desc);
  }

  QueryBuilder<Document, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.Asc);
  }

  QueryBuilder<Document, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.Desc);
  }

  QueryBuilder<Document, QAfterSortBy> thenByType() {
    return addSortByInternal('type', Sort.Asc);
  }

  QueryBuilder<Document, QAfterSortBy> thenByTypeDesc() {
    return addSortByInternal('type', Sort.Desc);
  }

  QueryBuilder<Document, QAfterSortBy> thenByLength() {
    return addSortByInternal('length', Sort.Asc);
  }

  QueryBuilder<Document, QAfterSortBy> thenByLengthDesc() {
    return addSortByInternal('length', Sort.Desc);
  }
}

extension DocumentQueryWhereDistinct on QueryBuilder<Document, QDistinct> {
  QueryBuilder<Document, QDistinct> distinctByDbId() {
    return addDistinctByInternal('dbId');
  }

  QueryBuilder<Document, QDistinct> distinctByDocumentName(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('documentName', caseSensitive: caseSensitive);
  }

  QueryBuilder<Document, QDistinct> distinctById({bool caseSensitive = true}) {
    return addDistinctByInternal('id', caseSensitive: caseSensitive);
  }

  QueryBuilder<Document, QDistinct> distinctByType(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('type', caseSensitive: caseSensitive);
  }

  QueryBuilder<Document, QDistinct> distinctByLength() {
    return addDistinctByInternal('length');
  }
}

extension DocumentQueryProperty on QueryBuilder<Document, QQueryProperty> {
  QueryBuilder<int?, QQueryOperations> dbIdProperty() {
    return addPropertyName('dbId');
  }

  QueryBuilder<String?, QQueryOperations> documentNameProperty() {
    return addPropertyName('documentName');
  }

  QueryBuilder<String?, QQueryOperations> idProperty() {
    return addPropertyName('id');
  }

  QueryBuilder<String?, QQueryOperations> typeProperty() {
    return addPropertyName('type');
  }

  QueryBuilder<int?, QQueryOperations> lengthProperty() {
    return addPropertyName('length');
  }
}
