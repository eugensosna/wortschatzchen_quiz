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
      'mean', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _baseLangMeta =
      const VerificationMeta('baseLang');
  @override
  late final GeneratedColumn<int> baseLang = GeneratedColumn<int>(
      'base_lang', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES languages (id)'));
  static const VerificationMeta _rootWordIDMeta =
      const VerificationMeta('rootWordID');
  @override
  late final GeneratedColumn<int> rootWordID = GeneratedColumn<int>(
      'root_word_i_d', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, uuid, name, description, mean, baseLang, rootWordID];
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
    } else if (isInserting) {
      context.missing(_meanMeta);
    }
    if (data.containsKey('base_lang')) {
      context.handle(_baseLangMeta,
          baseLang.isAcceptableOrUnknown(data['base_lang']!, _baseLangMeta));
    } else if (isInserting) {
      context.missing(_baseLangMeta);
    }
    if (data.containsKey('root_word_i_d')) {
      context.handle(
          _rootWordIDMeta,
          rootWordID.isAcceptableOrUnknown(
              data['root_word_i_d']!, _rootWordIDMeta));
    } else if (isInserting) {
      context.missing(_rootWordIDMeta);
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
          .read(DriftSqlType.string, data['${effectivePrefix}mean'])!,
      baseLang: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}base_lang'])!,
      rootWordID: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}root_word_i_d'])!,
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
  final String mean;
  final int baseLang;
  final int rootWordID;
  const Word(
      {required this.id,
      required this.uuid,
      required this.name,
      required this.description,
      required this.mean,
      required this.baseLang,
      required this.rootWordID});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    map['mean'] = Variable<String>(mean);
    map['base_lang'] = Variable<int>(baseLang);
    map['root_word_i_d'] = Variable<int>(rootWordID);
    return map;
  }

  WordsCompanion toCompanion(bool nullToAbsent) {
    return WordsCompanion(
      id: Value(id),
      uuid: Value(uuid),
      name: Value(name),
      description: Value(description),
      mean: Value(mean),
      baseLang: Value(baseLang),
      rootWordID: Value(rootWordID),
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
      mean: serializer.fromJson<String>(json['mean']),
      baseLang: serializer.fromJson<int>(json['baseLang']),
      rootWordID: serializer.fromJson<int>(json['rootWordID']),
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
      'mean': serializer.toJson<String>(mean),
      'baseLang': serializer.toJson<int>(baseLang),
      'rootWordID': serializer.toJson<int>(rootWordID),
    };
  }

  Word copyWith(
          {int? id,
          String? uuid,
          String? name,
          String? description,
          String? mean,
          int? baseLang,
          int? rootWordID}) =>
      Word(
        id: id ?? this.id,
        uuid: uuid ?? this.uuid,
        name: name ?? this.name,
        description: description ?? this.description,
        mean: mean ?? this.mean,
        baseLang: baseLang ?? this.baseLang,
        rootWordID: rootWordID ?? this.rootWordID,
      );
  @override
  String toString() {
    return (StringBuffer('Word(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('mean: $mean, ')
          ..write('baseLang: $baseLang, ')
          ..write('rootWordID: $rootWordID')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, uuid, name, description, mean, baseLang, rootWordID);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Word &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.name == this.name &&
          other.description == this.description &&
          other.mean == this.mean &&
          other.baseLang == this.baseLang &&
          other.rootWordID == this.rootWordID);
}

class WordsCompanion extends UpdateCompanion<Word> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<String> name;
  final Value<String> description;
  final Value<String> mean;
  final Value<int> baseLang;
  final Value<int> rootWordID;
  const WordsCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.mean = const Value.absent(),
    this.baseLang = const Value.absent(),
    this.rootWordID = const Value.absent(),
  });
  WordsCompanion.insert({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    required String name,
    required String description,
    required String mean,
    required int baseLang,
    required int rootWordID,
  })  : name = Value(name),
        description = Value(description),
        mean = Value(mean),
        baseLang = Value(baseLang),
        rootWordID = Value(rootWordID);
  static Insertable<Word> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? mean,
    Expression<int>? baseLang,
    Expression<int>? rootWordID,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (mean != null) 'mean': mean,
      if (baseLang != null) 'base_lang': baseLang,
      if (rootWordID != null) 'root_word_i_d': rootWordID,
    });
  }

  WordsCompanion copyWith(
      {Value<int>? id,
      Value<String>? uuid,
      Value<String>? name,
      Value<String>? description,
      Value<String>? mean,
      Value<int>? baseLang,
      Value<int>? rootWordID}) {
    return WordsCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      description: description ?? this.description,
      mean: mean ?? this.mean,
      baseLang: baseLang ?? this.baseLang,
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
    if (baseLang.present) {
      map['base_lang'] = Variable<int>(baseLang.value);
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
          ..write('baseLang: $baseLang, ')
          ..write('rootWordID: $rootWordID')
          ..write(')'))
        .toString();
  }
}

class $SynonymsTable extends Synonyms with TableInfo<$SynonymsTable, Synonym> {
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
      'base_word', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES words (id)'));
  static const VerificationMeta _synonymWordMeta =
      const VerificationMeta('synonymWord');
  @override
  late final GeneratedColumn<int> synonymWord = GeneratedColumn<int>(
      'synonym_word', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES words (id)'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _baseLangMeta =
      const VerificationMeta('baseLang');
  @override
  late final GeneratedColumn<int> baseLang = GeneratedColumn<int>(
      'base_lang', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES languages (id)'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, uuid, baseWord, synonymWord, name, baseLang];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'synonyms';
  @override
  VerificationContext validateIntegrity(Insertable<Synonym> instance,
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
    } else if (isInserting) {
      context.missing(_baseWordMeta);
    }
    if (data.containsKey('synonym_word')) {
      context.handle(
          _synonymWordMeta,
          synonymWord.isAcceptableOrUnknown(
              data['synonym_word']!, _synonymWordMeta));
    } else if (isInserting) {
      context.missing(_synonymWordMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('base_lang')) {
      context.handle(_baseLangMeta,
          baseLang.isAcceptableOrUnknown(data['base_lang']!, _baseLangMeta));
    } else if (isInserting) {
      context.missing(_baseLangMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Synonym map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Synonym(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      uuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uuid'])!,
      baseWord: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}base_word'])!,
      synonymWord: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}synonym_word'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      baseLang: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}base_lang'])!,
    );
  }

  @override
  $SynonymsTable createAlias(String alias) {
    return $SynonymsTable(attachedDatabase, alias);
  }
}

class Synonym extends DataClass implements Insertable<Synonym> {
  final int id;
  final String uuid;
  final int baseWord;
  final int synonymWord;
  final String name;
  final int baseLang;
  const Synonym(
      {required this.id,
      required this.uuid,
      required this.baseWord,
      required this.synonymWord,
      required this.name,
      required this.baseLang});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    map['base_word'] = Variable<int>(baseWord);
    map['synonym_word'] = Variable<int>(synonymWord);
    map['name'] = Variable<String>(name);
    map['base_lang'] = Variable<int>(baseLang);
    return map;
  }

  SynonymsCompanion toCompanion(bool nullToAbsent) {
    return SynonymsCompanion(
      id: Value(id),
      uuid: Value(uuid),
      baseWord: Value(baseWord),
      synonymWord: Value(synonymWord),
      name: Value(name),
      baseLang: Value(baseLang),
    );
  }

  factory Synonym.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Synonym(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      baseWord: serializer.fromJson<int>(json['baseWord']),
      synonymWord: serializer.fromJson<int>(json['synonymWord']),
      name: serializer.fromJson<String>(json['name']),
      baseLang: serializer.fromJson<int>(json['baseLang']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'baseWord': serializer.toJson<int>(baseWord),
      'synonymWord': serializer.toJson<int>(synonymWord),
      'name': serializer.toJson<String>(name),
      'baseLang': serializer.toJson<int>(baseLang),
    };
  }

  Synonym copyWith(
          {int? id,
          String? uuid,
          int? baseWord,
          int? synonymWord,
          String? name,
          int? baseLang}) =>
      Synonym(
        id: id ?? this.id,
        uuid: uuid ?? this.uuid,
        baseWord: baseWord ?? this.baseWord,
        synonymWord: synonymWord ?? this.synonymWord,
        name: name ?? this.name,
        baseLang: baseLang ?? this.baseLang,
      );
  @override
  String toString() {
    return (StringBuffer('Synonym(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('baseWord: $baseWord, ')
          ..write('synonymWord: $synonymWord, ')
          ..write('name: $name, ')
          ..write('baseLang: $baseLang')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, uuid, baseWord, synonymWord, name, baseLang);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Synonym &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.baseWord == this.baseWord &&
          other.synonymWord == this.synonymWord &&
          other.name == this.name &&
          other.baseLang == this.baseLang);
}

class SynonymsCompanion extends UpdateCompanion<Synonym> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<int> baseWord;
  final Value<int> synonymWord;
  final Value<String> name;
  final Value<int> baseLang;
  const SynonymsCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.baseWord = const Value.absent(),
    this.synonymWord = const Value.absent(),
    this.name = const Value.absent(),
    this.baseLang = const Value.absent(),
  });
  SynonymsCompanion.insert({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    required int baseWord,
    required int synonymWord,
    required String name,
    required int baseLang,
  })  : baseWord = Value(baseWord),
        synonymWord = Value(synonymWord),
        name = Value(name),
        baseLang = Value(baseLang);
  static Insertable<Synonym> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<int>? baseWord,
    Expression<int>? synonymWord,
    Expression<String>? name,
    Expression<int>? baseLang,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (baseWord != null) 'base_word': baseWord,
      if (synonymWord != null) 'synonym_word': synonymWord,
      if (name != null) 'name': name,
      if (baseLang != null) 'base_lang': baseLang,
    });
  }

  SynonymsCompanion copyWith(
      {Value<int>? id,
      Value<String>? uuid,
      Value<int>? baseWord,
      Value<int>? synonymWord,
      Value<String>? name,
      Value<int>? baseLang}) {
    return SynonymsCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      baseWord: baseWord ?? this.baseWord,
      synonymWord: synonymWord ?? this.synonymWord,
      name: name ?? this.name,
      baseLang: baseLang ?? this.baseLang,
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
    if (baseLang.present) {
      map['base_lang'] = Variable<int>(baseLang.value);
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
          ..write('baseLang: $baseLang')
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
  static const VerificationMeta _baseLangMeta =
      const VerificationMeta('baseLang');
  @override
  late final GeneratedColumn<int> baseLang = GeneratedColumn<int>(
      'base_lang', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES languages (id)'));
  static const VerificationMeta _targetLangMeta =
      const VerificationMeta('targetLang');
  @override
  late final GeneratedColumn<int> targetLang = GeneratedColumn<int>(
      'target_lang', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES languages (id)'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _translatedNameMeta =
      const VerificationMeta('translatedName');
  @override
  late final GeneratedColumn<String> translatedName = GeneratedColumn<String>(
      'translated_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, uuid, baseLang, targetLang, name, translatedName];
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
    if (data.containsKey('base_lang')) {
      context.handle(_baseLangMeta,
          baseLang.isAcceptableOrUnknown(data['base_lang']!, _baseLangMeta));
    } else if (isInserting) {
      context.missing(_baseLangMeta);
    }
    if (data.containsKey('target_lang')) {
      context.handle(
          _targetLangMeta,
          targetLang.isAcceptableOrUnknown(
              data['target_lang']!, _targetLangMeta));
    } else if (isInserting) {
      context.missing(_targetLangMeta);
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
      baseLang: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}base_lang'])!,
      targetLang: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}target_lang'])!,
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
  final int baseLang;
  final int targetLang;
  final String name;
  final String translatedName;
  const translatedwords(
      {required this.id,
      required this.uuid,
      required this.baseLang,
      required this.targetLang,
      required this.name,
      required this.translatedName});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    map['base_lang'] = Variable<int>(baseLang);
    map['target_lang'] = Variable<int>(targetLang);
    map['name'] = Variable<String>(name);
    map['translated_name'] = Variable<String>(translatedName);
    return map;
  }

  TranslatedWordsCompanion toCompanion(bool nullToAbsent) {
    return TranslatedWordsCompanion(
      id: Value(id),
      uuid: Value(uuid),
      baseLang: Value(baseLang),
      targetLang: Value(targetLang),
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
      baseLang: serializer.fromJson<int>(json['baseLang']),
      targetLang: serializer.fromJson<int>(json['targetLang']),
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
      'baseLang': serializer.toJson<int>(baseLang),
      'targetLang': serializer.toJson<int>(targetLang),
      'name': serializer.toJson<String>(name),
      'translatedName': serializer.toJson<String>(translatedName),
    };
  }

  translatedwords copyWith(
          {int? id,
          String? uuid,
          int? baseLang,
          int? targetLang,
          String? name,
          String? translatedName}) =>
      translatedwords(
        id: id ?? this.id,
        uuid: uuid ?? this.uuid,
        baseLang: baseLang ?? this.baseLang,
        targetLang: targetLang ?? this.targetLang,
        name: name ?? this.name,
        translatedName: translatedName ?? this.translatedName,
      );
  @override
  String toString() {
    return (StringBuffer('translatedwords(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('baseLang: $baseLang, ')
          ..write('targetLang: $targetLang, ')
          ..write('name: $name, ')
          ..write('translatedName: $translatedName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, uuid, baseLang, targetLang, name, translatedName);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is translatedwords &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.baseLang == this.baseLang &&
          other.targetLang == this.targetLang &&
          other.name == this.name &&
          other.translatedName == this.translatedName);
}

class TranslatedWordsCompanion extends UpdateCompanion<translatedwords> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<int> baseLang;
  final Value<int> targetLang;
  final Value<String> name;
  final Value<String> translatedName;
  const TranslatedWordsCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.baseLang = const Value.absent(),
    this.targetLang = const Value.absent(),
    this.name = const Value.absent(),
    this.translatedName = const Value.absent(),
  });
  TranslatedWordsCompanion.insert({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    required int baseLang,
    required int targetLang,
    required String name,
    required String translatedName,
  })  : baseLang = Value(baseLang),
        targetLang = Value(targetLang),
        name = Value(name),
        translatedName = Value(translatedName);
  static Insertable<translatedwords> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<int>? baseLang,
    Expression<int>? targetLang,
    Expression<String>? name,
    Expression<String>? translatedName,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (baseLang != null) 'base_lang': baseLang,
      if (targetLang != null) 'target_lang': targetLang,
      if (name != null) 'name': name,
      if (translatedName != null) 'translated_name': translatedName,
    });
  }

  TranslatedWordsCompanion copyWith(
      {Value<int>? id,
      Value<String>? uuid,
      Value<int>? baseLang,
      Value<int>? targetLang,
      Value<String>? name,
      Value<String>? translatedName}) {
    return TranslatedWordsCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      baseLang: baseLang ?? this.baseLang,
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
    if (baseLang.present) {
      map['base_lang'] = Variable<int>(baseLang.value);
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
          ..write('baseLang: $baseLang, ')
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
