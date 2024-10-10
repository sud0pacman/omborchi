// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cost_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCostEntityCollection on Isar {
  IsarCollection<CostEntity> get costEntitys => this.collection();
}

const CostEntitySchema = CollectionSchema(
  name: r'CostEntity',
  id: 1485186151187202436,
  properties: {
    r'productId': PropertySchema(
      id: 0,
      name: r'productId',
      type: IsarType.long,
    ),
    r'quantity': PropertySchema(
      id: 1,
      name: r'quantity',
      type: IsarType.long,
    ),
    r'xomashyoId': PropertySchema(
      id: 2,
      name: r'xomashyoId',
      type: IsarType.long,
    )
  },
  estimateSize: _costEntityEstimateSize,
  serialize: _costEntitySerialize,
  deserialize: _costEntityDeserialize,
  deserializeProp: _costEntityDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _costEntityGetId,
  getLinks: _costEntityGetLinks,
  attach: _costEntityAttach,
  version: '3.1.0',
);

int _costEntityEstimateSize(
  CostEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _costEntitySerialize(
  CostEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.productId);
  writer.writeLong(offsets[1], object.quantity);
  writer.writeLong(offsets[2], object.xomashyoId);
}

CostEntity _costEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CostEntity(
    productId: reader.readLong(offsets[0]),
    quantity: reader.readLong(offsets[1]),
    xomashyoId: reader.readLong(offsets[2]),
  );
  object.id = id;
  return object;
}

P _costEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _costEntityGetId(CostEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _costEntityGetLinks(CostEntity object) {
  return [];
}

void _costEntityAttach(IsarCollection<dynamic> col, Id id, CostEntity object) {
  object.id = id;
}

extension CostEntityQueryWhereSort
    on QueryBuilder<CostEntity, CostEntity, QWhere> {
  QueryBuilder<CostEntity, CostEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CostEntityQueryWhere
    on QueryBuilder<CostEntity, CostEntity, QWhereClause> {
  QueryBuilder<CostEntity, CostEntity, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<CostEntity, CostEntity, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<CostEntity, CostEntity, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CostEntity, CostEntity, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CostEntity, CostEntity, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension CostEntityQueryFilter
    on QueryBuilder<CostEntity, CostEntity, QFilterCondition> {
  QueryBuilder<CostEntity, CostEntity, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CostEntity, CostEntity, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CostEntity, CostEntity, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CostEntity, CostEntity, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CostEntity, CostEntity, QAfterFilterCondition> productIdEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'productId',
        value: value,
      ));
    });
  }

  QueryBuilder<CostEntity, CostEntity, QAfterFilterCondition>
      productIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'productId',
        value: value,
      ));
    });
  }

  QueryBuilder<CostEntity, CostEntity, QAfterFilterCondition> productIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'productId',
        value: value,
      ));
    });
  }

  QueryBuilder<CostEntity, CostEntity, QAfterFilterCondition> productIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'productId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CostEntity, CostEntity, QAfterFilterCondition> quantityEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'quantity',
        value: value,
      ));
    });
  }

  QueryBuilder<CostEntity, CostEntity, QAfterFilterCondition>
      quantityGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'quantity',
        value: value,
      ));
    });
  }

  QueryBuilder<CostEntity, CostEntity, QAfterFilterCondition> quantityLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'quantity',
        value: value,
      ));
    });
  }

  QueryBuilder<CostEntity, CostEntity, QAfterFilterCondition> quantityBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'quantity',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CostEntity, CostEntity, QAfterFilterCondition> xomashyoIdEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'xomashyoId',
        value: value,
      ));
    });
  }

  QueryBuilder<CostEntity, CostEntity, QAfterFilterCondition>
      xomashyoIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'xomashyoId',
        value: value,
      ));
    });
  }

  QueryBuilder<CostEntity, CostEntity, QAfterFilterCondition>
      xomashyoIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'xomashyoId',
        value: value,
      ));
    });
  }

  QueryBuilder<CostEntity, CostEntity, QAfterFilterCondition> xomashyoIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'xomashyoId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension CostEntityQueryObject
    on QueryBuilder<CostEntity, CostEntity, QFilterCondition> {}

extension CostEntityQueryLinks
    on QueryBuilder<CostEntity, CostEntity, QFilterCondition> {}

extension CostEntityQuerySortBy
    on QueryBuilder<CostEntity, CostEntity, QSortBy> {
  QueryBuilder<CostEntity, CostEntity, QAfterSortBy> sortByProductId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productId', Sort.asc);
    });
  }

  QueryBuilder<CostEntity, CostEntity, QAfterSortBy> sortByProductIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productId', Sort.desc);
    });
  }

  QueryBuilder<CostEntity, CostEntity, QAfterSortBy> sortByQuantity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quantity', Sort.asc);
    });
  }

  QueryBuilder<CostEntity, CostEntity, QAfterSortBy> sortByQuantityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quantity', Sort.desc);
    });
  }

  QueryBuilder<CostEntity, CostEntity, QAfterSortBy> sortByXomashyoId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'xomashyoId', Sort.asc);
    });
  }

  QueryBuilder<CostEntity, CostEntity, QAfterSortBy> sortByXomashyoIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'xomashyoId', Sort.desc);
    });
  }
}

extension CostEntityQuerySortThenBy
    on QueryBuilder<CostEntity, CostEntity, QSortThenBy> {
  QueryBuilder<CostEntity, CostEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CostEntity, CostEntity, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CostEntity, CostEntity, QAfterSortBy> thenByProductId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productId', Sort.asc);
    });
  }

  QueryBuilder<CostEntity, CostEntity, QAfterSortBy> thenByProductIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productId', Sort.desc);
    });
  }

  QueryBuilder<CostEntity, CostEntity, QAfterSortBy> thenByQuantity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quantity', Sort.asc);
    });
  }

  QueryBuilder<CostEntity, CostEntity, QAfterSortBy> thenByQuantityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quantity', Sort.desc);
    });
  }

  QueryBuilder<CostEntity, CostEntity, QAfterSortBy> thenByXomashyoId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'xomashyoId', Sort.asc);
    });
  }

  QueryBuilder<CostEntity, CostEntity, QAfterSortBy> thenByXomashyoIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'xomashyoId', Sort.desc);
    });
  }
}

extension CostEntityQueryWhereDistinct
    on QueryBuilder<CostEntity, CostEntity, QDistinct> {
  QueryBuilder<CostEntity, CostEntity, QDistinct> distinctByProductId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'productId');
    });
  }

  QueryBuilder<CostEntity, CostEntity, QDistinct> distinctByQuantity() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'quantity');
    });
  }

  QueryBuilder<CostEntity, CostEntity, QDistinct> distinctByXomashyoId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'xomashyoId');
    });
  }
}

extension CostEntityQueryProperty
    on QueryBuilder<CostEntity, CostEntity, QQueryProperty> {
  QueryBuilder<CostEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CostEntity, int, QQueryOperations> productIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'productId');
    });
  }

  QueryBuilder<CostEntity, int, QQueryOperations> quantityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'quantity');
    });
  }

  QueryBuilder<CostEntity, int, QQueryOperations> xomashyoIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'xomashyoId');
    });
  }
}
