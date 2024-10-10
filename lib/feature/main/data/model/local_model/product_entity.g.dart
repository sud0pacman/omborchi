// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetProductEntityCollection on Isar {
  IsarCollection<ProductEntity> get productEntitys => this.collection();
}

const ProductEntitySchema = CollectionSchema(
  name: r'ProductEntity',
  id: 4867088266565710661,
  properties: {
    r'boyi': PropertySchema(
      id: 0,
      name: r'boyi',
      type: IsarType.long,
    ),
    r'categoryId': PropertySchema(
      id: 1,
      name: r'categoryId',
      type: IsarType.long,
    ),
    r'createdAt': PropertySchema(
      id: 2,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'description': PropertySchema(
      id: 3,
      name: r'description',
      type: IsarType.string,
    ),
    r'eni': PropertySchema(
      id: 4,
      name: r'eni',
      type: IsarType.long,
    ),
    r'foyda': PropertySchema(
      id: 5,
      name: r'foyda',
      type: IsarType.long,
    ),
    r'isVerified': PropertySchema(
      id: 6,
      name: r'isVerified',
      type: IsarType.bool,
    ),
    r'nomer': PropertySchema(
      id: 7,
      name: r'nomer',
      type: IsarType.long,
    ),
    r'pathOfPicture': PropertySchema(
      id: 8,
      name: r'pathOfPicture',
      type: IsarType.string,
    ),
    r'sotuv': PropertySchema(
      id: 9,
      name: r'sotuv',
      type: IsarType.long,
    ),
    r'updatedAt': PropertySchema(
      id: 10,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'xizmat': PropertySchema(
      id: 11,
      name: r'xizmat',
      type: IsarType.long,
    )
  },
  estimateSize: _productEntityEstimateSize,
  serialize: _productEntitySerialize,
  deserialize: _productEntityDeserialize,
  deserializeProp: _productEntityDeserializeProp,
  idName: r'id',
  indexes: {
    r'nomer': IndexSchema(
      id: -634141724045504138,
      name: r'nomer',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'nomer',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'categoryId': IndexSchema(
      id: -8798048739239305339,
      name: r'categoryId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'categoryId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _productEntityGetId,
  getLinks: _productEntityGetLinks,
  attach: _productEntityAttach,
  version: '3.1.0',
);

int _productEntityEstimateSize(
  ProductEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.description;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.pathOfPicture;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _productEntitySerialize(
  ProductEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.boyi);
  writer.writeLong(offsets[1], object.categoryId);
  writer.writeDateTime(offsets[2], object.createdAt);
  writer.writeString(offsets[3], object.description);
  writer.writeLong(offsets[4], object.eni);
  writer.writeLong(offsets[5], object.foyda);
  writer.writeBool(offsets[6], object.isVerified);
  writer.writeLong(offsets[7], object.nomer);
  writer.writeString(offsets[8], object.pathOfPicture);
  writer.writeLong(offsets[9], object.sotuv);
  writer.writeDateTime(offsets[10], object.updatedAt);
  writer.writeLong(offsets[11], object.xizmat);
}

ProductEntity _productEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ProductEntity(
    boyi: reader.readLongOrNull(offsets[0]),
    categoryId: reader.readLongOrNull(offsets[1]),
    createdAt: reader.readDateTimeOrNull(offsets[2]),
    description: reader.readStringOrNull(offsets[3]),
    eni: reader.readLongOrNull(offsets[4]),
    foyda: reader.readLongOrNull(offsets[5]),
    isVerified: reader.readBool(offsets[6]),
    nomer: reader.readLong(offsets[7]),
    pathOfPicture: reader.readStringOrNull(offsets[8]),
    sotuv: reader.readLongOrNull(offsets[9]),
    updatedAt: reader.readDateTimeOrNull(offsets[10]),
    xizmat: reader.readLongOrNull(offsets[11]),
  );
  object.id = id;
  return object;
}

P _productEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    case 2:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readLongOrNull(offset)) as P;
    case 5:
      return (reader.readLongOrNull(offset)) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readLongOrNull(offset)) as P;
    case 10:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 11:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _productEntityGetId(ProductEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _productEntityGetLinks(ProductEntity object) {
  return [];
}

void _productEntityAttach(
    IsarCollection<dynamic> col, Id id, ProductEntity object) {
  object.id = id;
}

extension ProductEntityQueryWhereSort
    on QueryBuilder<ProductEntity, ProductEntity, QWhere> {
  QueryBuilder<ProductEntity, ProductEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterWhere> anyNomer() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'nomer'),
      );
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterWhere> anyCategoryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'categoryId'),
      );
    });
  }
}

extension ProductEntityQueryWhere
    on QueryBuilder<ProductEntity, ProductEntity, QWhereClause> {
  QueryBuilder<ProductEntity, ProductEntity, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<ProductEntity, ProductEntity, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterWhereClause> idBetween(
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

  QueryBuilder<ProductEntity, ProductEntity, QAfterWhereClause> nomerEqualTo(
      int nomer) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'nomer',
        value: [nomer],
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterWhereClause> nomerNotEqualTo(
      int nomer) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'nomer',
              lower: [],
              upper: [nomer],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'nomer',
              lower: [nomer],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'nomer',
              lower: [nomer],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'nomer',
              lower: [],
              upper: [nomer],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterWhereClause>
      nomerGreaterThan(
    int nomer, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'nomer',
        lower: [nomer],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterWhereClause> nomerLessThan(
    int nomer, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'nomer',
        lower: [],
        upper: [nomer],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterWhereClause> nomerBetween(
    int lowerNomer,
    int upperNomer, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'nomer',
        lower: [lowerNomer],
        includeLower: includeLower,
        upper: [upperNomer],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterWhereClause>
      categoryIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'categoryId',
        value: [null],
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterWhereClause>
      categoryIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'categoryId',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterWhereClause>
      categoryIdEqualTo(int? categoryId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'categoryId',
        value: [categoryId],
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterWhereClause>
      categoryIdNotEqualTo(int? categoryId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'categoryId',
              lower: [],
              upper: [categoryId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'categoryId',
              lower: [categoryId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'categoryId',
              lower: [categoryId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'categoryId',
              lower: [],
              upper: [categoryId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterWhereClause>
      categoryIdGreaterThan(
    int? categoryId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'categoryId',
        lower: [categoryId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterWhereClause>
      categoryIdLessThan(
    int? categoryId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'categoryId',
        lower: [],
        upper: [categoryId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterWhereClause>
      categoryIdBetween(
    int? lowerCategoryId,
    int? upperCategoryId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'categoryId',
        lower: [lowerCategoryId],
        includeLower: includeLower,
        upper: [upperCategoryId],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ProductEntityQueryFilter
    on QueryBuilder<ProductEntity, ProductEntity, QFilterCondition> {
  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition>
      boyiIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'boyi',
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition>
      boyiIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'boyi',
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition> boyiEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'boyi',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition>
      boyiGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'boyi',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition>
      boyiLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'boyi',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition> boyiBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'boyi',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition>
      categoryIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'categoryId',
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition>
      categoryIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'categoryId',
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition>
      categoryIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'categoryId',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition>
      categoryIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'categoryId',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition>
      categoryIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'categoryId',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition>
      categoryIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'categoryId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition>
      createdAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition>
      createdAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition>
      createdAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition>
      createdAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition>
      createdAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition>
      descriptionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'description',
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition>
      descriptionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'description',
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition>
      descriptionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition>
      descriptionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition>
      descriptionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition>
      descriptionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'description',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition>
      descriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition>
      descriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition>
      descriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition>
      descriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'description',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition>
      descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition>
      descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition>
      eniIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'eni',
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition>
      eniIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'eni',
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition> eniEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'eni',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition>
      eniGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'eni',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition> eniLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'eni',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition> eniBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'eni',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition>
      foydaIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'foyda',
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition>
      foydaIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'foyda',
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition>
      foydaEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'foyda',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition>
      foydaGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'foyda',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition>
      foydaLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'foyda',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition>
      foydaBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'foyda',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition> idBetween(
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

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition>
      isVerifiedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isVerified',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition>
      nomerEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nomer',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition>
      nomerGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nomer',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition>
      nomerLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nomer',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition>
      nomerBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nomer',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition>
      pathOfPictureIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'pathOfPicture',
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition>
      pathOfPictureIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'pathOfPicture',
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition>
      pathOfPictureEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pathOfPicture',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition>
      pathOfPictureGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pathOfPicture',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition>
      pathOfPictureLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pathOfPicture',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition>
      pathOfPictureBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pathOfPicture',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition>
      pathOfPictureStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'pathOfPicture',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition>
      pathOfPictureEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'pathOfPicture',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition>
      pathOfPictureContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'pathOfPicture',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition>
      pathOfPictureMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'pathOfPicture',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition>
      pathOfPictureIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pathOfPicture',
        value: '',
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition>
      pathOfPictureIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'pathOfPicture',
        value: '',
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition>
      sotuvIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'sotuv',
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition>
      sotuvIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'sotuv',
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition>
      sotuvEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sotuv',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition>
      sotuvGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sotuv',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition>
      sotuvLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sotuv',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition>
      sotuvBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sotuv',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition>
      updatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition>
      updatedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition>
      updatedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition>
      updatedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition>
      updatedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition>
      updatedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition>
      xizmatIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'xizmat',
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition>
      xizmatIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'xizmat',
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition>
      xizmatEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'xizmat',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition>
      xizmatGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'xizmat',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition>
      xizmatLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'xizmat',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterFilterCondition>
      xizmatBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'xizmat',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ProductEntityQueryObject
    on QueryBuilder<ProductEntity, ProductEntity, QFilterCondition> {}

extension ProductEntityQueryLinks
    on QueryBuilder<ProductEntity, ProductEntity, QFilterCondition> {}

extension ProductEntityQuerySortBy
    on QueryBuilder<ProductEntity, ProductEntity, QSortBy> {
  QueryBuilder<ProductEntity, ProductEntity, QAfterSortBy> sortByBoyi() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'boyi', Sort.asc);
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterSortBy> sortByBoyiDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'boyi', Sort.desc);
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterSortBy> sortByCategoryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.asc);
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterSortBy>
      sortByCategoryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.desc);
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterSortBy> sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterSortBy>
      sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterSortBy> sortByEni() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eni', Sort.asc);
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterSortBy> sortByEniDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eni', Sort.desc);
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterSortBy> sortByFoyda() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'foyda', Sort.asc);
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterSortBy> sortByFoydaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'foyda', Sort.desc);
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterSortBy> sortByIsVerified() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isVerified', Sort.asc);
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterSortBy>
      sortByIsVerifiedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isVerified', Sort.desc);
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterSortBy> sortByNomer() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nomer', Sort.asc);
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterSortBy> sortByNomerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nomer', Sort.desc);
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterSortBy>
      sortByPathOfPicture() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pathOfPicture', Sort.asc);
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterSortBy>
      sortByPathOfPictureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pathOfPicture', Sort.desc);
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterSortBy> sortBySotuv() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sotuv', Sort.asc);
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterSortBy> sortBySotuvDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sotuv', Sort.desc);
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterSortBy> sortByXizmat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'xizmat', Sort.asc);
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterSortBy> sortByXizmatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'xizmat', Sort.desc);
    });
  }
}

extension ProductEntityQuerySortThenBy
    on QueryBuilder<ProductEntity, ProductEntity, QSortThenBy> {
  QueryBuilder<ProductEntity, ProductEntity, QAfterSortBy> thenByBoyi() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'boyi', Sort.asc);
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterSortBy> thenByBoyiDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'boyi', Sort.desc);
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterSortBy> thenByCategoryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.asc);
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterSortBy>
      thenByCategoryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.desc);
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterSortBy> thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterSortBy>
      thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterSortBy> thenByEni() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eni', Sort.asc);
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterSortBy> thenByEniDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eni', Sort.desc);
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterSortBy> thenByFoyda() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'foyda', Sort.asc);
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterSortBy> thenByFoydaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'foyda', Sort.desc);
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterSortBy> thenByIsVerified() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isVerified', Sort.asc);
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterSortBy>
      thenByIsVerifiedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isVerified', Sort.desc);
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterSortBy> thenByNomer() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nomer', Sort.asc);
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterSortBy> thenByNomerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nomer', Sort.desc);
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterSortBy>
      thenByPathOfPicture() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pathOfPicture', Sort.asc);
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterSortBy>
      thenByPathOfPictureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pathOfPicture', Sort.desc);
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterSortBy> thenBySotuv() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sotuv', Sort.asc);
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterSortBy> thenBySotuvDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sotuv', Sort.desc);
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterSortBy> thenByXizmat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'xizmat', Sort.asc);
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QAfterSortBy> thenByXizmatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'xizmat', Sort.desc);
    });
  }
}

extension ProductEntityQueryWhereDistinct
    on QueryBuilder<ProductEntity, ProductEntity, QDistinct> {
  QueryBuilder<ProductEntity, ProductEntity, QDistinct> distinctByBoyi() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'boyi');
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QDistinct> distinctByCategoryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'categoryId');
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QDistinct> distinctByDescription(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QDistinct> distinctByEni() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'eni');
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QDistinct> distinctByFoyda() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'foyda');
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QDistinct> distinctByIsVerified() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isVerified');
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QDistinct> distinctByNomer() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nomer');
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QDistinct> distinctByPathOfPicture(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pathOfPicture',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QDistinct> distinctBySotuv() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sotuv');
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<ProductEntity, ProductEntity, QDistinct> distinctByXizmat() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'xizmat');
    });
  }
}

extension ProductEntityQueryProperty
    on QueryBuilder<ProductEntity, ProductEntity, QQueryProperty> {
  QueryBuilder<ProductEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ProductEntity, int?, QQueryOperations> boyiProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'boyi');
    });
  }

  QueryBuilder<ProductEntity, int?, QQueryOperations> categoryIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'categoryId');
    });
  }

  QueryBuilder<ProductEntity, DateTime?, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<ProductEntity, String?, QQueryOperations> descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<ProductEntity, int?, QQueryOperations> eniProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'eni');
    });
  }

  QueryBuilder<ProductEntity, int?, QQueryOperations> foydaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'foyda');
    });
  }

  QueryBuilder<ProductEntity, bool, QQueryOperations> isVerifiedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isVerified');
    });
  }

  QueryBuilder<ProductEntity, int, QQueryOperations> nomerProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nomer');
    });
  }

  QueryBuilder<ProductEntity, String?, QQueryOperations>
      pathOfPictureProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pathOfPicture');
    });
  }

  QueryBuilder<ProductEntity, int?, QQueryOperations> sotuvProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sotuv');
    });
  }

  QueryBuilder<ProductEntity, DateTime?, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<ProductEntity, int?, QQueryOperations> xizmatProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'xizmat');
    });
  }
}
