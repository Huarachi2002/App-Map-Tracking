// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tarjeta_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTarjetaModelCollection on Isar {
  IsarCollection<TarjetaModel> get tarjetaModels => this.collection();
}

const TarjetaModelSchema = CollectionSchema(
  name: r'TarjetaModel',
  id: -307898267989473640,
  properties: {
    r'codigo': PropertySchema(
      id: 0,
      name: r'codigo',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'estado': PropertySchema(
      id: 2,
      name: r'estado',
      type: IsarType.bool,
    ),
    r'idCliente': PropertySchema(
      id: 3,
      name: r'idCliente',
      type: IsarType.string,
    ),
    r'movimientos': PropertySchema(
      id: 4,
      name: r'movimientos',
      type: IsarType.stringList,
    ),
    r'nfcId': PropertySchema(
      id: 5,
      name: r'nfcId',
      type: IsarType.string,
    ),
    r'saldoActual': PropertySchema(
      id: 6,
      name: r'saldoActual',
      type: IsarType.double,
    ),
    r'tipoTarjeta': PropertySchema(
      id: 7,
      name: r'tipoTarjeta',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 8,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _tarjetaModelEstimateSize,
  serialize: _tarjetaModelSerialize,
  deserialize: _tarjetaModelDeserialize,
  deserializeProp: _tarjetaModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'codigo': IndexSchema(
      id: 2475659939796141935,
      name: r'codigo',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'codigo',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _tarjetaModelGetId,
  getLinks: _tarjetaModelGetLinks,
  attach: _tarjetaModelAttach,
  version: '3.1.0+1',
);

int _tarjetaModelEstimateSize(
  TarjetaModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.codigo.length * 3;
  bytesCount += 3 + object.idCliente.length * 3;
  bytesCount += 3 + object.movimientos.length * 3;
  {
    for (var i = 0; i < object.movimientos.length; i++) {
      final value = object.movimientos[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.nfcId.length * 3;
  bytesCount += 3 + object.tipoTarjeta.length * 3;
  return bytesCount;
}

void _tarjetaModelSerialize(
  TarjetaModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.codigo);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeBool(offsets[2], object.estado);
  writer.writeString(offsets[3], object.idCliente);
  writer.writeStringList(offsets[4], object.movimientos);
  writer.writeString(offsets[5], object.nfcId);
  writer.writeDouble(offsets[6], object.saldoActual);
  writer.writeString(offsets[7], object.tipoTarjeta);
  writer.writeDateTime(offsets[8], object.updatedAt);
}

TarjetaModel _tarjetaModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TarjetaModel();
  object.codigo = reader.readString(offsets[0]);
  object.createdAt = reader.readDateTime(offsets[1]);
  object.estado = reader.readBool(offsets[2]);
  object.id = id;
  object.idCliente = reader.readString(offsets[3]);
  object.movimientos = reader.readStringList(offsets[4]) ?? [];
  object.nfcId = reader.readString(offsets[5]);
  object.saldoActual = reader.readDouble(offsets[6]);
  object.tipoTarjeta = reader.readString(offsets[7]);
  object.updatedAt = reader.readDateTime(offsets[8]);
  return object;
}

P _tarjetaModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readStringList(offset) ?? []) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readDouble(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _tarjetaModelGetId(TarjetaModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _tarjetaModelGetLinks(TarjetaModel object) {
  return [];
}

void _tarjetaModelAttach(
    IsarCollection<dynamic> col, Id id, TarjetaModel object) {
  object.id = id;
}

extension TarjetaModelByIndex on IsarCollection<TarjetaModel> {
  Future<TarjetaModel?> getByCodigo(String codigo) {
    return getByIndex(r'codigo', [codigo]);
  }

  TarjetaModel? getByCodigoSync(String codigo) {
    return getByIndexSync(r'codigo', [codigo]);
  }

  Future<bool> deleteByCodigo(String codigo) {
    return deleteByIndex(r'codigo', [codigo]);
  }

  bool deleteByCodigoSync(String codigo) {
    return deleteByIndexSync(r'codigo', [codigo]);
  }

  Future<List<TarjetaModel?>> getAllByCodigo(List<String> codigoValues) {
    final values = codigoValues.map((e) => [e]).toList();
    return getAllByIndex(r'codigo', values);
  }

  List<TarjetaModel?> getAllByCodigoSync(List<String> codigoValues) {
    final values = codigoValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'codigo', values);
  }

  Future<int> deleteAllByCodigo(List<String> codigoValues) {
    final values = codigoValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'codigo', values);
  }

  int deleteAllByCodigoSync(List<String> codigoValues) {
    final values = codigoValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'codigo', values);
  }

  Future<Id> putByCodigo(TarjetaModel object) {
    return putByIndex(r'codigo', object);
  }

  Id putByCodigoSync(TarjetaModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'codigo', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByCodigo(List<TarjetaModel> objects) {
    return putAllByIndex(r'codigo', objects);
  }

  List<Id> putAllByCodigoSync(List<TarjetaModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'codigo', objects, saveLinks: saveLinks);
  }
}

extension TarjetaModelQueryWhereSort
    on QueryBuilder<TarjetaModel, TarjetaModel, QWhere> {
  QueryBuilder<TarjetaModel, TarjetaModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension TarjetaModelQueryWhere
    on QueryBuilder<TarjetaModel, TarjetaModel, QWhereClause> {
  QueryBuilder<TarjetaModel, TarjetaModel, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterWhereClause> idBetween(
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

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterWhereClause> codigoEqualTo(
      String codigo) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'codigo',
        value: [codigo],
      ));
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterWhereClause> codigoNotEqualTo(
      String codigo) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'codigo',
              lower: [],
              upper: [codigo],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'codigo',
              lower: [codigo],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'codigo',
              lower: [codigo],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'codigo',
              lower: [],
              upper: [codigo],
              includeUpper: false,
            ));
      }
    });
  }
}

extension TarjetaModelQueryFilter
    on QueryBuilder<TarjetaModel, TarjetaModel, QFilterCondition> {
  QueryBuilder<TarjetaModel, TarjetaModel, QAfterFilterCondition> codigoEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'codigo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterFilterCondition>
      codigoGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'codigo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterFilterCondition>
      codigoLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'codigo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterFilterCondition> codigoBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'codigo',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterFilterCondition>
      codigoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'codigo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterFilterCondition>
      codigoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'codigo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterFilterCondition>
      codigoContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'codigo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterFilterCondition> codigoMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'codigo',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterFilterCondition>
      codigoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'codigo',
        value: '',
      ));
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterFilterCondition>
      codigoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'codigo',
        value: '',
      ));
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
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

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterFilterCondition>
      createdAtLessThan(
    DateTime value, {
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

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterFilterCondition>
      createdAtBetween(
    DateTime lower,
    DateTime upper, {
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

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterFilterCondition> estadoEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'estado',
        value: value,
      ));
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterFilterCondition> idBetween(
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

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterFilterCondition>
      idClienteEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idCliente',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterFilterCondition>
      idClienteGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'idCliente',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterFilterCondition>
      idClienteLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'idCliente',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterFilterCondition>
      idClienteBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'idCliente',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterFilterCondition>
      idClienteStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'idCliente',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterFilterCondition>
      idClienteEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'idCliente',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterFilterCondition>
      idClienteContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'idCliente',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterFilterCondition>
      idClienteMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'idCliente',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterFilterCondition>
      idClienteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idCliente',
        value: '',
      ));
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterFilterCondition>
      idClienteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'idCliente',
        value: '',
      ));
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterFilterCondition>
      movimientosElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'movimientos',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterFilterCondition>
      movimientosElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'movimientos',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterFilterCondition>
      movimientosElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'movimientos',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterFilterCondition>
      movimientosElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'movimientos',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterFilterCondition>
      movimientosElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'movimientos',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterFilterCondition>
      movimientosElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'movimientos',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterFilterCondition>
      movimientosElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'movimientos',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterFilterCondition>
      movimientosElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'movimientos',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterFilterCondition>
      movimientosElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'movimientos',
        value: '',
      ));
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterFilterCondition>
      movimientosElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'movimientos',
        value: '',
      ));
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterFilterCondition>
      movimientosLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'movimientos',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterFilterCondition>
      movimientosIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'movimientos',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterFilterCondition>
      movimientosIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'movimientos',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterFilterCondition>
      movimientosLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'movimientos',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterFilterCondition>
      movimientosLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'movimientos',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterFilterCondition>
      movimientosLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'movimientos',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterFilterCondition> nfcIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nfcId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterFilterCondition>
      nfcIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nfcId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterFilterCondition> nfcIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nfcId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterFilterCondition> nfcIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nfcId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterFilterCondition>
      nfcIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'nfcId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterFilterCondition> nfcIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'nfcId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterFilterCondition> nfcIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'nfcId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterFilterCondition> nfcIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'nfcId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterFilterCondition>
      nfcIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nfcId',
        value: '',
      ));
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterFilterCondition>
      nfcIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'nfcId',
        value: '',
      ));
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterFilterCondition>
      saldoActualEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'saldoActual',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterFilterCondition>
      saldoActualGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'saldoActual',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterFilterCondition>
      saldoActualLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'saldoActual',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterFilterCondition>
      saldoActualBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'saldoActual',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterFilterCondition>
      tipoTarjetaEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tipoTarjeta',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterFilterCondition>
      tipoTarjetaGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tipoTarjeta',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterFilterCondition>
      tipoTarjetaLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tipoTarjeta',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterFilterCondition>
      tipoTarjetaBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tipoTarjeta',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterFilterCondition>
      tipoTarjetaStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'tipoTarjeta',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterFilterCondition>
      tipoTarjetaEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'tipoTarjeta',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterFilterCondition>
      tipoTarjetaContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'tipoTarjeta',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterFilterCondition>
      tipoTarjetaMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'tipoTarjeta',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterFilterCondition>
      tipoTarjetaIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tipoTarjeta',
        value: '',
      ));
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterFilterCondition>
      tipoTarjetaIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'tipoTarjeta',
        value: '',
      ));
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterFilterCondition>
      updatedAtGreaterThan(
    DateTime value, {
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

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterFilterCondition>
      updatedAtLessThan(
    DateTime value, {
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

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterFilterCondition>
      updatedAtBetween(
    DateTime lower,
    DateTime upper, {
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
}

extension TarjetaModelQueryObject
    on QueryBuilder<TarjetaModel, TarjetaModel, QFilterCondition> {}

extension TarjetaModelQueryLinks
    on QueryBuilder<TarjetaModel, TarjetaModel, QFilterCondition> {}

extension TarjetaModelQuerySortBy
    on QueryBuilder<TarjetaModel, TarjetaModel, QSortBy> {
  QueryBuilder<TarjetaModel, TarjetaModel, QAfterSortBy> sortByCodigo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'codigo', Sort.asc);
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterSortBy> sortByCodigoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'codigo', Sort.desc);
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterSortBy> sortByEstado() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estado', Sort.asc);
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterSortBy> sortByEstadoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estado', Sort.desc);
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterSortBy> sortByIdCliente() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idCliente', Sort.asc);
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterSortBy> sortByIdClienteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idCliente', Sort.desc);
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterSortBy> sortByNfcId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nfcId', Sort.asc);
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterSortBy> sortByNfcIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nfcId', Sort.desc);
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterSortBy> sortBySaldoActual() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'saldoActual', Sort.asc);
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterSortBy>
      sortBySaldoActualDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'saldoActual', Sort.desc);
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterSortBy> sortByTipoTarjeta() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tipoTarjeta', Sort.asc);
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterSortBy>
      sortByTipoTarjetaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tipoTarjeta', Sort.desc);
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension TarjetaModelQuerySortThenBy
    on QueryBuilder<TarjetaModel, TarjetaModel, QSortThenBy> {
  QueryBuilder<TarjetaModel, TarjetaModel, QAfterSortBy> thenByCodigo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'codigo', Sort.asc);
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterSortBy> thenByCodigoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'codigo', Sort.desc);
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterSortBy> thenByEstado() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estado', Sort.asc);
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterSortBy> thenByEstadoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estado', Sort.desc);
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterSortBy> thenByIdCliente() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idCliente', Sort.asc);
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterSortBy> thenByIdClienteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idCliente', Sort.desc);
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterSortBy> thenByNfcId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nfcId', Sort.asc);
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterSortBy> thenByNfcIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nfcId', Sort.desc);
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterSortBy> thenBySaldoActual() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'saldoActual', Sort.asc);
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterSortBy>
      thenBySaldoActualDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'saldoActual', Sort.desc);
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterSortBy> thenByTipoTarjeta() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tipoTarjeta', Sort.asc);
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterSortBy>
      thenByTipoTarjetaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tipoTarjeta', Sort.desc);
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension TarjetaModelQueryWhereDistinct
    on QueryBuilder<TarjetaModel, TarjetaModel, QDistinct> {
  QueryBuilder<TarjetaModel, TarjetaModel, QDistinct> distinctByCodigo(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'codigo', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QDistinct> distinctByEstado() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'estado');
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QDistinct> distinctByIdCliente(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'idCliente', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QDistinct> distinctByMovimientos() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'movimientos');
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QDistinct> distinctByNfcId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nfcId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QDistinct> distinctBySaldoActual() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'saldoActual');
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QDistinct> distinctByTipoTarjeta(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tipoTarjeta', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TarjetaModel, TarjetaModel, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension TarjetaModelQueryProperty
    on QueryBuilder<TarjetaModel, TarjetaModel, QQueryProperty> {
  QueryBuilder<TarjetaModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<TarjetaModel, String, QQueryOperations> codigoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'codigo');
    });
  }

  QueryBuilder<TarjetaModel, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<TarjetaModel, bool, QQueryOperations> estadoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'estado');
    });
  }

  QueryBuilder<TarjetaModel, String, QQueryOperations> idClienteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'idCliente');
    });
  }

  QueryBuilder<TarjetaModel, List<String>, QQueryOperations>
      movimientosProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'movimientos');
    });
  }

  QueryBuilder<TarjetaModel, String, QQueryOperations> nfcIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nfcId');
    });
  }

  QueryBuilder<TarjetaModel, double, QQueryOperations> saldoActualProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'saldoActual');
    });
  }

  QueryBuilder<TarjetaModel, String, QQueryOperations> tipoTarjetaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tipoTarjeta');
    });
  }

  QueryBuilder<TarjetaModel, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
