// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db.dart';

// ignore_for_file: type=lint
class $LanguagesTable extends Languages
    with TableInfo<$LanguagesTable, Language> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LanguagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _shortNameMeta =
      const VerificationMeta('shortName');
  @override
  late final GeneratedColumn<String> shortName = GeneratedColumn<String>(
      'short_name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 2, maxTextLength: 15),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
      'uuid', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => const Uuid().v4());
  @override
  List<GeneratedColumn> get $columns => [id, name, shortName, uuid];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'languages';
  @override
  VerificationContext validateIntegrity(Insertable<Language> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('short_name')) {
      context.handle(_shortNameMeta,
          shortName.isAcceptableOrUnknown(data['short_name']!, _shortNameMeta));
    } else if (isInserting) {
      context.missing(_shortNameMeta);
    }
    if (data.containsKey('uuid')) {
      context.handle(
          _uuidMeta, uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Language map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Language(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      shortName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}short_name'])!,
      uuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uuid'])!,
    );
  }

  @override
  $LanguagesTable createAlias(String alias) {
    return $LanguagesTable(attachedDatabase, alias);
  }
}

class Language extends DataClass implements Insertable<Language> {
  final int id;
  final String name;
  final String shortName;
  final String uuid;
  const Language(
      {required this.id,
      required this.name,
      required this.shortName,
      required this.uuid});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['short_name'] = Variable<String>(shortName);
    map['uuid'] = Variable<String>(uuid);
    return map;
  }

  LanguagesCompanion toCompanion(bool nullToAbsent) {
    return LanguagesCompanion(
      id: Value(id),
      name: Value(name),
      shortName: Value(shortName),
      uuid: Value(uuid),
    );
  }

  factory Language.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Language(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      shortName: serializer.fromJson<String>(json['shortName']),
      uuid: serializer.fromJson<String>(json['uuid']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'shortName': serializer.toJson<String>(shortName),
      'uuid': serializer.toJson<String>(uuid),
    };
  }

  Language copyWith({int? id, String? name, String? shortName, String? uuid}) =>
      Language(
        id: id ?? this.id,
        name: name ?? this.name,
        shortName: shortName ?? this.shortName,
        uuid: uuid ?? this.uuid,
      );
  @override
  String toString() {
    return (StringBuffer('Language(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('shortName: $shortName, ')
          ..write('uuid: $uuid')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, shortName, uuid);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Language &&
          other.id == this.id &&
          other.name == this.name &&
          other.shortName == this.shortName &&
          other.uuid == this.uuid);
}

class LanguagesCompanion extends UpdateCompanion<Language> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> shortName;
  final Value<String> uuid;
  const LanguagesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.shortName = const Value.absent(),
    this.uuid = const Value.absent(),
  });
  LanguagesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String shortName,
    this.uuid = const Value.absent(),
  })  : name = Value(name),
        shortName = Value(shortName);
  static Insertable<Language> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? shortName,
    Expression<String>? uuid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (shortName != null) 'short_name': shortName,
      if (uuid != null) 'uuid': uuid,
    });
  }

  LanguagesCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? shortName,
      Value<String>? uuid}) {
    return LanguagesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      shortName: shortName ?? this.shortName,
      uuid: uuid ?? this.uuid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (shortName.present) {
      map['short_name'] = Variable<String>(shortName.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LanguagesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('shortName: $shortName, ')
          ..write('uuid: $uuid')
          ..write(')'))
        .toString();
  }
}

class $WordsTable extends Words with TableInfo<$WordsTable, Word> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
      'uuid', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => const Uuid().v4());
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _meanMeta = const VerificationMeta('mean');
  @override
  late final GeneratedColumn<String> mean = GeneratedColumn<String>(
      'mean', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _baselangMeta =
      const VerificationMeta('baselang');
  @override
  late final GeneratedColumn<int> baselang = GeneratedColumn<int>(
      'baselang', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES languages (id)'));
  static const VerificationMeta _rootWordIDMeta =
      const VerificationMeta('rootWordID');
  @override
  late final GeneratedColumn<int> rootWordID = GeneratedColumn<int>(
      'root_word_i_d', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, uuid, name, description, mean, baselang, rootWordID];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'words';
  @override
  VerificationContext validateIntegrity(Insertable<Word> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('uuid')) {
      context.handle(
          _uuidMeta, uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('mean')) {
      context.handle(
          _meanMeta, mean.isAcceptableOrUnknown(data['mean']!, _meanMeta));
    }
    if (data.containsKey('baselang')) {
      context.handle(_baselangMeta,
          baselang.isAcceptableOrUnknown(data['baselang']!, _baselangMeta));
    }
    if (data.containsKey('root_word_i_d')) {
      context.handle(
          _rootWordIDMeta,
          rootWordID.isAcceptableOrUnknown(
              data['root_word_i_d']!, _rootWordIDMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Word map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Word(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      uuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uuid'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      mean: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mean']),
      baselang: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}baselang']),
      rootWordID: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}root_word_i_d']),
    );
  }

  @override
  $WordsTable createAlias(String alias) {
    return $WordsTable(attachedDatabase, alias);
  }
}

class Word extends DataClass implements Insertable<Word> {
  final int id;
  final String uuid;
  final String name;
  final String description;
  final String? mean;
  final int? baselang;
  final int? rootWordID;
  const Word(
      {required this.id,
      required this.uuid,
      required this.name,
      required this.description,
      this.mean,
      this.baselang,
      this.rootWordID});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    if (!nullToAbsent || mean != null) {
      map['mean'] = Variable<String>(mean);
    }
    if (!nullToAbsent || baselang != null) {
      map['baselang'] = Variable<int>(baselang);
    }
    if (!nullToAbsent || rootWordID != null) {
      map['root_word_i_d'] = Variable<int>(rootWordID);
    }
    return map;
  }

  WordsCompanion toCompanion(bool nullToAbsent) {
    return WordsCompanion(
      id: Value(id),
      uuid: Value(uuid),
      name: Value(name),
      description: Value(description),
      mean: mean == null && nullToAbsent ? const Value.absent() : Value(mean),
      baselang: baselang == null && nullToAbsent
          ? const Value.absent()
          : Value(baselang),
      rootWordID: rootWordID == null && nullToAbsent
          ? const Value.absent()
          : Value(rootWordID),
    );
  }

  factory Word.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Word(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      mean: serializer.fromJson<String?>(json['mean']),
      baselang: serializer.fromJson<int?>(json['baselang']),
      rootWordID: serializer.fromJson<int?>(json['rootWordID']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'mean': serializer.toJson<String?>(mean),
      'baselang': serializer.toJson<int?>(baselang),
      'rootWordID': serializer.toJson<int?>(rootWordID),
    };
  }

  Word copyWith(
          {int? id,
          String? uuid,
          String? name,
          String? description,
          Value<String?> mean = const Value.absent(),
          Value<int?> baselang = const Value.absent(),
          Value<int?> rootWordID = const Value.absent()}) =>
      Word(
        id: id ?? this.id,
        uuid: uuid ?? this.uuid,
        name: name ?? this.name,
        description: description ?? this.description,
        mean: mean.present ? mean.value : this.mean,
        baselang: baselang.present ? baselang.value : this.baselang,
        rootWordID: rootWordID.present ? rootWordID.value : this.rootWordID,
      );
  @override
  String toString() {
    return (StringBuffer('Word(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('mean: $mean, ')
          ..write('baselang: $baselang, ')
          ..write('rootWordID: $rootWordID')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, uuid, name, description, mean, baselang, rootWordID);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Word &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.name == this.name &&
          other.description == this.description &&
          other.mean == this.mean &&
          other.baselang == this.baselang &&
          other.rootWordID == this.rootWordID);
}

class WordsCompanion extends UpdateCompanion<Word> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<String> name;
  final Value<String> description;
  final Value<String?> mean;
  final Value<int?> baselang;
  final Value<int?> rootWordID;
  const WordsCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.mean = const Value.absent(),
    this.baselang = const Value.absent(),
    this.rootWordID = const Value.absent(),
  });
  WordsCompanion.insert({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    required String name,
    required String description,
    this.mean = const Value.absent(),
    this.baselang = const Value.absent(),
    this.rootWordID = const Value.absent(),
  })  : name = Value(name),
        description = Value(description);
  static Insertable<Word> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? mean,
    Expression<int>? baselang,
    Expression<int>? rootWordID,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (mean != null) 'mean': mean,
      if (baselang != null) 'baselang': baselang,
      if (rootWordID != null) 'root_word_i_d': rootWordID,
    });
  }

  WordsCompanion copyWith(
      {Value<int>? id,
      Value<String>? uuid,
      Value<String>? name,
      Value<String>? description,
      Value<String?>? mean,
      Value<int?>? baselang,
      Value<int?>? rootWordID}) {
    return WordsCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      description: description ?? this.description,
      mean: mean ?? this.mean,
      baselang: baselang ?? this.baselang,
      rootWordID: rootWordID ?? this.rootWordID,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (mean.present) {
      map['mean'] = Variable<String>(mean.value);
    }
    if (baselang.present) {
      map['baselang'] = Variable<int>(baselang.value);
    }
    if (rootWordID.present) {
      map['root_word_i_d'] = Variable<int>(rootWordID.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WordsCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('mean: $mean, ')
          ..write('baselang: $baselang, ')
          ..write('rootWordID: $rootWordID')
          ..write(')'))
        .toString();
  }
}

class $SynonymsTable extends Synonyms with TableInfo<$SynonymsTable, synonyms> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SynonymsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
      'uuid', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => const Uuid().v4());
  static const VerificationMeta _baseWordMeta =
      const VerificationMeta('baseWord');
  @override
  late final GeneratedColumn<int> baseWord = GeneratedColumn<int>(
      'base_word', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES words (id)'));
  static const VerificationMeta _synonymWordMeta =
      const VerificationMeta('synonymWord');
  @override
  late final GeneratedColumn<int> synonymWord = GeneratedColumn<int>(
      'synonym_word', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES words (id)'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _baselangMeta =
      const VerificationMeta('baselang');
  @override
  late final GeneratedColumn<int> baselang = GeneratedColumn<int>(
      'baselang', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES languages (id)'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, uuid, baseWord, synonymWord, name, baselang];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'synonyms';
  @override
  VerificationContext validateIntegrity(Insertable<synonyms> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('uuid')) {
      context.handle(
          _uuidMeta, uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta));
    }
    if (data.containsKey('base_word')) {
      context.handle(_baseWordMeta,
          baseWord.isAcceptableOrUnknown(data['base_word']!, _baseWordMeta));
    }
    if (data.containsKey('synonym_word')) {
      context.handle(
          _synonymWordMeta,
          synonymWord.isAcceptableOrUnknown(
              data['synonym_word']!, _synonymWordMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('baselang')) {
      context.handle(_baselangMeta,
          baselang.isAcceptableOrUnknown(data['baselang']!, _baselangMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  synonyms map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return synonyms(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      uuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uuid'])!,
      baseWord: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}base_word']),
      synonymWord: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}synonym_word']),
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      baselang: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}baselang']),
    );
  }

  @override
  $SynonymsTable createAlias(String alias) {
    return $SynonymsTable(attachedDatabase, alias);
  }
}

class synonyms extends DataClass implements Insertable<synonyms> {
  final int id;
  final String uuid;
  final int? baseWord;
  final int? synonymWord;
  final String name;
  final int? baselang;
  const synonyms(
      {required this.id,
      required this.uuid,
      this.baseWord,
      this.synonymWord,
      required this.name,
      this.baselang});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    if (!nullToAbsent || baseWord != null) {
      map['base_word'] = Variable<int>(baseWord);
    }
    if (!nullToAbsent || synonymWord != null) {
      map['synonym_word'] = Variable<int>(synonymWord);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || baselang != null) {
      map['baselang'] = Variable<int>(baselang);
    }
    return map;
  }

  SynonymsCompanion toCompanion(bool nullToAbsent) {
    return SynonymsCompanion(
      id: Value(id),
      uuid: Value(uuid),
      baseWord: baseWord == null && nullToAbsent
          ? const Value.absent()
          : Value(baseWord),
      synonymWord: synonymWord == null && nullToAbsent
          ? const Value.absent()
          : Value(synonymWord),
      name: Value(name),
      baselang: baselang == null && nullToAbsent
          ? const Value.absent()
          : Value(baselang),
    );
  }

  factory synonyms.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return synonyms(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      baseWord: serializer.fromJson<int?>(json['baseWord']),
      synonymWord: serializer.fromJson<int?>(json['synonymWord']),
      name: serializer.fromJson<String>(json['name']),
      baselang: serializer.fromJson<int?>(json['baselang']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'baseWord': serializer.toJson<int?>(baseWord),
      'synonymWord': serializer.toJson<int?>(synonymWord),
      'name': serializer.toJson<String>(name),
      'baselang': serializer.toJson<int?>(baselang),
    };
  }

  synonyms copyWith(
          {int? id,
          String? uuid,
          Value<int?> baseWord = const Value.absent(),
          Value<int?> synonymWord = const Value.absent(),
          String? name,
          Value<int?> baselang = const Value.absent()}) =>
      synonyms(
        id: id ?? this.id,
        uuid: uuid ?? this.uuid,
        baseWord: baseWord.present ? baseWord.value : this.baseWord,
        synonymWord: synonymWord.present ? synonymWord.value : this.synonymWord,
        name: name ?? this.name,
        baselang: baselang.present ? baselang.value : this.baselang,
      );
  @override
  String toString() {
    return (StringBuffer('synonyms(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('baseWord: $baseWord, ')
          ..write('synonymWord: $synonymWord, ')
          ..write('name: $name, ')
          ..write('baselang: $baselang')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, uuid, baseWord, synonymWord, name, baselang);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is synonyms &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.baseWord == this.baseWord &&
          other.synonymWord == this.synonymWord &&
          other.name == this.name &&
          other.baselang == this.baselang);
}

class SynonymsCompanion extends UpdateCompanion<synonyms> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<int?> baseWord;
  final Value<int?> synonymWord;
  final Value<String> name;
  final Value<int?> baselang;
  const SynonymsCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.baseWord = const Value.absent(),
    this.synonymWord = const Value.absent(),
    this.name = const Value.absent(),
    this.baselang = const Value.absent(),
  });
  SynonymsCompanion.insert({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.baseWord = const Value.absent(),
    this.synonymWord = const Value.absent(),
    required String name,
    this.baselang = const Value.absent(),
  }) : name = Value(name);
  static Insertable<synonyms> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<int>? baseWord,
    Expression<int>? synonymWord,
    Expression<String>? name,
    Expression<int>? baselang,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (baseWord != null) 'base_word': baseWord,
      if (synonymWord != null) 'synonym_word': synonymWord,
      if (name != null) 'name': name,
      if (baselang != null) 'baselang': baselang,
    });
  }

  SynonymsCompanion copyWith(
      {Value<int>? id,
      Value<String>? uuid,
      Value<int?>? baseWord,
      Value<int?>? synonymWord,
      Value<String>? name,
      Value<int?>? baselang}) {
    return SynonymsCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      baseWord: baseWord ?? this.baseWord,
      synonymWord: synonymWord ?? this.synonymWord,
      name: name ?? this.name,
      baselang: baselang ?? this.baselang,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (baseWord.present) {
      map['base_word'] = Variable<int>(baseWord.value);
    }
    if (synonymWord.present) {
      map['synonym_word'] = Variable<int>(synonymWord.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (baselang.present) {
      map['baselang'] = Variable<int>(baselang.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SynonymsCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('baseWord: $baseWord, ')
          ..write('synonymWord: $synonymWord, ')
          ..write('name: $name, ')
          ..write('baselang: $baselang')
          ..write(')'))
        .toString();
  }
}

class $TranslatedWordsTable extends TranslatedWords
    with TableInfo<$TranslatedWordsTable, translatedwords> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TranslatedWordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
      'uuid', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => const Uuid().v4());
  static const VerificationMeta _baselangMeta =
      const VerificationMeta('baselang');
  @override
  late final GeneratedColumn<int> baselang = GeneratedColumn<int>(
      'baselang', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES languages (id)'));
  static const VerificationMeta _targetLangMeta =
      const VerificationMeta('targetLang');
  @override
  late final GeneratedColumn<int> targetLang = GeneratedColumn<int>(
      'target_lang', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES languages (id)'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _translatedNameMeta =
      const VerificationMeta('translatedName');
  @override
  late final GeneratedColumn<String> translatedName = GeneratedColumn<String>(
      'translated_name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, uuid, baselang, targetLang, name, translatedName];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'translated_words';
  @override
  VerificationContext validateIntegrity(Insertable<translatedwords> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('uuid')) {
      context.handle(
          _uuidMeta, uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta));
    }
    if (data.containsKey('baselang')) {
      context.handle(_baselangMeta,
          baselang.isAcceptableOrUnknown(data['baselang']!, _baselangMeta));
    }
    if (data.containsKey('target_lang')) {
      context.handle(
          _targetLangMeta,
          targetLang.isAcceptableOrUnknown(
              data['target_lang']!, _targetLangMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('translated_name')) {
      context.handle(
          _translatedNameMeta,
          translatedName.isAcceptableOrUnknown(
              data['translated_name']!, _translatedNameMeta));
    } else if (isInserting) {
      context.missing(_translatedNameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  translatedwords map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return translatedwords(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      uuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uuid'])!,
      baselang: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}baselang']),
      targetLang: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}target_lang']),
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      translatedName: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}translated_name'])!,
    );
  }

  @override
  $TranslatedWordsTable createAlias(String alias) {
    return $TranslatedWordsTable(attachedDatabase, alias);
  }
}

class translatedwords extends DataClass implements Insertable<translatedwords> {
  final int id;
  final String uuid;
  final int? baselang;
  final int? targetLang;
  final String name;
  final String translatedName;
  const translatedwords(
      {required this.id,
      required this.uuid,
      this.baselang,
      this.targetLang,
      required this.name,
      required this.translatedName});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    if (!nullToAbsent || baselang != null) {
      map['baselang'] = Variable<int>(baselang);
    }
    if (!nullToAbsent || targetLang != null) {
      map['target_lang'] = Variable<int>(targetLang);
    }
    map['name'] = Variable<String>(name);
    map['translated_name'] = Variable<String>(translatedName);
    return map;
  }

  TranslatedWordsCompanion toCompanion(bool nullToAbsent) {
    return TranslatedWordsCompanion(
      id: Value(id),
      uuid: Value(uuid),
      baselang: baselang == null && nullToAbsent
          ? const Value.absent()
          : Value(baselang),
      targetLang: targetLang == null && nullToAbsent
          ? const Value.absent()
          : Value(targetLang),
      name: Value(name),
      translatedName: Value(translatedName),
    );
  }

  factory translatedwords.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return translatedwords(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      baselang: serializer.fromJson<int?>(json['baselang']),
      targetLang: serializer.fromJson<int?>(json['targetLang']),
      name: serializer.fromJson<String>(json['name']),
      translatedName: serializer.fromJson<String>(json['translatedName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'baselang': serializer.toJson<int?>(baselang),
      'targetLang': serializer.toJson<int?>(targetLang),
      'name': serializer.toJson<String>(name),
      'translatedName': serializer.toJson<String>(translatedName),
    };
  }

  translatedwords copyWith(
          {int? id,
          String? uuid,
          Value<int?> baselang = const Value.absent(),
          Value<int?> targetLang = const Value.absent(),
          String? name,
          String? translatedName}) =>
      translatedwords(
        id: id ?? this.id,
        uuid: uuid ?? this.uuid,
        baselang: baselang.present ? baselang.value : this.baselang,
        targetLang: targetLang.present ? targetLang.value : this.targetLang,
        name: name ?? this.name,
        translatedName: translatedName ?? this.translatedName,
      );
  @override
  String toString() {
    return (StringBuffer('translatedwords(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('baselang: $baselang, ')
          ..write('targetLang: $targetLang, ')
          ..write('name: $name, ')
          ..write('translatedName: $translatedName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, uuid, baselang, targetLang, name, translatedName);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is translatedwords &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.baselang == this.baselang &&
          other.targetLang == this.targetLang &&
          other.name == this.name &&
          other.translatedName == this.translatedName);
}

class TranslatedWordsCompanion extends UpdateCompanion<translatedwords> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<int?> baselang;
  final Value<int?> targetLang;
  final Value<String> name;
  final Value<String> translatedName;
  const TranslatedWordsCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.baselang = const Value.absent(),
    this.targetLang = const Value.absent(),
    this.name = const Value.absent(),
    this.translatedName = const Value.absent(),
  });
  TranslatedWordsCompanion.insert({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.baselang = const Value.absent(),
    this.targetLang = const Value.absent(),
    required String name,
    required String translatedName,
  })  : name = Value(name),
        translatedName = Value(translatedName);
  static Insertable<translatedwords> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<int>? baselang,
    Expression<int>? targetLang,
    Expression<String>? name,
    Expression<String>? translatedName,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (baselang != null) 'baselang': baselang,
      if (targetLang != null) 'target_lang': targetLang,
      if (name != null) 'name': name,
      if (translatedName != null) 'translated_name': translatedName,
    });
  }

  TranslatedWordsCompanion copyWith(
      {Value<int>? id,
      Value<String>? uuid,
      Value<int?>? baselang,
      Value<int?>? targetLang,
      Value<String>? name,
      Value<String>? translatedName}) {
    return TranslatedWordsCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      baselang: baselang ?? this.baselang,
      targetLang: targetLang ?? this.targetLang,
      name: name ?? this.name,
      translatedName: translatedName ?? this.translatedName,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (baselang.present) {
      map['baselang'] = Variable<int>(baselang.value);
    }
    if (targetLang.present) {
      map['target_lang'] = Variable<int>(targetLang.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (translatedName.present) {
      map['translated_name'] = Variable<String>(translatedName.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TranslatedWordsCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('baselang: $baselang, ')
          ..write('targetLang: $targetLang, ')
          ..write('name: $name, ')
          ..write('translatedName: $translatedName')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  late final $LanguagesTable languages = $LanguagesTable(this);
  late final $WordsTable words = $WordsTable(this);
  late final $SynonymsTable synonyms = $SynonymsTable(this);
  late final $TranslatedWordsTable translatedWords =
      $TranslatedWordsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [languages, words, synonyms, translatedWords];
}
