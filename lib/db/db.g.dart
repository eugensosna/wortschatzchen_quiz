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
  static const VerificationMeta _immportantMeta =
      const VerificationMeta('immportant');
  @override
  late final GeneratedColumn<String> immportant = GeneratedColumn<String>(
      'immportant', aliasedName, false,
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
  static const VerificationMeta _baseFormMeta =
      const VerificationMeta('baseForm');
  @override
  late final GeneratedColumn<String> baseForm = GeneratedColumn<String>(
      'base_form', aliasedName, false,
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
  List<GeneratedColumn> get $columns => [
        id,
        uuid,
        name,
        immportant,
        description,
        mean,
        baseForm,
        baseLang,
        rootWordID
      ];
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
    if (data.containsKey('immportant')) {
      context.handle(
          _immportantMeta,
          immportant.isAcceptableOrUnknown(
              data['immportant']!, _immportantMeta));
    } else if (isInserting) {
      context.missing(_immportantMeta);
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
    if (data.containsKey('base_form')) {
      context.handle(_baseFormMeta,
          baseForm.isAcceptableOrUnknown(data['base_form']!, _baseFormMeta));
    } else if (isInserting) {
      context.missing(_baseFormMeta);
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
      immportant: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}immportant'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      mean: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mean'])!,
      baseForm: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}base_form'])!,
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
  final String immportant;
  final String description;
  final String mean;
  final String baseForm;
  final int baseLang;
  final int rootWordID;
  const Word(
      {required this.id,
      required this.uuid,
      required this.name,
      required this.immportant,
      required this.description,
      required this.mean,
      required this.baseForm,
      required this.baseLang,
      required this.rootWordID});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    map['name'] = Variable<String>(name);
    map['immportant'] = Variable<String>(immportant);
    map['description'] = Variable<String>(description);
    map['mean'] = Variable<String>(mean);
    map['base_form'] = Variable<String>(baseForm);
    map['base_lang'] = Variable<int>(baseLang);
    map['root_word_i_d'] = Variable<int>(rootWordID);
    return map;
  }

  WordsCompanion toCompanion(bool nullToAbsent) {
    return WordsCompanion(
      id: Value(id),
      uuid: Value(uuid),
      name: Value(name),
      immportant: Value(immportant),
      description: Value(description),
      mean: Value(mean),
      baseForm: Value(baseForm),
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
      immportant: serializer.fromJson<String>(json['immportant']),
      description: serializer.fromJson<String>(json['description']),
      mean: serializer.fromJson<String>(json['mean']),
      baseForm: serializer.fromJson<String>(json['baseForm']),
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
      'immportant': serializer.toJson<String>(immportant),
      'description': serializer.toJson<String>(description),
      'mean': serializer.toJson<String>(mean),
      'baseForm': serializer.toJson<String>(baseForm),
      'baseLang': serializer.toJson<int>(baseLang),
      'rootWordID': serializer.toJson<int>(rootWordID),
    };
  }

  Word copyWith(
          {int? id,
          String? uuid,
          String? name,
          String? immportant,
          String? description,
          String? mean,
          String? baseForm,
          int? baseLang,
          int? rootWordID}) =>
      Word(
        id: id ?? this.id,
        uuid: uuid ?? this.uuid,
        name: name ?? this.name,
        immportant: immportant ?? this.immportant,
        description: description ?? this.description,
        mean: mean ?? this.mean,
        baseForm: baseForm ?? this.baseForm,
        baseLang: baseLang ?? this.baseLang,
        rootWordID: rootWordID ?? this.rootWordID,
      );
  @override
  String toString() {
    return (StringBuffer('Word(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('name: $name, ')
          ..write('immportant: $immportant, ')
          ..write('description: $description, ')
          ..write('mean: $mean, ')
          ..write('baseForm: $baseForm, ')
          ..write('baseLang: $baseLang, ')
          ..write('rootWordID: $rootWordID')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, uuid, name, immportant, description, mean,
      baseForm, baseLang, rootWordID);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Word &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.name == this.name &&
          other.immportant == this.immportant &&
          other.description == this.description &&
          other.mean == this.mean &&
          other.baseForm == this.baseForm &&
          other.baseLang == this.baseLang &&
          other.rootWordID == this.rootWordID);
}

class WordsCompanion extends UpdateCompanion<Word> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<String> name;
  final Value<String> immportant;
  final Value<String> description;
  final Value<String> mean;
  final Value<String> baseForm;
  final Value<int> baseLang;
  final Value<int> rootWordID;
  const WordsCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.name = const Value.absent(),
    this.immportant = const Value.absent(),
    this.description = const Value.absent(),
    this.mean = const Value.absent(),
    this.baseForm = const Value.absent(),
    this.baseLang = const Value.absent(),
    this.rootWordID = const Value.absent(),
  });
  WordsCompanion.insert({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    required String name,
    required String immportant,
    required String description,
    required String mean,
    required String baseForm,
    required int baseLang,
    required int rootWordID,
  })  : name = Value(name),
        immportant = Value(immportant),
        description = Value(description),
        mean = Value(mean),
        baseForm = Value(baseForm),
        baseLang = Value(baseLang),
        rootWordID = Value(rootWordID);
  static Insertable<Word> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<String>? name,
    Expression<String>? immportant,
    Expression<String>? description,
    Expression<String>? mean,
    Expression<String>? baseForm,
    Expression<int>? baseLang,
    Expression<int>? rootWordID,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (name != null) 'name': name,
      if (immportant != null) 'immportant': immportant,
      if (description != null) 'description': description,
      if (mean != null) 'mean': mean,
      if (baseForm != null) 'base_form': baseForm,
      if (baseLang != null) 'base_lang': baseLang,
      if (rootWordID != null) 'root_word_i_d': rootWordID,
    });
  }

  WordsCompanion copyWith(
      {Value<int>? id,
      Value<String>? uuid,
      Value<String>? name,
      Value<String>? immportant,
      Value<String>? description,
      Value<String>? mean,
      Value<String>? baseForm,
      Value<int>? baseLang,
      Value<int>? rootWordID}) {
    return WordsCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      immportant: immportant ?? this.immportant,
      description: description ?? this.description,
      mean: mean ?? this.mean,
      baseForm: baseForm ?? this.baseForm,
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
    if (immportant.present) {
      map['immportant'] = Variable<String>(immportant.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (mean.present) {
      map['mean'] = Variable<String>(mean.value);
    }
    if (baseForm.present) {
      map['base_form'] = Variable<String>(baseForm.value);
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
          ..write('immportant: $immportant, ')
          ..write('description: $description, ')
          ..write('mean: $mean, ')
          ..write('baseForm: $baseForm, ')
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
  static const VerificationMeta _translatedNameMeta =
      const VerificationMeta('translatedName');
  @override
  late final GeneratedColumn<String> translatedName = GeneratedColumn<String>(
      'translated_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, uuid, baseWord, synonymWord, name, baseLang, translatedName];
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
      translatedName: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}translated_name'])!,
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
  final String translatedName;
  const Synonym(
      {required this.id,
      required this.uuid,
      required this.baseWord,
      required this.synonymWord,
      required this.name,
      required this.baseLang,
      required this.translatedName});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    map['base_word'] = Variable<int>(baseWord);
    map['synonym_word'] = Variable<int>(synonymWord);
    map['name'] = Variable<String>(name);
    map['base_lang'] = Variable<int>(baseLang);
    map['translated_name'] = Variable<String>(translatedName);
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
      translatedName: Value(translatedName),
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
      translatedName: serializer.fromJson<String>(json['translatedName']),
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
      'translatedName': serializer.toJson<String>(translatedName),
    };
  }

  Synonym copyWith(
          {int? id,
          String? uuid,
          int? baseWord,
          int? synonymWord,
          String? name,
          int? baseLang,
          String? translatedName}) =>
      Synonym(
        id: id ?? this.id,
        uuid: uuid ?? this.uuid,
        baseWord: baseWord ?? this.baseWord,
        synonymWord: synonymWord ?? this.synonymWord,
        name: name ?? this.name,
        baseLang: baseLang ?? this.baseLang,
        translatedName: translatedName ?? this.translatedName,
      );
  @override
  String toString() {
    return (StringBuffer('Synonym(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('baseWord: $baseWord, ')
          ..write('synonymWord: $synonymWord, ')
          ..write('name: $name, ')
          ..write('baseLang: $baseLang, ')
          ..write('translatedName: $translatedName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, uuid, baseWord, synonymWord, name, baseLang, translatedName);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Synonym &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.baseWord == this.baseWord &&
          other.synonymWord == this.synonymWord &&
          other.name == this.name &&
          other.baseLang == this.baseLang &&
          other.translatedName == this.translatedName);
}

class SynonymsCompanion extends UpdateCompanion<Synonym> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<int> baseWord;
  final Value<int> synonymWord;
  final Value<String> name;
  final Value<int> baseLang;
  final Value<String> translatedName;
  const SynonymsCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.baseWord = const Value.absent(),
    this.synonymWord = const Value.absent(),
    this.name = const Value.absent(),
    this.baseLang = const Value.absent(),
    this.translatedName = const Value.absent(),
  });
  SynonymsCompanion.insert({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    required int baseWord,
    required int synonymWord,
    required String name,
    required int baseLang,
    required String translatedName,
  })  : baseWord = Value(baseWord),
        synonymWord = Value(synonymWord),
        name = Value(name),
        baseLang = Value(baseLang),
        translatedName = Value(translatedName);
  static Insertable<Synonym> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<int>? baseWord,
    Expression<int>? synonymWord,
    Expression<String>? name,
    Expression<int>? baseLang,
    Expression<String>? translatedName,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (baseWord != null) 'base_word': baseWord,
      if (synonymWord != null) 'synonym_word': synonymWord,
      if (name != null) 'name': name,
      if (baseLang != null) 'base_lang': baseLang,
      if (translatedName != null) 'translated_name': translatedName,
    });
  }

  SynonymsCompanion copyWith(
      {Value<int>? id,
      Value<String>? uuid,
      Value<int>? baseWord,
      Value<int>? synonymWord,
      Value<String>? name,
      Value<int>? baseLang,
      Value<String>? translatedName}) {
    return SynonymsCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      baseWord: baseWord ?? this.baseWord,
      synonymWord: synonymWord ?? this.synonymWord,
      name: name ?? this.name,
      baseLang: baseLang ?? this.baseLang,
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
    if (translatedName.present) {
      map['translated_name'] = Variable<String>(translatedName.value);
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
          ..write('baseLang: $baseLang, ')
          ..write('translatedName: $translatedName')
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

class $LeipzigDataFromIntranetTable extends LeipzigDataFromIntranet
    with TableInfo<$LeipzigDataFromIntranetTable, LeipzigDataFromIntranetData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LeipzigDataFromIntranetTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
      'url', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _htmlMeta = const VerificationMeta('html');
  @override
  late final GeneratedColumn<String> html = GeneratedColumn<String>(
      'html', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _articleMeta =
      const VerificationMeta('article');
  @override
  late final GeneratedColumn<String> article = GeneratedColumn<String>(
      'article', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _KindOfWortMeta =
      const VerificationMeta('KindOfWort');
  @override
  late final GeneratedColumn<String> KindOfWort = GeneratedColumn<String>(
      'kind_of_wort', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _wordOfBaseMeta =
      const VerificationMeta('wordOfBase');
  @override
  late final GeneratedColumn<String> wordOfBase = GeneratedColumn<String>(
      'word_of_base', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, uuid, baseWord, url, html, article, KindOfWort, wordOfBase];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'leipzig_data_from_intranet';
  @override
  VerificationContext validateIntegrity(
      Insertable<LeipzigDataFromIntranetData> instance,
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
    if (data.containsKey('url')) {
      context.handle(
          _urlMeta, url.isAcceptableOrUnknown(data['url']!, _urlMeta));
    } else if (isInserting) {
      context.missing(_urlMeta);
    }
    if (data.containsKey('html')) {
      context.handle(
          _htmlMeta, html.isAcceptableOrUnknown(data['html']!, _htmlMeta));
    } else if (isInserting) {
      context.missing(_htmlMeta);
    }
    if (data.containsKey('article')) {
      context.handle(_articleMeta,
          article.isAcceptableOrUnknown(data['article']!, _articleMeta));
    } else if (isInserting) {
      context.missing(_articleMeta);
    }
    if (data.containsKey('kind_of_wort')) {
      context.handle(
          _KindOfWortMeta,
          KindOfWort.isAcceptableOrUnknown(
              data['kind_of_wort']!, _KindOfWortMeta));
    } else if (isInserting) {
      context.missing(_KindOfWortMeta);
    }
    if (data.containsKey('word_of_base')) {
      context.handle(
          _wordOfBaseMeta,
          wordOfBase.isAcceptableOrUnknown(
              data['word_of_base']!, _wordOfBaseMeta));
    } else if (isInserting) {
      context.missing(_wordOfBaseMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LeipzigDataFromIntranetData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LeipzigDataFromIntranetData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      uuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uuid'])!,
      baseWord: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}base_word'])!,
      url: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}url'])!,
      html: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}html'])!,
      article: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}article'])!,
      KindOfWort: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}kind_of_wort'])!,
      wordOfBase: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}word_of_base'])!,
    );
  }

  @override
  $LeipzigDataFromIntranetTable createAlias(String alias) {
    return $LeipzigDataFromIntranetTable(attachedDatabase, alias);
  }
}

class LeipzigDataFromIntranetData extends DataClass
    implements Insertable<LeipzigDataFromIntranetData> {
  final int id;
  final String uuid;
  final int baseWord;
  final String url;
  final String html;
  final String article;
  final String KindOfWort;
  final String wordOfBase;
  const LeipzigDataFromIntranetData(
      {required this.id,
      required this.uuid,
      required this.baseWord,
      required this.url,
      required this.html,
      required this.article,
      required this.KindOfWort,
      required this.wordOfBase});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    map['base_word'] = Variable<int>(baseWord);
    map['url'] = Variable<String>(url);
    map['html'] = Variable<String>(html);
    map['article'] = Variable<String>(article);
    map['kind_of_wort'] = Variable<String>(KindOfWort);
    map['word_of_base'] = Variable<String>(wordOfBase);
    return map;
  }

  LeipzigDataFromIntranetCompanion toCompanion(bool nullToAbsent) {
    return LeipzigDataFromIntranetCompanion(
      id: Value(id),
      uuid: Value(uuid),
      baseWord: Value(baseWord),
      url: Value(url),
      html: Value(html),
      article: Value(article),
      KindOfWort: Value(KindOfWort),
      wordOfBase: Value(wordOfBase),
    );
  }

  factory LeipzigDataFromIntranetData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LeipzigDataFromIntranetData(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      baseWord: serializer.fromJson<int>(json['baseWord']),
      url: serializer.fromJson<String>(json['url']),
      html: serializer.fromJson<String>(json['html']),
      article: serializer.fromJson<String>(json['article']),
      KindOfWort: serializer.fromJson<String>(json['KindOfWort']),
      wordOfBase: serializer.fromJson<String>(json['wordOfBase']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'baseWord': serializer.toJson<int>(baseWord),
      'url': serializer.toJson<String>(url),
      'html': serializer.toJson<String>(html),
      'article': serializer.toJson<String>(article),
      'KindOfWort': serializer.toJson<String>(KindOfWort),
      'wordOfBase': serializer.toJson<String>(wordOfBase),
    };
  }

  LeipzigDataFromIntranetData copyWith(
          {int? id,
          String? uuid,
          int? baseWord,
          String? url,
          String? html,
          String? article,
          String? KindOfWort,
          String? wordOfBase}) =>
      LeipzigDataFromIntranetData(
        id: id ?? this.id,
        uuid: uuid ?? this.uuid,
        baseWord: baseWord ?? this.baseWord,
        url: url ?? this.url,
        html: html ?? this.html,
        article: article ?? this.article,
        KindOfWort: KindOfWort ?? this.KindOfWort,
        wordOfBase: wordOfBase ?? this.wordOfBase,
      );
  @override
  String toString() {
    return (StringBuffer('LeipzigDataFromIntranetData(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('baseWord: $baseWord, ')
          ..write('url: $url, ')
          ..write('html: $html, ')
          ..write('article: $article, ')
          ..write('KindOfWort: $KindOfWort, ')
          ..write('wordOfBase: $wordOfBase')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, uuid, baseWord, url, html, article, KindOfWort, wordOfBase);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LeipzigDataFromIntranetData &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.baseWord == this.baseWord &&
          other.url == this.url &&
          other.html == this.html &&
          other.article == this.article &&
          other.KindOfWort == this.KindOfWort &&
          other.wordOfBase == this.wordOfBase);
}

class LeipzigDataFromIntranetCompanion
    extends UpdateCompanion<LeipzigDataFromIntranetData> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<int> baseWord;
  final Value<String> url;
  final Value<String> html;
  final Value<String> article;
  final Value<String> KindOfWort;
  final Value<String> wordOfBase;
  const LeipzigDataFromIntranetCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.baseWord = const Value.absent(),
    this.url = const Value.absent(),
    this.html = const Value.absent(),
    this.article = const Value.absent(),
    this.KindOfWort = const Value.absent(),
    this.wordOfBase = const Value.absent(),
  });
  LeipzigDataFromIntranetCompanion.insert({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    required int baseWord,
    required String url,
    required String html,
    required String article,
    required String KindOfWort,
    required String wordOfBase,
  })  : baseWord = Value(baseWord),
        url = Value(url),
        html = Value(html),
        article = Value(article),
        KindOfWort = Value(KindOfWort),
        wordOfBase = Value(wordOfBase);
  static Insertable<LeipzigDataFromIntranetData> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<int>? baseWord,
    Expression<String>? url,
    Expression<String>? html,
    Expression<String>? article,
    Expression<String>? KindOfWort,
    Expression<String>? wordOfBase,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (baseWord != null) 'base_word': baseWord,
      if (url != null) 'url': url,
      if (html != null) 'html': html,
      if (article != null) 'article': article,
      if (KindOfWort != null) 'kind_of_wort': KindOfWort,
      if (wordOfBase != null) 'word_of_base': wordOfBase,
    });
  }

  LeipzigDataFromIntranetCompanion copyWith(
      {Value<int>? id,
      Value<String>? uuid,
      Value<int>? baseWord,
      Value<String>? url,
      Value<String>? html,
      Value<String>? article,
      Value<String>? KindOfWort,
      Value<String>? wordOfBase}) {
    return LeipzigDataFromIntranetCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      baseWord: baseWord ?? this.baseWord,
      url: url ?? this.url,
      html: html ?? this.html,
      article: article ?? this.article,
      KindOfWort: KindOfWort ?? this.KindOfWort,
      wordOfBase: wordOfBase ?? this.wordOfBase,
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
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (html.present) {
      map['html'] = Variable<String>(html.value);
    }
    if (article.present) {
      map['article'] = Variable<String>(article.value);
    }
    if (KindOfWort.present) {
      map['kind_of_wort'] = Variable<String>(KindOfWort.value);
    }
    if (wordOfBase.present) {
      map['word_of_base'] = Variable<String>(wordOfBase.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LeipzigDataFromIntranetCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('baseWord: $baseWord, ')
          ..write('url: $url, ')
          ..write('html: $html, ')
          ..write('article: $article, ')
          ..write('KindOfWort: $KindOfWort, ')
          ..write('wordOfBase: $wordOfBase')
          ..write(')'))
        .toString();
  }
}

class $MeansTable extends Means with TableInfo<$MeansTable, Mean> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MeansTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _meansOrderMeta =
      const VerificationMeta('meansOrder');
  @override
  late final GeneratedColumn<int> meansOrder = GeneratedColumn<int>(
      'means_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      clientDefault: () => 0);
  @override
  List<GeneratedColumn> get $columns => [id, uuid, baseWord, name, meansOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'means';
  @override
  VerificationContext validateIntegrity(Insertable<Mean> instance,
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
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('means_order')) {
      context.handle(
          _meansOrderMeta,
          meansOrder.isAcceptableOrUnknown(
              data['means_order']!, _meansOrderMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Mean map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Mean(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      uuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uuid'])!,
      baseWord: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}base_word'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      meansOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}means_order'])!,
    );
  }

  @override
  $MeansTable createAlias(String alias) {
    return $MeansTable(attachedDatabase, alias);
  }
}

class Mean extends DataClass implements Insertable<Mean> {
  final int id;
  final String uuid;
  final int baseWord;
  final String name;
  final int meansOrder;
  const Mean(
      {required this.id,
      required this.uuid,
      required this.baseWord,
      required this.name,
      required this.meansOrder});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    map['base_word'] = Variable<int>(baseWord);
    map['name'] = Variable<String>(name);
    map['means_order'] = Variable<int>(meansOrder);
    return map;
  }

  MeansCompanion toCompanion(bool nullToAbsent) {
    return MeansCompanion(
      id: Value(id),
      uuid: Value(uuid),
      baseWord: Value(baseWord),
      name: Value(name),
      meansOrder: Value(meansOrder),
    );
  }

  factory Mean.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Mean(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      baseWord: serializer.fromJson<int>(json['baseWord']),
      name: serializer.fromJson<String>(json['name']),
      meansOrder: serializer.fromJson<int>(json['meansOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'baseWord': serializer.toJson<int>(baseWord),
      'name': serializer.toJson<String>(name),
      'meansOrder': serializer.toJson<int>(meansOrder),
    };
  }

  Mean copyWith(
          {int? id,
          String? uuid,
          int? baseWord,
          String? name,
          int? meansOrder}) =>
      Mean(
        id: id ?? this.id,
        uuid: uuid ?? this.uuid,
        baseWord: baseWord ?? this.baseWord,
        name: name ?? this.name,
        meansOrder: meansOrder ?? this.meansOrder,
      );
  @override
  String toString() {
    return (StringBuffer('Mean(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('baseWord: $baseWord, ')
          ..write('name: $name, ')
          ..write('meansOrder: $meansOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, uuid, baseWord, name, meansOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Mean &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.baseWord == this.baseWord &&
          other.name == this.name &&
          other.meansOrder == this.meansOrder);
}

class MeansCompanion extends UpdateCompanion<Mean> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<int> baseWord;
  final Value<String> name;
  final Value<int> meansOrder;
  const MeansCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.baseWord = const Value.absent(),
    this.name = const Value.absent(),
    this.meansOrder = const Value.absent(),
  });
  MeansCompanion.insert({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    required int baseWord,
    required String name,
    this.meansOrder = const Value.absent(),
  })  : baseWord = Value(baseWord),
        name = Value(name);
  static Insertable<Mean> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<int>? baseWord,
    Expression<String>? name,
    Expression<int>? meansOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (baseWord != null) 'base_word': baseWord,
      if (name != null) 'name': name,
      if (meansOrder != null) 'means_order': meansOrder,
    });
  }

  MeansCompanion copyWith(
      {Value<int>? id,
      Value<String>? uuid,
      Value<int>? baseWord,
      Value<String>? name,
      Value<int>? meansOrder}) {
    return MeansCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      baseWord: baseWord ?? this.baseWord,
      name: name ?? this.name,
      meansOrder: meansOrder ?? this.meansOrder,
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
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (meansOrder.present) {
      map['means_order'] = Variable<int>(meansOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MeansCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('baseWord: $baseWord, ')
          ..write('name: $name, ')
          ..write('meansOrder: $meansOrder')
          ..write(')'))
        .toString();
  }
}

class $SessionsTable extends Sessions with TableInfo<$SessionsTable, Session> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _typesessionMeta =
      const VerificationMeta('typesession');
  @override
  late final GeneratedColumn<String> typesession = GeneratedColumn<String>(
      'typesession', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, uuid, baseWord, typesession];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sessions';
  @override
  VerificationContext validateIntegrity(Insertable<Session> instance,
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
    if (data.containsKey('typesession')) {
      context.handle(
          _typesessionMeta,
          typesession.isAcceptableOrUnknown(
              data['typesession']!, _typesessionMeta));
    } else if (isInserting) {
      context.missing(_typesessionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Session map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Session(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      uuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uuid'])!,
      baseWord: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}base_word'])!,
      typesession: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}typesession'])!,
    );
  }

  @override
  $SessionsTable createAlias(String alias) {
    return $SessionsTable(attachedDatabase, alias);
  }
}

class Session extends DataClass implements Insertable<Session> {
  final int id;
  final String uuid;
  final int baseWord;
  final String typesession;
  const Session(
      {required this.id,
      required this.uuid,
      required this.baseWord,
      required this.typesession});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    map['base_word'] = Variable<int>(baseWord);
    map['typesession'] = Variable<String>(typesession);
    return map;
  }

  SessionsCompanion toCompanion(bool nullToAbsent) {
    return SessionsCompanion(
      id: Value(id),
      uuid: Value(uuid),
      baseWord: Value(baseWord),
      typesession: Value(typesession),
    );
  }

  factory Session.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Session(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      baseWord: serializer.fromJson<int>(json['baseWord']),
      typesession: serializer.fromJson<String>(json['typesession']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'baseWord': serializer.toJson<int>(baseWord),
      'typesession': serializer.toJson<String>(typesession),
    };
  }

  Session copyWith(
          {int? id, String? uuid, int? baseWord, String? typesession}) =>
      Session(
        id: id ?? this.id,
        uuid: uuid ?? this.uuid,
        baseWord: baseWord ?? this.baseWord,
        typesession: typesession ?? this.typesession,
      );
  @override
  String toString() {
    return (StringBuffer('Session(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('baseWord: $baseWord, ')
          ..write('typesession: $typesession')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, uuid, baseWord, typesession);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Session &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.baseWord == this.baseWord &&
          other.typesession == this.typesession);
}

class SessionsCompanion extends UpdateCompanion<Session> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<int> baseWord;
  final Value<String> typesession;
  const SessionsCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.baseWord = const Value.absent(),
    this.typesession = const Value.absent(),
  });
  SessionsCompanion.insert({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    required int baseWord,
    required String typesession,
  })  : baseWord = Value(baseWord),
        typesession = Value(typesession);
  static Insertable<Session> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<int>? baseWord,
    Expression<String>? typesession,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (baseWord != null) 'base_word': baseWord,
      if (typesession != null) 'typesession': typesession,
    });
  }

  SessionsCompanion copyWith(
      {Value<int>? id,
      Value<String>? uuid,
      Value<int>? baseWord,
      Value<String>? typesession}) {
    return SessionsCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      baseWord: baseWord ?? this.baseWord,
      typesession: typesession ?? this.typesession,
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
    if (typesession.present) {
      map['typesession'] = Variable<String>(typesession.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionsCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('baseWord: $baseWord, ')
          ..write('typesession: $typesession')
          ..write(')'))
        .toString();
  }
}

class $ExamplesTable extends Examples with TableInfo<$ExamplesTable, Example> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExamplesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _goaltextMeta =
      const VerificationMeta('goaltext');
  @override
  late final GeneratedColumn<String> goaltext = GeneratedColumn<String>(
      'goaltext', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => " ");
  static const VerificationMeta _exampleOrderMeta =
      const VerificationMeta('exampleOrder');
  @override
  late final GeneratedColumn<int> exampleOrder = GeneratedColumn<int>(
      'example_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      clientDefault: () => 100);
  @override
  List<GeneratedColumn> get $columns =>
      [id, uuid, baseWord, name, goaltext, exampleOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'examples';
  @override
  VerificationContext validateIntegrity(Insertable<Example> instance,
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
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('goaltext')) {
      context.handle(_goaltextMeta,
          goaltext.isAcceptableOrUnknown(data['goaltext']!, _goaltextMeta));
    }
    if (data.containsKey('example_order')) {
      context.handle(
          _exampleOrderMeta,
          exampleOrder.isAcceptableOrUnknown(
              data['example_order']!, _exampleOrderMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Example map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Example(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      uuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uuid'])!,
      baseWord: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}base_word'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      goaltext: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}goaltext'])!,
      exampleOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}example_order'])!,
    );
  }

  @override
  $ExamplesTable createAlias(String alias) {
    return $ExamplesTable(attachedDatabase, alias);
  }
}

class Example extends DataClass implements Insertable<Example> {
  final int id;
  final String uuid;
  final int baseWord;
  final String name;
  final String goaltext;
  final int exampleOrder;
  const Example(
      {required this.id,
      required this.uuid,
      required this.baseWord,
      required this.name,
      required this.goaltext,
      required this.exampleOrder});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    map['base_word'] = Variable<int>(baseWord);
    map['name'] = Variable<String>(name);
    map['goaltext'] = Variable<String>(goaltext);
    map['example_order'] = Variable<int>(exampleOrder);
    return map;
  }

  ExamplesCompanion toCompanion(bool nullToAbsent) {
    return ExamplesCompanion(
      id: Value(id),
      uuid: Value(uuid),
      baseWord: Value(baseWord),
      name: Value(name),
      goaltext: Value(goaltext),
      exampleOrder: Value(exampleOrder),
    );
  }

  factory Example.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Example(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      baseWord: serializer.fromJson<int>(json['baseWord']),
      name: serializer.fromJson<String>(json['name']),
      goaltext: serializer.fromJson<String>(json['goaltext']),
      exampleOrder: serializer.fromJson<int>(json['exampleOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'baseWord': serializer.toJson<int>(baseWord),
      'name': serializer.toJson<String>(name),
      'goaltext': serializer.toJson<String>(goaltext),
      'exampleOrder': serializer.toJson<int>(exampleOrder),
    };
  }

  Example copyWith(
          {int? id,
          String? uuid,
          int? baseWord,
          String? name,
          String? goaltext,
          int? exampleOrder}) =>
      Example(
        id: id ?? this.id,
        uuid: uuid ?? this.uuid,
        baseWord: baseWord ?? this.baseWord,
        name: name ?? this.name,
        goaltext: goaltext ?? this.goaltext,
        exampleOrder: exampleOrder ?? this.exampleOrder,
      );
  @override
  String toString() {
    return (StringBuffer('Example(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('baseWord: $baseWord, ')
          ..write('name: $name, ')
          ..write('goaltext: $goaltext, ')
          ..write('exampleOrder: $exampleOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, uuid, baseWord, name, goaltext, exampleOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Example &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.baseWord == this.baseWord &&
          other.name == this.name &&
          other.goaltext == this.goaltext &&
          other.exampleOrder == this.exampleOrder);
}

class ExamplesCompanion extends UpdateCompanion<Example> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<int> baseWord;
  final Value<String> name;
  final Value<String> goaltext;
  final Value<int> exampleOrder;
  const ExamplesCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.baseWord = const Value.absent(),
    this.name = const Value.absent(),
    this.goaltext = const Value.absent(),
    this.exampleOrder = const Value.absent(),
  });
  ExamplesCompanion.insert({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    required int baseWord,
    required String name,
    this.goaltext = const Value.absent(),
    this.exampleOrder = const Value.absent(),
  })  : baseWord = Value(baseWord),
        name = Value(name);
  static Insertable<Example> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<int>? baseWord,
    Expression<String>? name,
    Expression<String>? goaltext,
    Expression<int>? exampleOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (baseWord != null) 'base_word': baseWord,
      if (name != null) 'name': name,
      if (goaltext != null) 'goaltext': goaltext,
      if (exampleOrder != null) 'example_order': exampleOrder,
    });
  }

  ExamplesCompanion copyWith(
      {Value<int>? id,
      Value<String>? uuid,
      Value<int>? baseWord,
      Value<String>? name,
      Value<String>? goaltext,
      Value<int>? exampleOrder}) {
    return ExamplesCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      baseWord: baseWord ?? this.baseWord,
      name: name ?? this.name,
      goaltext: goaltext ?? this.goaltext,
      exampleOrder: exampleOrder ?? this.exampleOrder,
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
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (goaltext.present) {
      map['goaltext'] = Variable<String>(goaltext.value);
    }
    if (exampleOrder.present) {
      map['example_order'] = Variable<int>(exampleOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExamplesCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('baseWord: $baseWord, ')
          ..write('name: $name, ')
          ..write('goaltext: $goaltext, ')
          ..write('exampleOrder: $exampleOrder')
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
  late final $LeipzigDataFromIntranetTable leipzigDataFromIntranet =
      $LeipzigDataFromIntranetTable(this);
  late final $MeansTable means = $MeansTable(this);
  late final $SessionsTable sessions = $SessionsTable(this);
  late final $ExamplesTable examples = $ExamplesTable(this);
  late final Index typeSession = Index(
      'type_session', 'CREATE INDEX type_session ON sessions (typesession)');
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        languages,
        words,
        synonyms,
        translatedWords,
        leipzigDataFromIntranet,
        means,
        sessions,
        examples,
        typeSession
      ];
}
