// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parada_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetParadaModelCollection on Isar {
  IsarCollection<ParadaModel> get paradaModels => this.collection();
}

const ParadaModelSchema = CollectionSchema(
  name: r'ParadaModel',
  id: 6678632752152567293,
  properties: {
    r'idRuta': PropertySchema(
      id: 0,
      name: r'idRuta',
      type: IsarType.string,
    ),
    r'latitud': PropertySchema(
      id: 1,
      name: r'latitud',
      type: IsarType.double,
    ),
    r'longitud': PropertySchema(
      id: 2,
      name: r'longitud',
      type: IsarType.double,
    ),
    r'nombre': PropertySchema(
      id: 3,
      name: r'nombre',
      type: IsarType.string,
    ),
    r'paradaId': PropertySchema(
      id: 4,
      name: r'paradaId',
      type: IsarType.string,
    ),
    r'tiempo': PropertySchema(
      id: 5,
      name: r'tiempo',
      type: IsarType.string,
    )
  },
  estimateSize: _paradaModelEstimateSize,
  serialize: _paradaModelSerialize,
  deserialize: _paradaModelDeserialize,
  deserializeProp: _paradaModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'paradaId': IndexSchema(
      id: -7935120963483389043,
      name: r'paradaId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'paradaId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _paradaModelGetId,
  getLinks: _paradaModelGetLinks,
  attach: _paradaModelAttach,
  version: '3.1.0+1',
);

int _paradaModelEstimateSize(
  ParadaModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.idRuta.length * 3;
  bytesCount += 3 + object.nombre.length * 3;
  bytesCount += 3 + object.paradaId.length * 3;
  bytesCount += 3 + object.tiempo.length * 3;
  return bytesCount;
}

void _paradaModelSerialize(
  ParadaModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.idRuta);
  writer.writeDouble(offsets[1], object.latitud);
  writer.writeDouble(offsets[2], object.longitud);
  writer.writeString(offsets[3], object.nombre);
  writer.writeString(offsets[4], object.paradaId);
  writer.writeString(offsets[5], object.tiempo);
}

ParadaModel _paradaModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ParadaModel();
  object.id = id;
  object.idRuta = reader.readString(offsets[0]);
  object.latitud = reader.readDouble(offsets[1]);
  object.longitud = reader.readDouble(offsets[2]);
  object.nombre = reader.readString(offsets[3]);
  object.paradaId = reader.readString(offsets[4]);
  object.tiempo = reader.readString(offsets[5]);
  return object;
}

P _paradaModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readDouble(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _paradaModelGetId(ParadaModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _paradaModelGetLinks(ParadaModel object) {
  return [];
}

void _paradaModelAttach(
    IsarCollection<dynamic> col, Id id, ParadaModel object) {
  object.id = id;
}

extension ParadaModelQueryWhereSort
    on QueryBuilder<ParadaModel, ParadaModel, QWhere> {
  QueryBuilder<ParadaModel, ParadaModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ParadaModelQueryWhere
    on QueryBuilder<ParadaModel, ParadaModel, QWhereClause> {
  QueryBuilder<ParadaModel, ParadaModel, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<ParadaModel, ParadaModel, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QAfterWhereClause> idBetween(
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

  QueryBuilder<ParadaModel, ParadaModel, QAfterWhereClause> paradaIdEqualTo(
      String paradaId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'paradaId',
        value: [paradaId],
      ));
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QAfterWhereClause> paradaIdNotEqualTo(
      String paradaId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'paradaId',
              lower: [],
              upper: [paradaId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'paradaId',
              lower: [paradaId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'paradaId',
              lower: [paradaId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'paradaId',
              lower: [],
              upper: [paradaId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension ParadaModelQueryFilter
    on QueryBuilder<ParadaModel, ParadaModel, QFilterCondition> {
  QueryBuilder<ParadaModel, ParadaModel, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<ParadaModel, ParadaModel, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<ParadaModel, ParadaModel, QAfterFilterCondition> idBetween(
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

  QueryBuilder<ParadaModel, ParadaModel, QAfterFilterCondition> idRutaEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idRuta',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QAfterFilterCondition>
      idRutaGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'idRuta',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QAfterFilterCondition> idRutaLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'idRuta',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QAfterFilterCondition> idRutaBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'idRuta',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QAfterFilterCondition>
      idRutaStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'idRuta',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QAfterFilterCondition> idRutaEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'idRuta',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QAfterFilterCondition> idRutaContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'idRuta',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QAfterFilterCondition> idRutaMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'idRuta',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QAfterFilterCondition>
      idRutaIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idRuta',
        value: '',
      ));
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QAfterFilterCondition>
      idRutaIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'idRuta',
        value: '',
      ));
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QAfterFilterCondition> latitudEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'latitud',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QAfterFilterCondition>
      latitudGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'latitud',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QAfterFilterCondition> latitudLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'latitud',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QAfterFilterCondition> latitudBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'latitud',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QAfterFilterCondition> longitudEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'longitud',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QAfterFilterCondition>
      longitudGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'longitud',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QAfterFilterCondition>
      longitudLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'longitud',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QAfterFilterCondition> longitudBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'longitud',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QAfterFilterCondition> nombreEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nombre',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QAfterFilterCondition>
      nombreGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nombre',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QAfterFilterCondition> nombreLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nombre',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QAfterFilterCondition> nombreBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nombre',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QAfterFilterCondition>
      nombreStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'nombre',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QAfterFilterCondition> nombreEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'nombre',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QAfterFilterCondition> nombreContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'nombre',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QAfterFilterCondition> nombreMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'nombre',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QAfterFilterCondition>
      nombreIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nombre',
        value: '',
      ));
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QAfterFilterCondition>
      nombreIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'nombre',
        value: '',
      ));
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QAfterFilterCondition> paradaIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'paradaId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QAfterFilterCondition>
      paradaIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'paradaId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QAfterFilterCondition>
      paradaIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'paradaId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QAfterFilterCondition> paradaIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'paradaId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QAfterFilterCondition>
      paradaIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'paradaId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QAfterFilterCondition>
      paradaIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'paradaId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QAfterFilterCondition>
      paradaIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'paradaId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QAfterFilterCondition> paradaIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'paradaId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QAfterFilterCondition>
      paradaIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'paradaId',
        value: '',
      ));
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QAfterFilterCondition>
      paradaIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'paradaId',
        value: '',
      ));
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QAfterFilterCondition> tiempoEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tiempo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QAfterFilterCondition>
      tiempoGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tiempo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QAfterFilterCondition> tiempoLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tiempo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QAfterFilterCondition> tiempoBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tiempo',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QAfterFilterCondition>
      tiempoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'tiempo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QAfterFilterCondition> tiempoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'tiempo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QAfterFilterCondition> tiempoContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'tiempo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QAfterFilterCondition> tiempoMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'tiempo',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QAfterFilterCondition>
      tiempoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tiempo',
        value: '',
      ));
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QAfterFilterCondition>
      tiempoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'tiempo',
        value: '',
      ));
    });
  }
}

extension ParadaModelQueryObject
    on QueryBuilder<ParadaModel, ParadaModel, QFilterCondition> {}

extension ParadaModelQueryLinks
    on QueryBuilder<ParadaModel, ParadaModel, QFilterCondition> {}

extension ParadaModelQuerySortBy
    on QueryBuilder<ParadaModel, ParadaModel, QSortBy> {
  QueryBuilder<ParadaModel, ParadaModel, QAfterSortBy> sortByIdRuta() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idRuta', Sort.asc);
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QAfterSortBy> sortByIdRutaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idRuta', Sort.desc);
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QAfterSortBy> sortByLatitud() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitud', Sort.asc);
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QAfterSortBy> sortByLatitudDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitud', Sort.desc);
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QAfterSortBy> sortByLongitud() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitud', Sort.asc);
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QAfterSortBy> sortByLongitudDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitud', Sort.desc);
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QAfterSortBy> sortByNombre() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nombre', Sort.asc);
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QAfterSortBy> sortByNombreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nombre', Sort.desc);
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QAfterSortBy> sortByParadaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paradaId', Sort.asc);
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QAfterSortBy> sortByParadaIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paradaId', Sort.desc);
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QAfterSortBy> sortByTiempo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tiempo', Sort.asc);
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QAfterSortBy> sortByTiempoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tiempo', Sort.desc);
    });
  }
}

extension ParadaModelQuerySortThenBy
    on QueryBuilder<ParadaModel, ParadaModel, QSortThenBy> {
  QueryBuilder<ParadaModel, ParadaModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QAfterSortBy> thenByIdRuta() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idRuta', Sort.asc);
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QAfterSortBy> thenByIdRutaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idRuta', Sort.desc);
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QAfterSortBy> thenByLatitud() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitud', Sort.asc);
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QAfterSortBy> thenByLatitudDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitud', Sort.desc);
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QAfterSortBy> thenByLongitud() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitud', Sort.asc);
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QAfterSortBy> thenByLongitudDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitud', Sort.desc);
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QAfterSortBy> thenByNombre() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nombre', Sort.asc);
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QAfterSortBy> thenByNombreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nombre', Sort.desc);
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QAfterSortBy> thenByParadaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paradaId', Sort.asc);
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QAfterSortBy> thenByParadaIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paradaId', Sort.desc);
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QAfterSortBy> thenByTiempo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tiempo', Sort.asc);
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QAfterSortBy> thenByTiempoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tiempo', Sort.desc);
    });
  }
}

extension ParadaModelQueryWhereDistinct
    on QueryBuilder<ParadaModel, ParadaModel, QDistinct> {
  QueryBuilder<ParadaModel, ParadaModel, QDistinct> distinctByIdRuta(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'idRuta', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QDistinct> distinctByLatitud() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'latitud');
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QDistinct> distinctByLongitud() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'longitud');
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QDistinct> distinctByNombre(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nombre', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QDistinct> distinctByParadaId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'paradaId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ParadaModel, ParadaModel, QDistinct> distinctByTiempo(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tiempo', caseSensitive: caseSensitive);
    });
  }
}

extension ParadaModelQueryProperty
    on QueryBuilder<ParadaModel, ParadaModel, QQueryProperty> {
  QueryBuilder<ParadaModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ParadaModel, String, QQueryOperations> idRutaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'idRuta');
    });
  }

  QueryBuilder<ParadaModel, double, QQueryOperations> latitudProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'latitud');
    });
  }

  QueryBuilder<ParadaModel, double, QQueryOperations> longitudProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'longitud');
    });
  }

  QueryBuilder<ParadaModel, String, QQueryOperations> nombreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nombre');
    });
  }

  QueryBuilder<ParadaModel, String, QQueryOperations> paradaIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'paradaId');
    });
  }

  QueryBuilder<ParadaModel, String, QQueryOperations> tiempoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tiempo');
    });
  }
}
