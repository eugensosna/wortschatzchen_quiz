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
  Language copyWithCompanion(LanguagesCompanion data) {
    return Language(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      shortName: data.shortName.present ? data.shortName.value : this.shortName,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
    );
  }

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

class $KindsOfWordsTable extends KindsOfWords
    with TableInfo<$KindsOfWordsTable, KindsOfWord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KindsOfWordsTable(this.attachedDatabase, [this._alias]);
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
  @override
  List<GeneratedColumn> get $columns => [id, uuid, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'kinds_of_words';
  @override
  VerificationContext validateIntegrity(Insertable<KindsOfWord> instance,
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  KindsOfWord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KindsOfWord(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      uuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uuid'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
    );
  }

  @override
  $KindsOfWordsTable createAlias(String alias) {
    return $KindsOfWordsTable(attachedDatabase, alias);
  }
}

class KindsOfWord extends DataClass implements Insertable<KindsOfWord> {
  final int id;
  final String uuid;
  final String name;
  const KindsOfWord({required this.id, required this.uuid, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    map['name'] = Variable<String>(name);
    return map;
  }

  KindsOfWordsCompanion toCompanion(bool nullToAbsent) {
    return KindsOfWordsCompanion(
      id: Value(id),
      uuid: Value(uuid),
      name: Value(name),
    );
  }

  factory KindsOfWord.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KindsOfWord(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'name': serializer.toJson<String>(name),
    };
  }

  KindsOfWord copyWith({int? id, String? uuid, String? name}) => KindsOfWord(
        id: id ?? this.id,
        uuid: uuid ?? this.uuid,
        name: name ?? this.name,
      );
  KindsOfWord copyWithCompanion(KindsOfWordsCompanion data) {
    return KindsOfWord(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KindsOfWord(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, uuid, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KindsOfWord &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.name == this.name);
}

class KindsOfWordsCompanion extends UpdateCompanion<KindsOfWord> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<String> name;
  const KindsOfWordsCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.name = const Value.absent(),
  });
  KindsOfWordsCompanion.insert({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    required String name,
  }) : name = Value(name);
  static Insertable<KindsOfWord> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (name != null) 'name': name,
    });
  }

  KindsOfWordsCompanion copyWith(
      {Value<int>? id, Value<String>? uuid, Value<String>? name}) {
    return KindsOfWordsCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
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
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KindsOfWordsCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('name: $name')
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
  static const VerificationMeta _importantMeta =
      const VerificationMeta('important');
  @override
  late final GeneratedColumn<String> important = GeneratedColumn<String>(
      'important', aliasedName, false,
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
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
      'version', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      clientDefault: () => 0);
  static const VerificationMeta _kindOfWordMeta =
      const VerificationMeta('kindOfWord');
  @override
  late final GeneratedColumn<String> kindOfWord = GeneratedColumn<String>(
      'kind_of_word', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _kindOfWordRefMeta =
      const VerificationMeta('kindOfWordRef');
  @override
  late final GeneratedColumn<int> kindOfWordRef = GeneratedColumn<int>(
      'kind_of_word_ref', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES kinds_of_words (id)'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        uuid,
        name,
        important,
        description,
        mean,
        baseForm,
        baseLang,
        rootWordID,
        version,
        kindOfWord,
        kindOfWordRef
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
    if (data.containsKey('important')) {
      context.handle(_importantMeta,
          important.isAcceptableOrUnknown(data['important']!, _importantMeta));
    } else if (isInserting) {
      context.missing(_importantMeta);
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
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    }
    if (data.containsKey('kind_of_word')) {
      context.handle(
          _kindOfWordMeta,
          kindOfWord.isAcceptableOrUnknown(
              data['kind_of_word']!, _kindOfWordMeta));
    }
    if (data.containsKey('kind_of_word_ref')) {
      context.handle(
          _kindOfWordRefMeta,
          kindOfWordRef.isAcceptableOrUnknown(
              data['kind_of_word_ref']!, _kindOfWordRefMeta));
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
      important: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}important'])!,
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
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}version']),
      kindOfWord: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}kind_of_word']),
      kindOfWordRef: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}kind_of_word_ref']),
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
  final String important;
  final String description;
  final String mean;
  final String baseForm;
  final int baseLang;
  final int rootWordID;
  final int? version;
  final String? kindOfWord;
  final int? kindOfWordRef;
  const Word(
      {required this.id,
      required this.uuid,
      required this.name,
      required this.important,
      required this.description,
      required this.mean,
      required this.baseForm,
      required this.baseLang,
      required this.rootWordID,
      this.version,
      this.kindOfWord,
      this.kindOfWordRef});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    map['name'] = Variable<String>(name);
    map['important'] = Variable<String>(important);
    map['description'] = Variable<String>(description);
    map['mean'] = Variable<String>(mean);
    map['base_form'] = Variable<String>(baseForm);
    map['base_lang'] = Variable<int>(baseLang);
    map['root_word_i_d'] = Variable<int>(rootWordID);
    if (!nullToAbsent || version != null) {
      map['version'] = Variable<int>(version);
    }
    if (!nullToAbsent || kindOfWord != null) {
      map['kind_of_word'] = Variable<String>(kindOfWord);
    }
    if (!nullToAbsent || kindOfWordRef != null) {
      map['kind_of_word_ref'] = Variable<int>(kindOfWordRef);
    }
    return map;
  }

  WordsCompanion toCompanion(bool nullToAbsent) {
    return WordsCompanion(
      id: Value(id),
      uuid: Value(uuid),
      name: Value(name),
      important: Value(important),
      description: Value(description),
      mean: Value(mean),
      baseForm: Value(baseForm),
      baseLang: Value(baseLang),
      rootWordID: Value(rootWordID),
      version: version == null && nullToAbsent
          ? const Value.absent()
          : Value(version),
      kindOfWord: kindOfWord == null && nullToAbsent
          ? const Value.absent()
          : Value(kindOfWord),
      kindOfWordRef: kindOfWordRef == null && nullToAbsent
          ? const Value.absent()
          : Value(kindOfWordRef),
    );
  }

  factory Word.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Word(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      name: serializer.fromJson<String>(json['name']),
      important: serializer.fromJson<String>(json['important']),
      description: serializer.fromJson<String>(json['description']),
      mean: serializer.fromJson<String>(json['mean']),
      baseForm: serializer.fromJson<String>(json['baseForm']),
      baseLang: serializer.fromJson<int>(json['baseLang']),
      rootWordID: serializer.fromJson<int>(json['rootWordID']),
      version: serializer.fromJson<int?>(json['version']),
      kindOfWord: serializer.fromJson<String?>(json['kindOfWord']),
      kindOfWordRef: serializer.fromJson<int?>(json['kindOfWordRef']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'name': serializer.toJson<String>(name),
      'important': serializer.toJson<String>(important),
      'description': serializer.toJson<String>(description),
      'mean': serializer.toJson<String>(mean),
      'baseForm': serializer.toJson<String>(baseForm),
      'baseLang': serializer.toJson<int>(baseLang),
      'rootWordID': serializer.toJson<int>(rootWordID),
      'version': serializer.toJson<int?>(version),
      'kindOfWord': serializer.toJson<String?>(kindOfWord),
      'kindOfWordRef': serializer.toJson<int?>(kindOfWordRef),
    };
  }

  Word copyWith(
          {int? id,
          String? uuid,
          String? name,
          String? important,
          String? description,
          String? mean,
          String? baseForm,
          int? baseLang,
          int? rootWordID,
          Value<int?> version = const Value.absent(),
          Value<String?> kindOfWord = const Value.absent(),
          Value<int?> kindOfWordRef = const Value.absent()}) =>
      Word(
        id: id ?? this.id,
        uuid: uuid ?? this.uuid,
        name: name ?? this.name,
        important: important ?? this.important,
        description: description ?? this.description,
        mean: mean ?? this.mean,
        baseForm: baseForm ?? this.baseForm,
        baseLang: baseLang ?? this.baseLang,
        rootWordID: rootWordID ?? this.rootWordID,
        version: version.present ? version.value : this.version,
        kindOfWord: kindOfWord.present ? kindOfWord.value : this.kindOfWord,
        kindOfWordRef:
            kindOfWordRef.present ? kindOfWordRef.value : this.kindOfWordRef,
      );
  Word copyWithCompanion(WordsCompanion data) {
    return Word(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      name: data.name.present ? data.name.value : this.name,
      important: data.important.present ? data.important.value : this.important,
      description:
          data.description.present ? data.description.value : this.description,
      mean: data.mean.present ? data.mean.value : this.mean,
      baseForm: data.baseForm.present ? data.baseForm.value : this.baseForm,
      baseLang: data.baseLang.present ? data.baseLang.value : this.baseLang,
      rootWordID:
          data.rootWordID.present ? data.rootWordID.value : this.rootWordID,
      version: data.version.present ? data.version.value : this.version,
      kindOfWord:
          data.kindOfWord.present ? data.kindOfWord.value : this.kindOfWord,
      kindOfWordRef: data.kindOfWordRef.present
          ? data.kindOfWordRef.value
          : this.kindOfWordRef,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Word(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('name: $name, ')
          ..write('important: $important, ')
          ..write('description: $description, ')
          ..write('mean: $mean, ')
          ..write('baseForm: $baseForm, ')
          ..write('baseLang: $baseLang, ')
          ..write('rootWordID: $rootWordID, ')
          ..write('version: $version, ')
          ..write('kindOfWord: $kindOfWord, ')
          ..write('kindOfWordRef: $kindOfWordRef')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, uuid, name, important, description, mean,
      baseForm, baseLang, rootWordID, version, kindOfWord, kindOfWordRef);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Word &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.name == this.name &&
          other.important == this.important &&
          other.description == this.description &&
          other.mean == this.mean &&
          other.baseForm == this.baseForm &&
          other.baseLang == this.baseLang &&
          other.rootWordID == this.rootWordID &&
          other.version == this.version &&
          other.kindOfWord == this.kindOfWord &&
          other.kindOfWordRef == this.kindOfWordRef);
}

class WordsCompanion extends UpdateCompanion<Word> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<String> name;
  final Value<String> important;
  final Value<String> description;
  final Value<String> mean;
  final Value<String> baseForm;
  final Value<int> baseLang;
  final Value<int> rootWordID;
  final Value<int?> version;
  final Value<String?> kindOfWord;
  final Value<int?> kindOfWordRef;
  const WordsCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.name = const Value.absent(),
    this.important = const Value.absent(),
    this.description = const Value.absent(),
    this.mean = const Value.absent(),
    this.baseForm = const Value.absent(),
    this.baseLang = const Value.absent(),
    this.rootWordID = const Value.absent(),
    this.version = const Value.absent(),
    this.kindOfWord = const Value.absent(),
    this.kindOfWordRef = const Value.absent(),
  });
  WordsCompanion.insert({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    required String name,
    required String important,
    required String description,
    required String mean,
    required String baseForm,
    required int baseLang,
    required int rootWordID,
    this.version = const Value.absent(),
    this.kindOfWord = const Value.absent(),
    this.kindOfWordRef = const Value.absent(),
  })  : name = Value(name),
        important = Value(important),
        description = Value(description),
        mean = Value(mean),
        baseForm = Value(baseForm),
        baseLang = Value(baseLang),
        rootWordID = Value(rootWordID);
  static Insertable<Word> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<String>? name,
    Expression<String>? important,
    Expression<String>? description,
    Expression<String>? mean,
    Expression<String>? baseForm,
    Expression<int>? baseLang,
    Expression<int>? rootWordID,
    Expression<int>? version,
    Expression<String>? kindOfWord,
    Expression<int>? kindOfWordRef,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (name != null) 'name': name,
      if (important != null) 'important': important,
      if (description != null) 'description': description,
      if (mean != null) 'mean': mean,
      if (baseForm != null) 'base_form': baseForm,
      if (baseLang != null) 'base_lang': baseLang,
      if (rootWordID != null) 'root_word_i_d': rootWordID,
      if (version != null) 'version': version,
      if (kindOfWord != null) 'kind_of_word': kindOfWord,
      if (kindOfWordRef != null) 'kind_of_word_ref': kindOfWordRef,
    });
  }

  WordsCompanion copyWith(
      {Value<int>? id,
      Value<String>? uuid,
      Value<String>? name,
      Value<String>? important,
      Value<String>? description,
      Value<String>? mean,
      Value<String>? baseForm,
      Value<int>? baseLang,
      Value<int>? rootWordID,
      Value<int?>? version,
      Value<String?>? kindOfWord,
      Value<int?>? kindOfWordRef}) {
    return WordsCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      important: important ?? this.important,
      description: description ?? this.description,
      mean: mean ?? this.mean,
      baseForm: baseForm ?? this.baseForm,
      baseLang: baseLang ?? this.baseLang,
      rootWordID: rootWordID ?? this.rootWordID,
      version: version ?? this.version,
      kindOfWord: kindOfWord ?? this.kindOfWord,
      kindOfWordRef: kindOfWordRef ?? this.kindOfWordRef,
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
    if (important.present) {
      map['important'] = Variable<String>(important.value);
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
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (kindOfWord.present) {
      map['kind_of_word'] = Variable<String>(kindOfWord.value);
    }
    if (kindOfWordRef.present) {
      map['kind_of_word_ref'] = Variable<int>(kindOfWordRef.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WordsCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('name: $name, ')
          ..write('important: $important, ')
          ..write('description: $description, ')
          ..write('mean: $mean, ')
          ..write('baseForm: $baseForm, ')
          ..write('baseLang: $baseLang, ')
          ..write('rootWordID: $rootWordID, ')
          ..write('version: $version, ')
          ..write('kindOfWord: $kindOfWord, ')
          ..write('kindOfWordRef: $kindOfWordRef')
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
  Synonym copyWithCompanion(SynonymsCompanion data) {
    return Synonym(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      baseWord: data.baseWord.present ? data.baseWord.value : this.baseWord,
      synonymWord:
          data.synonymWord.present ? data.synonymWord.value : this.synonymWord,
      name: data.name.present ? data.name.value : this.name,
      baseLang: data.baseLang.present ? data.baseLang.value : this.baseLang,
      translatedName: data.translatedName.present
          ? data.translatedName.value
          : this.translatedName,
    );
  }

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
  translatedwords copyWithCompanion(TranslatedWordsCompanion data) {
    return translatedwords(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      baseLang: data.baseLang.present ? data.baseLang.value : this.baseLang,
      targetLang:
          data.targetLang.present ? data.targetLang.value : this.targetLang,
      name: data.name.present ? data.name.value : this.name,
      translatedName: data.translatedName.present
          ? data.translatedName.value
          : this.translatedName,
    );
  }

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
  static const VerificationMeta _htmlOpenMeta =
      const VerificationMeta('htmlOpen');
  @override
  late final GeneratedColumn<String> htmlOpen = GeneratedColumn<String>(
      'html_open', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _htmlExamplesMeta =
      const VerificationMeta('htmlExamples');
  @override
  late final GeneratedColumn<String> htmlExamples = GeneratedColumn<String>(
      'html_examples', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
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
  List<GeneratedColumn> get $columns => [
        id,
        uuid,
        baseWord,
        url,
        html,
        htmlOpen,
        htmlExamples,
        article,
        KindOfWort,
        wordOfBase
      ];
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
    if (data.containsKey('html_open')) {
      context.handle(_htmlOpenMeta,
          htmlOpen.isAcceptableOrUnknown(data['html_open']!, _htmlOpenMeta));
    }
    if (data.containsKey('html_examples')) {
      context.handle(
          _htmlExamplesMeta,
          htmlExamples.isAcceptableOrUnknown(
              data['html_examples']!, _htmlExamplesMeta));
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
      htmlOpen: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}html_open']),
      htmlExamples: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}html_examples']),
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
  final String? htmlOpen;
  final String? htmlExamples;
  final String article;
  final String KindOfWort;
  final String wordOfBase;
  const LeipzigDataFromIntranetData(
      {required this.id,
      required this.uuid,
      required this.baseWord,
      required this.url,
      required this.html,
      this.htmlOpen,
      this.htmlExamples,
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
    if (!nullToAbsent || htmlOpen != null) {
      map['html_open'] = Variable<String>(htmlOpen);
    }
    if (!nullToAbsent || htmlExamples != null) {
      map['html_examples'] = Variable<String>(htmlExamples);
    }
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
      htmlOpen: htmlOpen == null && nullToAbsent
          ? const Value.absent()
          : Value(htmlOpen),
      htmlExamples: htmlExamples == null && nullToAbsent
          ? const Value.absent()
          : Value(htmlExamples),
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
      htmlOpen: serializer.fromJson<String?>(json['htmlOpen']),
      htmlExamples: serializer.fromJson<String?>(json['htmlExamples']),
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
      'htmlOpen': serializer.toJson<String?>(htmlOpen),
      'htmlExamples': serializer.toJson<String?>(htmlExamples),
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
          Value<String?> htmlOpen = const Value.absent(),
          Value<String?> htmlExamples = const Value.absent(),
          String? article,
          String? KindOfWort,
          String? wordOfBase}) =>
      LeipzigDataFromIntranetData(
        id: id ?? this.id,
        uuid: uuid ?? this.uuid,
        baseWord: baseWord ?? this.baseWord,
        url: url ?? this.url,
        html: html ?? this.html,
        htmlOpen: htmlOpen.present ? htmlOpen.value : this.htmlOpen,
        htmlExamples:
            htmlExamples.present ? htmlExamples.value : this.htmlExamples,
        article: article ?? this.article,
        KindOfWort: KindOfWort ?? this.KindOfWort,
        wordOfBase: wordOfBase ?? this.wordOfBase,
      );
  LeipzigDataFromIntranetData copyWithCompanion(
      LeipzigDataFromIntranetCompanion data) {
    return LeipzigDataFromIntranetData(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      baseWord: data.baseWord.present ? data.baseWord.value : this.baseWord,
      url: data.url.present ? data.url.value : this.url,
      html: data.html.present ? data.html.value : this.html,
      htmlOpen: data.htmlOpen.present ? data.htmlOpen.value : this.htmlOpen,
      htmlExamples: data.htmlExamples.present
          ? data.htmlExamples.value
          : this.htmlExamples,
      article: data.article.present ? data.article.value : this.article,
      KindOfWort:
          data.KindOfWort.present ? data.KindOfWort.value : this.KindOfWort,
      wordOfBase:
          data.wordOfBase.present ? data.wordOfBase.value : this.wordOfBase,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LeipzigDataFromIntranetData(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('baseWord: $baseWord, ')
          ..write('url: $url, ')
          ..write('html: $html, ')
          ..write('htmlOpen: $htmlOpen, ')
          ..write('htmlExamples: $htmlExamples, ')
          ..write('article: $article, ')
          ..write('KindOfWort: $KindOfWort, ')
          ..write('wordOfBase: $wordOfBase')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, uuid, baseWord, url, html, htmlOpen,
      htmlExamples, article, KindOfWort, wordOfBase);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LeipzigDataFromIntranetData &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.baseWord == this.baseWord &&
          other.url == this.url &&
          other.html == this.html &&
          other.htmlOpen == this.htmlOpen &&
          other.htmlExamples == this.htmlExamples &&
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
  final Value<String?> htmlOpen;
  final Value<String?> htmlExamples;
  final Value<String> article;
  final Value<String> KindOfWort;
  final Value<String> wordOfBase;
  const LeipzigDataFromIntranetCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.baseWord = const Value.absent(),
    this.url = const Value.absent(),
    this.html = const Value.absent(),
    this.htmlOpen = const Value.absent(),
    this.htmlExamples = const Value.absent(),
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
    this.htmlOpen = const Value.absent(),
    this.htmlExamples = const Value.absent(),
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
    Expression<String>? htmlOpen,
    Expression<String>? htmlExamples,
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
      if (htmlOpen != null) 'html_open': htmlOpen,
      if (htmlExamples != null) 'html_examples': htmlExamples,
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
      Value<String?>? htmlOpen,
      Value<String?>? htmlExamples,
      Value<String>? article,
      Value<String>? KindOfWort,
      Value<String>? wordOfBase}) {
    return LeipzigDataFromIntranetCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      baseWord: baseWord ?? this.baseWord,
      url: url ?? this.url,
      html: html ?? this.html,
      htmlOpen: htmlOpen ?? this.htmlOpen,
      htmlExamples: htmlExamples ?? this.htmlExamples,
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
    if (htmlOpen.present) {
      map['html_open'] = Variable<String>(htmlOpen.value);
    }
    if (htmlExamples.present) {
      map['html_examples'] = Variable<String>(htmlExamples.value);
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
          ..write('htmlOpen: $htmlOpen, ')
          ..write('htmlExamples: $htmlExamples, ')
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
  Mean copyWithCompanion(MeansCompanion data) {
    return Mean(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      baseWord: data.baseWord.present ? data.baseWord.value : this.baseWord,
      name: data.name.present ? data.name.value : this.name,
      meansOrder:
          data.meansOrder.present ? data.meansOrder.value : this.meansOrder,
    );
  }

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
  Session copyWithCompanion(SessionsCompanion data) {
    return Session(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      baseWord: data.baseWord.present ? data.baseWord.value : this.baseWord,
      typesession:
          data.typesession.present ? data.typesession.value : this.typesession,
    );
  }

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
  Example copyWithCompanion(ExamplesCompanion data) {
    return Example(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      baseWord: data.baseWord.present ? data.baseWord.value : this.baseWord,
      name: data.name.present ? data.name.value : this.name,
      goaltext: data.goaltext.present ? data.goaltext.value : this.goaltext,
      exampleOrder: data.exampleOrder.present
          ? data.exampleOrder.value
          : this.exampleOrder,
    );
  }

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

class $QuizGroupTable extends QuizGroup
    with TableInfo<$QuizGroupTable, QuizGroupData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuizGroupTable(this.attachedDatabase, [this._alias]);
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
  @override
  List<GeneratedColumn> get $columns => [id, uuid, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quiz_group';
  @override
  VerificationContext validateIntegrity(Insertable<QuizGroupData> instance,
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QuizGroupData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuizGroupData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      uuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uuid'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
    );
  }

  @override
  $QuizGroupTable createAlias(String alias) {
    return $QuizGroupTable(attachedDatabase, alias);
  }
}

class QuizGroupData extends DataClass implements Insertable<QuizGroupData> {
  final int id;
  final String uuid;
  final String name;
  const QuizGroupData(
      {required this.id, required this.uuid, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    map['name'] = Variable<String>(name);
    return map;
  }

  QuizGroupCompanion toCompanion(bool nullToAbsent) {
    return QuizGroupCompanion(
      id: Value(id),
      uuid: Value(uuid),
      name: Value(name),
    );
  }

  factory QuizGroupData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuizGroupData(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'name': serializer.toJson<String>(name),
    };
  }

  QuizGroupData copyWith({int? id, String? uuid, String? name}) =>
      QuizGroupData(
        id: id ?? this.id,
        uuid: uuid ?? this.uuid,
        name: name ?? this.name,
      );
  QuizGroupData copyWithCompanion(QuizGroupCompanion data) {
    return QuizGroupData(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuizGroupData(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, uuid, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuizGroupData &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.name == this.name);
}

class QuizGroupCompanion extends UpdateCompanion<QuizGroupData> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<String> name;
  const QuizGroupCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.name = const Value.absent(),
  });
  QuizGroupCompanion.insert({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    required String name,
  }) : name = Value(name);
  static Insertable<QuizGroupData> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (name != null) 'name': name,
    });
  }

  QuizGroupCompanion copyWith(
      {Value<int>? id, Value<String>? uuid, Value<String>? name}) {
    return QuizGroupCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
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
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuizGroupCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $QuestionTable extends Question
    with TableInfo<$QuestionTable, QuestionData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuestionTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _answerMeta = const VerificationMeta('answer');
  @override
  late final GeneratedColumn<String> answer = GeneratedColumn<String>(
      'answer', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _exampleMeta =
      const VerificationMeta('example');
  @override
  late final GeneratedColumn<String> example = GeneratedColumn<String>(
      'example', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _refWordMeta =
      const VerificationMeta('refWord');
  @override
  late final GeneratedColumn<int> refWord = GeneratedColumn<int>(
      'ref_word', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES words (id)'),
      clientDefault: () => 0);
  static const VerificationMeta _refQuizGroupMeta =
      const VerificationMeta('refQuizGroup');
  @override
  late final GeneratedColumn<int> refQuizGroup = GeneratedColumn<int>(
      'ref_quiz_group', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES quiz_group (id)'));
  static const VerificationMeta _archiveMeta =
      const VerificationMeta('archive');
  @override
  late final GeneratedColumn<bool> archive = GeneratedColumn<bool>(
      'archive', aliasedName, true,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("archive" IN (0, 1))'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, uuid, name, answer, example, refWord, refQuizGroup, archive];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'question';
  @override
  VerificationContext validateIntegrity(Insertable<QuestionData> instance,
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
    if (data.containsKey('answer')) {
      context.handle(_answerMeta,
          answer.isAcceptableOrUnknown(data['answer']!, _answerMeta));
    } else if (isInserting) {
      context.missing(_answerMeta);
    }
    if (data.containsKey('example')) {
      context.handle(_exampleMeta,
          example.isAcceptableOrUnknown(data['example']!, _exampleMeta));
    } else if (isInserting) {
      context.missing(_exampleMeta);
    }
    if (data.containsKey('ref_word')) {
      context.handle(_refWordMeta,
          refWord.isAcceptableOrUnknown(data['ref_word']!, _refWordMeta));
    }
    if (data.containsKey('ref_quiz_group')) {
      context.handle(
          _refQuizGroupMeta,
          refQuizGroup.isAcceptableOrUnknown(
              data['ref_quiz_group']!, _refQuizGroupMeta));
    } else if (isInserting) {
      context.missing(_refQuizGroupMeta);
    }
    if (data.containsKey('archive')) {
      context.handle(_archiveMeta,
          archive.isAcceptableOrUnknown(data['archive']!, _archiveMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QuestionData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuestionData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      uuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uuid'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      answer: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}answer'])!,
      example: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}example'])!,
      refWord: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ref_word'])!,
      refQuizGroup: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ref_quiz_group'])!,
      archive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}archive']),
    );
  }

  @override
  $QuestionTable createAlias(String alias) {
    return $QuestionTable(attachedDatabase, alias);
  }
}

class QuestionData extends DataClass implements Insertable<QuestionData> {
  final int id;
  final String uuid;
  final String name;
  final String answer;
  final String example;
  final int refWord;
  final int refQuizGroup;
  final bool? archive;
  const QuestionData(
      {required this.id,
      required this.uuid,
      required this.name,
      required this.answer,
      required this.example,
      required this.refWord,
      required this.refQuizGroup,
      this.archive});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    map['name'] = Variable<String>(name);
    map['answer'] = Variable<String>(answer);
    map['example'] = Variable<String>(example);
    map['ref_word'] = Variable<int>(refWord);
    map['ref_quiz_group'] = Variable<int>(refQuizGroup);
    if (!nullToAbsent || archive != null) {
      map['archive'] = Variable<bool>(archive);
    }
    return map;
  }

  QuestionCompanion toCompanion(bool nullToAbsent) {
    return QuestionCompanion(
      id: Value(id),
      uuid: Value(uuid),
      name: Value(name),
      answer: Value(answer),
      example: Value(example),
      refWord: Value(refWord),
      refQuizGroup: Value(refQuizGroup),
      archive: archive == null && nullToAbsent
          ? const Value.absent()
          : Value(archive),
    );
  }

  factory QuestionData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuestionData(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      name: serializer.fromJson<String>(json['name']),
      answer: serializer.fromJson<String>(json['answer']),
      example: serializer.fromJson<String>(json['example']),
      refWord: serializer.fromJson<int>(json['refWord']),
      refQuizGroup: serializer.fromJson<int>(json['refQuizGroup']),
      archive: serializer.fromJson<bool?>(json['archive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'name': serializer.toJson<String>(name),
      'answer': serializer.toJson<String>(answer),
      'example': serializer.toJson<String>(example),
      'refWord': serializer.toJson<int>(refWord),
      'refQuizGroup': serializer.toJson<int>(refQuizGroup),
      'archive': serializer.toJson<bool?>(archive),
    };
  }

  QuestionData copyWith(
          {int? id,
          String? uuid,
          String? name,
          String? answer,
          String? example,
          int? refWord,
          int? refQuizGroup,
          Value<bool?> archive = const Value.absent()}) =>
      QuestionData(
        id: id ?? this.id,
        uuid: uuid ?? this.uuid,
        name: name ?? this.name,
        answer: answer ?? this.answer,
        example: example ?? this.example,
        refWord: refWord ?? this.refWord,
        refQuizGroup: refQuizGroup ?? this.refQuizGroup,
        archive: archive.present ? archive.value : this.archive,
      );
  QuestionData copyWithCompanion(QuestionCompanion data) {
    return QuestionData(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      name: data.name.present ? data.name.value : this.name,
      answer: data.answer.present ? data.answer.value : this.answer,
      example: data.example.present ? data.example.value : this.example,
      refWord: data.refWord.present ? data.refWord.value : this.refWord,
      refQuizGroup: data.refQuizGroup.present
          ? data.refQuizGroup.value
          : this.refQuizGroup,
      archive: data.archive.present ? data.archive.value : this.archive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuestionData(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('name: $name, ')
          ..write('answer: $answer, ')
          ..write('example: $example, ')
          ..write('refWord: $refWord, ')
          ..write('refQuizGroup: $refQuizGroup, ')
          ..write('archive: $archive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, uuid, name, answer, example, refWord, refQuizGroup, archive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuestionData &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.name == this.name &&
          other.answer == this.answer &&
          other.example == this.example &&
          other.refWord == this.refWord &&
          other.refQuizGroup == this.refQuizGroup &&
          other.archive == this.archive);
}

class QuestionCompanion extends UpdateCompanion<QuestionData> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<String> name;
  final Value<String> answer;
  final Value<String> example;
  final Value<int> refWord;
  final Value<int> refQuizGroup;
  final Value<bool?> archive;
  const QuestionCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.name = const Value.absent(),
    this.answer = const Value.absent(),
    this.example = const Value.absent(),
    this.refWord = const Value.absent(),
    this.refQuizGroup = const Value.absent(),
    this.archive = const Value.absent(),
  });
  QuestionCompanion.insert({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    required String name,
    required String answer,
    required String example,
    this.refWord = const Value.absent(),
    required int refQuizGroup,
    this.archive = const Value.absent(),
  })  : name = Value(name),
        answer = Value(answer),
        example = Value(example),
        refQuizGroup = Value(refQuizGroup);
  static Insertable<QuestionData> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<String>? name,
    Expression<String>? answer,
    Expression<String>? example,
    Expression<int>? refWord,
    Expression<int>? refQuizGroup,
    Expression<bool>? archive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (name != null) 'name': name,
      if (answer != null) 'answer': answer,
      if (example != null) 'example': example,
      if (refWord != null) 'ref_word': refWord,
      if (refQuizGroup != null) 'ref_quiz_group': refQuizGroup,
      if (archive != null) 'archive': archive,
    });
  }

  QuestionCompanion copyWith(
      {Value<int>? id,
      Value<String>? uuid,
      Value<String>? name,
      Value<String>? answer,
      Value<String>? example,
      Value<int>? refWord,
      Value<int>? refQuizGroup,
      Value<bool?>? archive}) {
    return QuestionCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      answer: answer ?? this.answer,
      example: example ?? this.example,
      refWord: refWord ?? this.refWord,
      refQuizGroup: refQuizGroup ?? this.refQuizGroup,
      archive: archive ?? this.archive,
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
    if (answer.present) {
      map['answer'] = Variable<String>(answer.value);
    }
    if (example.present) {
      map['example'] = Variable<String>(example.value);
    }
    if (refWord.present) {
      map['ref_word'] = Variable<int>(refWord.value);
    }
    if (refQuizGroup.present) {
      map['ref_quiz_group'] = Variable<int>(refQuizGroup.value);
    }
    if (archive.present) {
      map['archive'] = Variable<bool>(archive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuestionCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('name: $name, ')
          ..write('answer: $answer, ')
          ..write('example: $example, ')
          ..write('refWord: $refWord, ')
          ..write('refQuizGroup: $refQuizGroup, ')
          ..write('archive: $archive')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $LanguagesTable languages = $LanguagesTable(this);
  late final $KindsOfWordsTable kindsOfWords = $KindsOfWordsTable(this);
  late final $WordsTable words = $WordsTable(this);
  late final $SynonymsTable synonyms = $SynonymsTable(this);
  late final $TranslatedWordsTable translatedWords =
      $TranslatedWordsTable(this);
  late final $LeipzigDataFromIntranetTable leipzigDataFromIntranet =
      $LeipzigDataFromIntranetTable(this);
  late final $MeansTable means = $MeansTable(this);
  late final $SessionsTable sessions = $SessionsTable(this);
  late final $ExamplesTable examples = $ExamplesTable(this);
  late final $QuizGroupTable quizGroup = $QuizGroupTable(this);
  late final $QuestionTable question = $QuestionTable(this);
  late final Index typeSession = Index(
      'type_session', 'CREATE INDEX type_session ON sessions (typesession)');
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        languages,
        kindsOfWords,
        words,
        synonyms,
        translatedWords,
        leipzigDataFromIntranet,
        means,
        sessions,
        examples,
        quizGroup,
        question,
        typeSession
      ];
}

typedef $$LanguagesTableCreateCompanionBuilder = LanguagesCompanion Function({
  Value<int> id,
  required String name,
  required String shortName,
  Value<String> uuid,
});
typedef $$LanguagesTableUpdateCompanionBuilder = LanguagesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> shortName,
  Value<String> uuid,
});

final class $$LanguagesTableReferences
    extends BaseReferences<_$AppDatabase, $LanguagesTable, Language> {
  $$LanguagesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$WordsTable, List<Word>> _wordsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.words,
          aliasName: $_aliasNameGenerator(db.languages.id, db.words.baseLang));

  $$WordsTableProcessedTableManager get wordsRefs {
    final manager = $$WordsTableTableManager($_db, $_db.words)
        .filter((f) => f.baseLang.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_wordsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$SynonymsTable, List<Synonym>> _synonymsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.synonyms,
          aliasName:
              $_aliasNameGenerator(db.languages.id, db.synonyms.baseLang));

  $$SynonymsTableProcessedTableManager get synonymsRefs {
    final manager = $$SynonymsTableTableManager($_db, $_db.synonyms)
        .filter((f) => f.baseLang.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_synonymsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$TranslatedWordsTable, List<translatedwords>>
      _baselangRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.translatedWords,
              aliasName: $_aliasNameGenerator(
                  db.languages.id, db.translatedWords.baseLang));

  $$TranslatedWordsTableProcessedTableManager get baselangRefs {
    final manager =
        $$TranslatedWordsTableTableManager($_db, $_db.translatedWords)
            .filter((f) => f.baseLang.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_baselangRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$TranslatedWordsTable, List<translatedwords>>
      _targetlangRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.translatedWords,
              aliasName: $_aliasNameGenerator(
                  db.languages.id, db.translatedWords.targetLang));

  $$TranslatedWordsTableProcessedTableManager get targetlangRefs {
    final manager =
        $$TranslatedWordsTableTableManager($_db, $_db.translatedWords)
            .filter((f) => f.targetLang.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_targetlangRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$LanguagesTableFilterComposer
    extends Composer<_$AppDatabase, $LanguagesTable> {
  $$LanguagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get shortName => $composableBuilder(
      column: $table.shortName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnFilters(column));

  Expression<bool> wordsRefs(
      Expression<bool> Function($$WordsTableFilterComposer f) f) {
    final $$WordsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.words,
        getReferencedColumn: (t) => t.baseLang,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WordsTableFilterComposer(
              $db: $db,
              $table: $db.words,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> synonymsRefs(
      Expression<bool> Function($$SynonymsTableFilterComposer f) f) {
    final $$SynonymsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.synonyms,
        getReferencedColumn: (t) => t.baseLang,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SynonymsTableFilterComposer(
              $db: $db,
              $table: $db.synonyms,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> baselangRefs(
      Expression<bool> Function($$TranslatedWordsTableFilterComposer f) f) {
    final $$TranslatedWordsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.translatedWords,
        getReferencedColumn: (t) => t.baseLang,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TranslatedWordsTableFilterComposer(
              $db: $db,
              $table: $db.translatedWords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> targetlangRefs(
      Expression<bool> Function($$TranslatedWordsTableFilterComposer f) f) {
    final $$TranslatedWordsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.translatedWords,
        getReferencedColumn: (t) => t.targetLang,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TranslatedWordsTableFilterComposer(
              $db: $db,
              $table: $db.translatedWords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$LanguagesTableOrderingComposer
    extends Composer<_$AppDatabase, $LanguagesTable> {
  $$LanguagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get shortName => $composableBuilder(
      column: $table.shortName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnOrderings(column));
}

class $$LanguagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LanguagesTable> {
  $$LanguagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get shortName =>
      $composableBuilder(column: $table.shortName, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  Expression<T> wordsRefs<T extends Object>(
      Expression<T> Function($$WordsTableAnnotationComposer a) f) {
    final $$WordsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.words,
        getReferencedColumn: (t) => t.baseLang,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WordsTableAnnotationComposer(
              $db: $db,
              $table: $db.words,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> synonymsRefs<T extends Object>(
      Expression<T> Function($$SynonymsTableAnnotationComposer a) f) {
    final $$SynonymsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.synonyms,
        getReferencedColumn: (t) => t.baseLang,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SynonymsTableAnnotationComposer(
              $db: $db,
              $table: $db.synonyms,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> baselangRefs<T extends Object>(
      Expression<T> Function($$TranslatedWordsTableAnnotationComposer a) f) {
    final $$TranslatedWordsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.translatedWords,
        getReferencedColumn: (t) => t.baseLang,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TranslatedWordsTableAnnotationComposer(
              $db: $db,
              $table: $db.translatedWords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> targetlangRefs<T extends Object>(
      Expression<T> Function($$TranslatedWordsTableAnnotationComposer a) f) {
    final $$TranslatedWordsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.translatedWords,
        getReferencedColumn: (t) => t.targetLang,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TranslatedWordsTableAnnotationComposer(
              $db: $db,
              $table: $db.translatedWords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$LanguagesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LanguagesTable,
    Language,
    $$LanguagesTableFilterComposer,
    $$LanguagesTableOrderingComposer,
    $$LanguagesTableAnnotationComposer,
    $$LanguagesTableCreateCompanionBuilder,
    $$LanguagesTableUpdateCompanionBuilder,
    (Language, $$LanguagesTableReferences),
    Language,
    PrefetchHooks Function(
        {bool wordsRefs,
        bool synonymsRefs,
        bool baselangRefs,
        bool targetlangRefs})> {
  $$LanguagesTableTableManager(_$AppDatabase db, $LanguagesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LanguagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LanguagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LanguagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> shortName = const Value.absent(),
            Value<String> uuid = const Value.absent(),
          }) =>
              LanguagesCompanion(
            id: id,
            name: name,
            shortName: shortName,
            uuid: uuid,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required String shortName,
            Value<String> uuid = const Value.absent(),
          }) =>
              LanguagesCompanion.insert(
            id: id,
            name: name,
            shortName: shortName,
            uuid: uuid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$LanguagesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {wordsRefs = false,
              synonymsRefs = false,
              baselangRefs = false,
              targetlangRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (wordsRefs) db.words,
                if (synonymsRefs) db.synonyms,
                if (baselangRefs) db.translatedWords,
                if (targetlangRefs) db.translatedWords
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (wordsRefs)
                    await $_getPrefetchedData<Language, $LanguagesTable, Word>(
                        currentTable: table,
                        referencedTable:
                            $$LanguagesTableReferences._wordsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$LanguagesTableReferences(db, table, p0).wordsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.baseLang == item.id),
                        typedResults: items),
                  if (synonymsRefs)
                    await $_getPrefetchedData<Language, $LanguagesTable,
                            Synonym>(
                        currentTable: table,
                        referencedTable:
                            $$LanguagesTableReferences._synonymsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$LanguagesTableReferences(db, table, p0)
                                .synonymsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.baseLang == item.id),
                        typedResults: items),
                  if (baselangRefs)
                    await $_getPrefetchedData<Language, $LanguagesTable,
                            translatedwords>(
                        currentTable: table,
                        referencedTable:
                            $$LanguagesTableReferences._baselangRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$LanguagesTableReferences(db, table, p0)
                                .baselangRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.baseLang == item.id),
                        typedResults: items),
                  if (targetlangRefs)
                    await $_getPrefetchedData<Language, $LanguagesTable,
                            translatedwords>(
                        currentTable: table,
                        referencedTable:
                            $$LanguagesTableReferences._targetlangRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$LanguagesTableReferences(db, table, p0)
                                .targetlangRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.targetLang == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$LanguagesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LanguagesTable,
    Language,
    $$LanguagesTableFilterComposer,
    $$LanguagesTableOrderingComposer,
    $$LanguagesTableAnnotationComposer,
    $$LanguagesTableCreateCompanionBuilder,
    $$LanguagesTableUpdateCompanionBuilder,
    (Language, $$LanguagesTableReferences),
    Language,
    PrefetchHooks Function(
        {bool wordsRefs,
        bool synonymsRefs,
        bool baselangRefs,
        bool targetlangRefs})>;
typedef $$KindsOfWordsTableCreateCompanionBuilder = KindsOfWordsCompanion
    Function({
  Value<int> id,
  Value<String> uuid,
  required String name,
});
typedef $$KindsOfWordsTableUpdateCompanionBuilder = KindsOfWordsCompanion
    Function({
  Value<int> id,
  Value<String> uuid,
  Value<String> name,
});

final class $$KindsOfWordsTableReferences
    extends BaseReferences<_$AppDatabase, $KindsOfWordsTable, KindsOfWord> {
  $$KindsOfWordsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$WordsTable, List<Word>> _wordsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.words,
          aliasName:
              $_aliasNameGenerator(db.kindsOfWords.id, db.words.kindOfWordRef));

  $$WordsTableProcessedTableManager get wordsRefs {
    final manager = $$WordsTableTableManager($_db, $_db.words)
        .filter((f) => f.kindOfWordRef.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_wordsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$KindsOfWordsTableFilterComposer
    extends Composer<_$AppDatabase, $KindsOfWordsTable> {
  $$KindsOfWordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  Expression<bool> wordsRefs(
      Expression<bool> Function($$WordsTableFilterComposer f) f) {
    final $$WordsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.words,
        getReferencedColumn: (t) => t.kindOfWordRef,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WordsTableFilterComposer(
              $db: $db,
              $table: $db.words,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$KindsOfWordsTableOrderingComposer
    extends Composer<_$AppDatabase, $KindsOfWordsTable> {
  $$KindsOfWordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));
}

class $$KindsOfWordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $KindsOfWordsTable> {
  $$KindsOfWordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  Expression<T> wordsRefs<T extends Object>(
      Expression<T> Function($$WordsTableAnnotationComposer a) f) {
    final $$WordsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.words,
        getReferencedColumn: (t) => t.kindOfWordRef,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WordsTableAnnotationComposer(
              $db: $db,
              $table: $db.words,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$KindsOfWordsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $KindsOfWordsTable,
    KindsOfWord,
    $$KindsOfWordsTableFilterComposer,
    $$KindsOfWordsTableOrderingComposer,
    $$KindsOfWordsTableAnnotationComposer,
    $$KindsOfWordsTableCreateCompanionBuilder,
    $$KindsOfWordsTableUpdateCompanionBuilder,
    (KindsOfWord, $$KindsOfWordsTableReferences),
    KindsOfWord,
    PrefetchHooks Function({bool wordsRefs})> {
  $$KindsOfWordsTableTableManager(_$AppDatabase db, $KindsOfWordsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KindsOfWordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KindsOfWordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KindsOfWordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> uuid = const Value.absent(),
            Value<String> name = const Value.absent(),
          }) =>
              KindsOfWordsCompanion(
            id: id,
            uuid: uuid,
            name: name,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> uuid = const Value.absent(),
            required String name,
          }) =>
              KindsOfWordsCompanion.insert(
            id: id,
            uuid: uuid,
            name: name,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$KindsOfWordsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({wordsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (wordsRefs) db.words],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (wordsRefs)
                    await $_getPrefetchedData<KindsOfWord, $KindsOfWordsTable,
                            Word>(
                        currentTable: table,
                        referencedTable:
                            $$KindsOfWordsTableReferences._wordsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$KindsOfWordsTableReferences(db, table, p0)
                                .wordsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.kindOfWordRef == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$KindsOfWordsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $KindsOfWordsTable,
    KindsOfWord,
    $$KindsOfWordsTableFilterComposer,
    $$KindsOfWordsTableOrderingComposer,
    $$KindsOfWordsTableAnnotationComposer,
    $$KindsOfWordsTableCreateCompanionBuilder,
    $$KindsOfWordsTableUpdateCompanionBuilder,
    (KindsOfWord, $$KindsOfWordsTableReferences),
    KindsOfWord,
    PrefetchHooks Function({bool wordsRefs})>;
typedef $$WordsTableCreateCompanionBuilder = WordsCompanion Function({
  Value<int> id,
  Value<String> uuid,
  required String name,
  required String important,
  required String description,
  required String mean,
  required String baseForm,
  required int baseLang,
  required int rootWordID,
  Value<int?> version,
  Value<String?> kindOfWord,
  Value<int?> kindOfWordRef,
});
typedef $$WordsTableUpdateCompanionBuilder = WordsCompanion Function({
  Value<int> id,
  Value<String> uuid,
  Value<String> name,
  Value<String> important,
  Value<String> description,
  Value<String> mean,
  Value<String> baseForm,
  Value<int> baseLang,
  Value<int> rootWordID,
  Value<int?> version,
  Value<String?> kindOfWord,
  Value<int?> kindOfWordRef,
});

final class $$WordsTableReferences
    extends BaseReferences<_$AppDatabase, $WordsTable, Word> {
  $$WordsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $LanguagesTable _baseLangTable(_$AppDatabase db) => db.languages
      .createAlias($_aliasNameGenerator(db.words.baseLang, db.languages.id));

  $$LanguagesTableProcessedTableManager get baseLang {
    final $_column = $_itemColumn<int>('base_lang')!;

    final manager = $$LanguagesTableTableManager($_db, $_db.languages)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_baseLangTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $KindsOfWordsTable _kindOfWordRefTable(_$AppDatabase db) =>
      db.kindsOfWords.createAlias(
          $_aliasNameGenerator(db.words.kindOfWordRef, db.kindsOfWords.id));

  $$KindsOfWordsTableProcessedTableManager? get kindOfWordRef {
    final $_column = $_itemColumn<int>('kind_of_word_ref');
    if ($_column == null) return null;
    final manager = $$KindsOfWordsTableTableManager($_db, $_db.kindsOfWords)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_kindOfWordRefTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$SynonymsTable, List<Synonym>>
      _synonym_base_word_refTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.synonyms,
              aliasName:
                  $_aliasNameGenerator(db.words.id, db.synonyms.baseWord));

  $$SynonymsTableProcessedTableManager get synonym_base_word_ref {
    final manager = $$SynonymsTableTableManager($_db, $_db.synonyms)
        .filter((f) => f.baseWord.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_synonym_base_word_refTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$SynonymsTable, List<Synonym>>
      _synonym_word_refTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.synonyms,
              aliasName:
                  $_aliasNameGenerator(db.words.id, db.synonyms.synonymWord));

  $$SynonymsTableProcessedTableManager get synonym_word_ref {
    final manager = $$SynonymsTableTableManager($_db, $_db.synonyms)
        .filter((f) => f.synonymWord.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_synonym_word_refTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$LeipzigDataFromIntranetTable,
      List<LeipzigDataFromIntranetData>> _leipzigDataFromIntranetRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.leipzigDataFromIntranet,
          aliasName: $_aliasNameGenerator(
              db.words.id, db.leipzigDataFromIntranet.baseWord));

  $$LeipzigDataFromIntranetTableProcessedTableManager
      get leipzigDataFromIntranetRefs {
    final manager = $$LeipzigDataFromIntranetTableTableManager(
            $_db, $_db.leipzigDataFromIntranet)
        .filter((f) => f.baseWord.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_leipzigDataFromIntranetRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$MeansTable, List<Mean>> _meansRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.means,
          aliasName: $_aliasNameGenerator(db.words.id, db.means.baseWord));

  $$MeansTableProcessedTableManager get meansRefs {
    final manager = $$MeansTableTableManager($_db, $_db.means)
        .filter((f) => f.baseWord.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_meansRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$SessionsTable, List<Session>> _sessionsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.sessions,
          aliasName: $_aliasNameGenerator(db.words.id, db.sessions.baseWord));

  $$SessionsTableProcessedTableManager get sessionsRefs {
    final manager = $$SessionsTableTableManager($_db, $_db.sessions)
        .filter((f) => f.baseWord.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_sessionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ExamplesTable, List<Example>> _examplesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.examples,
          aliasName: $_aliasNameGenerator(db.words.id, db.examples.baseWord));

  $$ExamplesTableProcessedTableManager get examplesRefs {
    final manager = $$ExamplesTableTableManager($_db, $_db.examples)
        .filter((f) => f.baseWord.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_examplesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$QuestionTable, List<QuestionData>>
      _questionRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.question,
          aliasName: $_aliasNameGenerator(db.words.id, db.question.refWord));

  $$QuestionTableProcessedTableManager get questionRefs {
    final manager = $$QuestionTableTableManager($_db, $_db.question)
        .filter((f) => f.refWord.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_questionRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$WordsTableFilterComposer extends Composer<_$AppDatabase, $WordsTable> {
  $$WordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get important => $composableBuilder(
      column: $table.important, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mean => $composableBuilder(
      column: $table.mean, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get baseForm => $composableBuilder(
      column: $table.baseForm, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get rootWordID => $composableBuilder(
      column: $table.rootWordID, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get kindOfWord => $composableBuilder(
      column: $table.kindOfWord, builder: (column) => ColumnFilters(column));

  $$LanguagesTableFilterComposer get baseLang {
    final $$LanguagesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.baseLang,
        referencedTable: $db.languages,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LanguagesTableFilterComposer(
              $db: $db,
              $table: $db.languages,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$KindsOfWordsTableFilterComposer get kindOfWordRef {
    final $$KindsOfWordsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.kindOfWordRef,
        referencedTable: $db.kindsOfWords,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$KindsOfWordsTableFilterComposer(
              $db: $db,
              $table: $db.kindsOfWords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> synonym_base_word_ref(
      Expression<bool> Function($$SynonymsTableFilterComposer f) f) {
    final $$SynonymsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.synonyms,
        getReferencedColumn: (t) => t.baseWord,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SynonymsTableFilterComposer(
              $db: $db,
              $table: $db.synonyms,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> synonym_word_ref(
      Expression<bool> Function($$SynonymsTableFilterComposer f) f) {
    final $$SynonymsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.synonyms,
        getReferencedColumn: (t) => t.synonymWord,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SynonymsTableFilterComposer(
              $db: $db,
              $table: $db.synonyms,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> leipzigDataFromIntranetRefs(
      Expression<bool> Function($$LeipzigDataFromIntranetTableFilterComposer f)
          f) {
    final $$LeipzigDataFromIntranetTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.leipzigDataFromIntranet,
            getReferencedColumn: (t) => t.baseWord,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$LeipzigDataFromIntranetTableFilterComposer(
                  $db: $db,
                  $table: $db.leipzigDataFromIntranet,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<bool> meansRefs(
      Expression<bool> Function($$MeansTableFilterComposer f) f) {
    final $$MeansTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.means,
        getReferencedColumn: (t) => t.baseWord,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MeansTableFilterComposer(
              $db: $db,
              $table: $db.means,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> sessionsRefs(
      Expression<bool> Function($$SessionsTableFilterComposer f) f) {
    final $$SessionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.sessions,
        getReferencedColumn: (t) => t.baseWord,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SessionsTableFilterComposer(
              $db: $db,
              $table: $db.sessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> examplesRefs(
      Expression<bool> Function($$ExamplesTableFilterComposer f) f) {
    final $$ExamplesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.examples,
        getReferencedColumn: (t) => t.baseWord,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExamplesTableFilterComposer(
              $db: $db,
              $table: $db.examples,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> questionRefs(
      Expression<bool> Function($$QuestionTableFilterComposer f) f) {
    final $$QuestionTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.question,
        getReferencedColumn: (t) => t.refWord,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$QuestionTableFilterComposer(
              $db: $db,
              $table: $db.question,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$WordsTableOrderingComposer
    extends Composer<_$AppDatabase, $WordsTable> {
  $$WordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get important => $composableBuilder(
      column: $table.important, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mean => $composableBuilder(
      column: $table.mean, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get baseForm => $composableBuilder(
      column: $table.baseForm, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get rootWordID => $composableBuilder(
      column: $table.rootWordID, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get kindOfWord => $composableBuilder(
      column: $table.kindOfWord, builder: (column) => ColumnOrderings(column));

  $$LanguagesTableOrderingComposer get baseLang {
    final $$LanguagesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.baseLang,
        referencedTable: $db.languages,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LanguagesTableOrderingComposer(
              $db: $db,
              $table: $db.languages,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$KindsOfWordsTableOrderingComposer get kindOfWordRef {
    final $$KindsOfWordsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.kindOfWordRef,
        referencedTable: $db.kindsOfWords,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$KindsOfWordsTableOrderingComposer(
              $db: $db,
              $table: $db.kindsOfWords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$WordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WordsTable> {
  $$WordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get important =>
      $composableBuilder(column: $table.important, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get mean =>
      $composableBuilder(column: $table.mean, builder: (column) => column);

  GeneratedColumn<String> get baseForm =>
      $composableBuilder(column: $table.baseForm, builder: (column) => column);

  GeneratedColumn<int> get rootWordID => $composableBuilder(
      column: $table.rootWordID, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get kindOfWord => $composableBuilder(
      column: $table.kindOfWord, builder: (column) => column);

  $$LanguagesTableAnnotationComposer get baseLang {
    final $$LanguagesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.baseLang,
        referencedTable: $db.languages,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LanguagesTableAnnotationComposer(
              $db: $db,
              $table: $db.languages,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$KindsOfWordsTableAnnotationComposer get kindOfWordRef {
    final $$KindsOfWordsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.kindOfWordRef,
        referencedTable: $db.kindsOfWords,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$KindsOfWordsTableAnnotationComposer(
              $db: $db,
              $table: $db.kindsOfWords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> synonym_base_word_ref<T extends Object>(
      Expression<T> Function($$SynonymsTableAnnotationComposer a) f) {
    final $$SynonymsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.synonyms,
        getReferencedColumn: (t) => t.baseWord,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SynonymsTableAnnotationComposer(
              $db: $db,
              $table: $db.synonyms,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> synonym_word_ref<T extends Object>(
      Expression<T> Function($$SynonymsTableAnnotationComposer a) f) {
    final $$SynonymsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.synonyms,
        getReferencedColumn: (t) => t.synonymWord,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SynonymsTableAnnotationComposer(
              $db: $db,
              $table: $db.synonyms,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> leipzigDataFromIntranetRefs<T extends Object>(
      Expression<T> Function($$LeipzigDataFromIntranetTableAnnotationComposer a)
          f) {
    final $$LeipzigDataFromIntranetTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.leipzigDataFromIntranet,
            getReferencedColumn: (t) => t.baseWord,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$LeipzigDataFromIntranetTableAnnotationComposer(
                  $db: $db,
                  $table: $db.leipzigDataFromIntranet,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> meansRefs<T extends Object>(
      Expression<T> Function($$MeansTableAnnotationComposer a) f) {
    final $$MeansTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.means,
        getReferencedColumn: (t) => t.baseWord,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MeansTableAnnotationComposer(
              $db: $db,
              $table: $db.means,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> sessionsRefs<T extends Object>(
      Expression<T> Function($$SessionsTableAnnotationComposer a) f) {
    final $$SessionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.sessions,
        getReferencedColumn: (t) => t.baseWord,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SessionsTableAnnotationComposer(
              $db: $db,
              $table: $db.sessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> examplesRefs<T extends Object>(
      Expression<T> Function($$ExamplesTableAnnotationComposer a) f) {
    final $$ExamplesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.examples,
        getReferencedColumn: (t) => t.baseWord,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExamplesTableAnnotationComposer(
              $db: $db,
              $table: $db.examples,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> questionRefs<T extends Object>(
      Expression<T> Function($$QuestionTableAnnotationComposer a) f) {
    final $$QuestionTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.question,
        getReferencedColumn: (t) => t.refWord,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$QuestionTableAnnotationComposer(
              $db: $db,
              $table: $db.question,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$WordsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $WordsTable,
    Word,
    $$WordsTableFilterComposer,
    $$WordsTableOrderingComposer,
    $$WordsTableAnnotationComposer,
    $$WordsTableCreateCompanionBuilder,
    $$WordsTableUpdateCompanionBuilder,
    (Word, $$WordsTableReferences),
    Word,
    PrefetchHooks Function(
        {bool baseLang,
        bool kindOfWordRef,
        bool synonym_base_word_ref,
        bool synonym_word_ref,
        bool leipzigDataFromIntranetRefs,
        bool meansRefs,
        bool sessionsRefs,
        bool examplesRefs,
        bool questionRefs})> {
  $$WordsTableTableManager(_$AppDatabase db, $WordsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> uuid = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> important = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<String> mean = const Value.absent(),
            Value<String> baseForm = const Value.absent(),
            Value<int> baseLang = const Value.absent(),
            Value<int> rootWordID = const Value.absent(),
            Value<int?> version = const Value.absent(),
            Value<String?> kindOfWord = const Value.absent(),
            Value<int?> kindOfWordRef = const Value.absent(),
          }) =>
              WordsCompanion(
            id: id,
            uuid: uuid,
            name: name,
            important: important,
            description: description,
            mean: mean,
            baseForm: baseForm,
            baseLang: baseLang,
            rootWordID: rootWordID,
            version: version,
            kindOfWord: kindOfWord,
            kindOfWordRef: kindOfWordRef,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> uuid = const Value.absent(),
            required String name,
            required String important,
            required String description,
            required String mean,
            required String baseForm,
            required int baseLang,
            required int rootWordID,
            Value<int?> version = const Value.absent(),
            Value<String?> kindOfWord = const Value.absent(),
            Value<int?> kindOfWordRef = const Value.absent(),
          }) =>
              WordsCompanion.insert(
            id: id,
            uuid: uuid,
            name: name,
            important: important,
            description: description,
            mean: mean,
            baseForm: baseForm,
            baseLang: baseLang,
            rootWordID: rootWordID,
            version: version,
            kindOfWord: kindOfWord,
            kindOfWordRef: kindOfWordRef,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$WordsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {baseLang = false,
              kindOfWordRef = false,
              synonym_base_word_ref = false,
              synonym_word_ref = false,
              leipzigDataFromIntranetRefs = false,
              meansRefs = false,
              sessionsRefs = false,
              examplesRefs = false,
              questionRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (synonym_base_word_ref) db.synonyms,
                if (synonym_word_ref) db.synonyms,
                if (leipzigDataFromIntranetRefs) db.leipzigDataFromIntranet,
                if (meansRefs) db.means,
                if (sessionsRefs) db.sessions,
                if (examplesRefs) db.examples,
                if (questionRefs) db.question
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (baseLang) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.baseLang,
                    referencedTable: $$WordsTableReferences._baseLangTable(db),
                    referencedColumn:
                        $$WordsTableReferences._baseLangTable(db).id,
                  ) as T;
                }
                if (kindOfWordRef) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.kindOfWordRef,
                    referencedTable:
                        $$WordsTableReferences._kindOfWordRefTable(db),
                    referencedColumn:
                        $$WordsTableReferences._kindOfWordRefTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (synonym_base_word_ref)
                    await $_getPrefetchedData<Word, $WordsTable, Synonym>(
                        currentTable: table,
                        referencedTable: $$WordsTableReferences
                            ._synonym_base_word_refTable(db),
                        managerFromTypedResult: (p0) =>
                            $$WordsTableReferences(db, table, p0)
                                .synonym_base_word_ref,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.baseWord == item.id),
                        typedResults: items),
                  if (synonym_word_ref)
                    await $_getPrefetchedData<Word, $WordsTable, Synonym>(
                        currentTable: table,
                        referencedTable:
                            $$WordsTableReferences._synonym_word_refTable(db),
                        managerFromTypedResult: (p0) =>
                            $$WordsTableReferences(db, table, p0)
                                .synonym_word_ref,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.synonymWord == item.id),
                        typedResults: items),
                  if (leipzigDataFromIntranetRefs)
                    await $_getPrefetchedData<Word, $WordsTable,
                            LeipzigDataFromIntranetData>(
                        currentTable: table,
                        referencedTable: $$WordsTableReferences
                            ._leipzigDataFromIntranetRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$WordsTableReferences(db, table, p0)
                                .leipzigDataFromIntranetRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.baseWord == item.id),
                        typedResults: items),
                  if (meansRefs)
                    await $_getPrefetchedData<Word, $WordsTable, Mean>(
                        currentTable: table,
                        referencedTable:
                            $$WordsTableReferences._meansRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$WordsTableReferences(db, table, p0).meansRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.baseWord == item.id),
                        typedResults: items),
                  if (sessionsRefs)
                    await $_getPrefetchedData<Word, $WordsTable, Session>(
                        currentTable: table,
                        referencedTable:
                            $$WordsTableReferences._sessionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$WordsTableReferences(db, table, p0).sessionsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.baseWord == item.id),
                        typedResults: items),
                  if (examplesRefs)
                    await $_getPrefetchedData<Word, $WordsTable, Example>(
                        currentTable: table,
                        referencedTable:
                            $$WordsTableReferences._examplesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$WordsTableReferences(db, table, p0).examplesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.baseWord == item.id),
                        typedResults: items),
                  if (questionRefs)
                    await $_getPrefetchedData<Word, $WordsTable, QuestionData>(
                        currentTable: table,
                        referencedTable:
                            $$WordsTableReferences._questionRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$WordsTableReferences(db, table, p0).questionRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.refWord == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$WordsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $WordsTable,
    Word,
    $$WordsTableFilterComposer,
    $$WordsTableOrderingComposer,
    $$WordsTableAnnotationComposer,
    $$WordsTableCreateCompanionBuilder,
    $$WordsTableUpdateCompanionBuilder,
    (Word, $$WordsTableReferences),
    Word,
    PrefetchHooks Function(
        {bool baseLang,
        bool kindOfWordRef,
        bool synonym_base_word_ref,
        bool synonym_word_ref,
        bool leipzigDataFromIntranetRefs,
        bool meansRefs,
        bool sessionsRefs,
        bool examplesRefs,
        bool questionRefs})>;
typedef $$SynonymsTableCreateCompanionBuilder = SynonymsCompanion Function({
  Value<int> id,
  Value<String> uuid,
  required int baseWord,
  required int synonymWord,
  required String name,
  required int baseLang,
  required String translatedName,
});
typedef $$SynonymsTableUpdateCompanionBuilder = SynonymsCompanion Function({
  Value<int> id,
  Value<String> uuid,
  Value<int> baseWord,
  Value<int> synonymWord,
  Value<String> name,
  Value<int> baseLang,
  Value<String> translatedName,
});

final class $$SynonymsTableReferences
    extends BaseReferences<_$AppDatabase, $SynonymsTable, Synonym> {
  $$SynonymsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $WordsTable _baseWordTable(_$AppDatabase db) => db.words
      .createAlias($_aliasNameGenerator(db.synonyms.baseWord, db.words.id));

  $$WordsTableProcessedTableManager get baseWord {
    final $_column = $_itemColumn<int>('base_word')!;

    final manager = $$WordsTableTableManager($_db, $_db.words)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_baseWordTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $WordsTable _synonymWordTable(_$AppDatabase db) => db.words
      .createAlias($_aliasNameGenerator(db.synonyms.synonymWord, db.words.id));

  $$WordsTableProcessedTableManager get synonymWord {
    final $_column = $_itemColumn<int>('synonym_word')!;

    final manager = $$WordsTableTableManager($_db, $_db.words)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_synonymWordTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $LanguagesTable _baseLangTable(_$AppDatabase db) => db.languages
      .createAlias($_aliasNameGenerator(db.synonyms.baseLang, db.languages.id));

  $$LanguagesTableProcessedTableManager get baseLang {
    final $_column = $_itemColumn<int>('base_lang')!;

    final manager = $$LanguagesTableTableManager($_db, $_db.languages)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_baseLangTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$SynonymsTableFilterComposer
    extends Composer<_$AppDatabase, $SynonymsTable> {
  $$SynonymsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get translatedName => $composableBuilder(
      column: $table.translatedName,
      builder: (column) => ColumnFilters(column));

  $$WordsTableFilterComposer get baseWord {
    final $$WordsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.baseWord,
        referencedTable: $db.words,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WordsTableFilterComposer(
              $db: $db,
              $table: $db.words,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$WordsTableFilterComposer get synonymWord {
    final $$WordsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.synonymWord,
        referencedTable: $db.words,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WordsTableFilterComposer(
              $db: $db,
              $table: $db.words,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$LanguagesTableFilterComposer get baseLang {
    final $$LanguagesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.baseLang,
        referencedTable: $db.languages,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LanguagesTableFilterComposer(
              $db: $db,
              $table: $db.languages,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SynonymsTableOrderingComposer
    extends Composer<_$AppDatabase, $SynonymsTable> {
  $$SynonymsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get translatedName => $composableBuilder(
      column: $table.translatedName,
      builder: (column) => ColumnOrderings(column));

  $$WordsTableOrderingComposer get baseWord {
    final $$WordsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.baseWord,
        referencedTable: $db.words,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WordsTableOrderingComposer(
              $db: $db,
              $table: $db.words,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$WordsTableOrderingComposer get synonymWord {
    final $$WordsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.synonymWord,
        referencedTable: $db.words,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WordsTableOrderingComposer(
              $db: $db,
              $table: $db.words,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$LanguagesTableOrderingComposer get baseLang {
    final $$LanguagesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.baseLang,
        referencedTable: $db.languages,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LanguagesTableOrderingComposer(
              $db: $db,
              $table: $db.languages,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SynonymsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SynonymsTable> {
  $$SynonymsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get translatedName => $composableBuilder(
      column: $table.translatedName, builder: (column) => column);

  $$WordsTableAnnotationComposer get baseWord {
    final $$WordsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.baseWord,
        referencedTable: $db.words,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WordsTableAnnotationComposer(
              $db: $db,
              $table: $db.words,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$WordsTableAnnotationComposer get synonymWord {
    final $$WordsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.synonymWord,
        referencedTable: $db.words,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WordsTableAnnotationComposer(
              $db: $db,
              $table: $db.words,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$LanguagesTableAnnotationComposer get baseLang {
    final $$LanguagesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.baseLang,
        referencedTable: $db.languages,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LanguagesTableAnnotationComposer(
              $db: $db,
              $table: $db.languages,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SynonymsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SynonymsTable,
    Synonym,
    $$SynonymsTableFilterComposer,
    $$SynonymsTableOrderingComposer,
    $$SynonymsTableAnnotationComposer,
    $$SynonymsTableCreateCompanionBuilder,
    $$SynonymsTableUpdateCompanionBuilder,
    (Synonym, $$SynonymsTableReferences),
    Synonym,
    PrefetchHooks Function({bool baseWord, bool synonymWord, bool baseLang})> {
  $$SynonymsTableTableManager(_$AppDatabase db, $SynonymsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SynonymsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SynonymsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SynonymsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> uuid = const Value.absent(),
            Value<int> baseWord = const Value.absent(),
            Value<int> synonymWord = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> baseLang = const Value.absent(),
            Value<String> translatedName = const Value.absent(),
          }) =>
              SynonymsCompanion(
            id: id,
            uuid: uuid,
            baseWord: baseWord,
            synonymWord: synonymWord,
            name: name,
            baseLang: baseLang,
            translatedName: translatedName,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> uuid = const Value.absent(),
            required int baseWord,
            required int synonymWord,
            required String name,
            required int baseLang,
            required String translatedName,
          }) =>
              SynonymsCompanion.insert(
            id: id,
            uuid: uuid,
            baseWord: baseWord,
            synonymWord: synonymWord,
            name: name,
            baseLang: baseLang,
            translatedName: translatedName,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$SynonymsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {baseWord = false, synonymWord = false, baseLang = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (baseWord) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.baseWord,
                    referencedTable:
                        $$SynonymsTableReferences._baseWordTable(db),
                    referencedColumn:
                        $$SynonymsTableReferences._baseWordTable(db).id,
                  ) as T;
                }
                if (synonymWord) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.synonymWord,
                    referencedTable:
                        $$SynonymsTableReferences._synonymWordTable(db),
                    referencedColumn:
                        $$SynonymsTableReferences._synonymWordTable(db).id,
                  ) as T;
                }
                if (baseLang) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.baseLang,
                    referencedTable:
                        $$SynonymsTableReferences._baseLangTable(db),
                    referencedColumn:
                        $$SynonymsTableReferences._baseLangTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$SynonymsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SynonymsTable,
    Synonym,
    $$SynonymsTableFilterComposer,
    $$SynonymsTableOrderingComposer,
    $$SynonymsTableAnnotationComposer,
    $$SynonymsTableCreateCompanionBuilder,
    $$SynonymsTableUpdateCompanionBuilder,
    (Synonym, $$SynonymsTableReferences),
    Synonym,
    PrefetchHooks Function({bool baseWord, bool synonymWord, bool baseLang})>;
typedef $$TranslatedWordsTableCreateCompanionBuilder = TranslatedWordsCompanion
    Function({
  Value<int> id,
  Value<String> uuid,
  required int baseLang,
  required int targetLang,
  required String name,
  required String translatedName,
});
typedef $$TranslatedWordsTableUpdateCompanionBuilder = TranslatedWordsCompanion
    Function({
  Value<int> id,
  Value<String> uuid,
  Value<int> baseLang,
  Value<int> targetLang,
  Value<String> name,
  Value<String> translatedName,
});

final class $$TranslatedWordsTableReferences extends BaseReferences<
    _$AppDatabase, $TranslatedWordsTable, translatedwords> {
  $$TranslatedWordsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $LanguagesTable _baseLangTable(_$AppDatabase db) =>
      db.languages.createAlias(
          $_aliasNameGenerator(db.translatedWords.baseLang, db.languages.id));

  $$LanguagesTableProcessedTableManager get baseLang {
    final $_column = $_itemColumn<int>('base_lang')!;

    final manager = $$LanguagesTableTableManager($_db, $_db.languages)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_baseLangTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $LanguagesTable _targetLangTable(_$AppDatabase db) =>
      db.languages.createAlias(
          $_aliasNameGenerator(db.translatedWords.targetLang, db.languages.id));

  $$LanguagesTableProcessedTableManager get targetLang {
    final $_column = $_itemColumn<int>('target_lang')!;

    final manager = $$LanguagesTableTableManager($_db, $_db.languages)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_targetLangTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$TranslatedWordsTableFilterComposer
    extends Composer<_$AppDatabase, $TranslatedWordsTable> {
  $$TranslatedWordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get translatedName => $composableBuilder(
      column: $table.translatedName,
      builder: (column) => ColumnFilters(column));

  $$LanguagesTableFilterComposer get baseLang {
    final $$LanguagesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.baseLang,
        referencedTable: $db.languages,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LanguagesTableFilterComposer(
              $db: $db,
              $table: $db.languages,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$LanguagesTableFilterComposer get targetLang {
    final $$LanguagesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.targetLang,
        referencedTable: $db.languages,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LanguagesTableFilterComposer(
              $db: $db,
              $table: $db.languages,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TranslatedWordsTableOrderingComposer
    extends Composer<_$AppDatabase, $TranslatedWordsTable> {
  $$TranslatedWordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get translatedName => $composableBuilder(
      column: $table.translatedName,
      builder: (column) => ColumnOrderings(column));

  $$LanguagesTableOrderingComposer get baseLang {
    final $$LanguagesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.baseLang,
        referencedTable: $db.languages,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LanguagesTableOrderingComposer(
              $db: $db,
              $table: $db.languages,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$LanguagesTableOrderingComposer get targetLang {
    final $$LanguagesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.targetLang,
        referencedTable: $db.languages,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LanguagesTableOrderingComposer(
              $db: $db,
              $table: $db.languages,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TranslatedWordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TranslatedWordsTable> {
  $$TranslatedWordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get translatedName => $composableBuilder(
      column: $table.translatedName, builder: (column) => column);

  $$LanguagesTableAnnotationComposer get baseLang {
    final $$LanguagesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.baseLang,
        referencedTable: $db.languages,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LanguagesTableAnnotationComposer(
              $db: $db,
              $table: $db.languages,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$LanguagesTableAnnotationComposer get targetLang {
    final $$LanguagesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.targetLang,
        referencedTable: $db.languages,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LanguagesTableAnnotationComposer(
              $db: $db,
              $table: $db.languages,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TranslatedWordsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TranslatedWordsTable,
    translatedwords,
    $$TranslatedWordsTableFilterComposer,
    $$TranslatedWordsTableOrderingComposer,
    $$TranslatedWordsTableAnnotationComposer,
    $$TranslatedWordsTableCreateCompanionBuilder,
    $$TranslatedWordsTableUpdateCompanionBuilder,
    (translatedwords, $$TranslatedWordsTableReferences),
    translatedwords,
    PrefetchHooks Function({bool baseLang, bool targetLang})> {
  $$TranslatedWordsTableTableManager(
      _$AppDatabase db, $TranslatedWordsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TranslatedWordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TranslatedWordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TranslatedWordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> uuid = const Value.absent(),
            Value<int> baseLang = const Value.absent(),
            Value<int> targetLang = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> translatedName = const Value.absent(),
          }) =>
              TranslatedWordsCompanion(
            id: id,
            uuid: uuid,
            baseLang: baseLang,
            targetLang: targetLang,
            name: name,
            translatedName: translatedName,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> uuid = const Value.absent(),
            required int baseLang,
            required int targetLang,
            required String name,
            required String translatedName,
          }) =>
              TranslatedWordsCompanion.insert(
            id: id,
            uuid: uuid,
            baseLang: baseLang,
            targetLang: targetLang,
            name: name,
            translatedName: translatedName,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$TranslatedWordsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({baseLang = false, targetLang = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (baseLang) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.baseLang,
                    referencedTable:
                        $$TranslatedWordsTableReferences._baseLangTable(db),
                    referencedColumn:
                        $$TranslatedWordsTableReferences._baseLangTable(db).id,
                  ) as T;
                }
                if (targetLang) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.targetLang,
                    referencedTable:
                        $$TranslatedWordsTableReferences._targetLangTable(db),
                    referencedColumn: $$TranslatedWordsTableReferences
                        ._targetLangTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$TranslatedWordsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TranslatedWordsTable,
    translatedwords,
    $$TranslatedWordsTableFilterComposer,
    $$TranslatedWordsTableOrderingComposer,
    $$TranslatedWordsTableAnnotationComposer,
    $$TranslatedWordsTableCreateCompanionBuilder,
    $$TranslatedWordsTableUpdateCompanionBuilder,
    (translatedwords, $$TranslatedWordsTableReferences),
    translatedwords,
    PrefetchHooks Function({bool baseLang, bool targetLang})>;
typedef $$LeipzigDataFromIntranetTableCreateCompanionBuilder
    = LeipzigDataFromIntranetCompanion Function({
  Value<int> id,
  Value<String> uuid,
  required int baseWord,
  required String url,
  required String html,
  Value<String?> htmlOpen,
  Value<String?> htmlExamples,
  required String article,
  required String KindOfWort,
  required String wordOfBase,
});
typedef $$LeipzigDataFromIntranetTableUpdateCompanionBuilder
    = LeipzigDataFromIntranetCompanion Function({
  Value<int> id,
  Value<String> uuid,
  Value<int> baseWord,
  Value<String> url,
  Value<String> html,
  Value<String?> htmlOpen,
  Value<String?> htmlExamples,
  Value<String> article,
  Value<String> KindOfWort,
  Value<String> wordOfBase,
});

final class $$LeipzigDataFromIntranetTableReferences extends BaseReferences<
    _$AppDatabase, $LeipzigDataFromIntranetTable, LeipzigDataFromIntranetData> {
  $$LeipzigDataFromIntranetTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $WordsTable _baseWordTable(_$AppDatabase db) => db.words.createAlias(
      $_aliasNameGenerator(db.leipzigDataFromIntranet.baseWord, db.words.id));

  $$WordsTableProcessedTableManager get baseWord {
    final $_column = $_itemColumn<int>('base_word')!;

    final manager = $$WordsTableTableManager($_db, $_db.words)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_baseWordTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$LeipzigDataFromIntranetTableFilterComposer
    extends Composer<_$AppDatabase, $LeipzigDataFromIntranetTable> {
  $$LeipzigDataFromIntranetTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get url => $composableBuilder(
      column: $table.url, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get html => $composableBuilder(
      column: $table.html, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get htmlOpen => $composableBuilder(
      column: $table.htmlOpen, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get htmlExamples => $composableBuilder(
      column: $table.htmlExamples, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get article => $composableBuilder(
      column: $table.article, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get KindOfWort => $composableBuilder(
      column: $table.KindOfWort, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get wordOfBase => $composableBuilder(
      column: $table.wordOfBase, builder: (column) => ColumnFilters(column));

  $$WordsTableFilterComposer get baseWord {
    final $$WordsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.baseWord,
        referencedTable: $db.words,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WordsTableFilterComposer(
              $db: $db,
              $table: $db.words,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$LeipzigDataFromIntranetTableOrderingComposer
    extends Composer<_$AppDatabase, $LeipzigDataFromIntranetTable> {
  $$LeipzigDataFromIntranetTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get url => $composableBuilder(
      column: $table.url, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get html => $composableBuilder(
      column: $table.html, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get htmlOpen => $composableBuilder(
      column: $table.htmlOpen, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get htmlExamples => $composableBuilder(
      column: $table.htmlExamples,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get article => $composableBuilder(
      column: $table.article, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get KindOfWort => $composableBuilder(
      column: $table.KindOfWort, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get wordOfBase => $composableBuilder(
      column: $table.wordOfBase, builder: (column) => ColumnOrderings(column));

  $$WordsTableOrderingComposer get baseWord {
    final $$WordsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.baseWord,
        referencedTable: $db.words,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WordsTableOrderingComposer(
              $db: $db,
              $table: $db.words,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$LeipzigDataFromIntranetTableAnnotationComposer
    extends Composer<_$AppDatabase, $LeipzigDataFromIntranetTable> {
  $$LeipzigDataFromIntranetTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<String> get html =>
      $composableBuilder(column: $table.html, builder: (column) => column);

  GeneratedColumn<String> get htmlOpen =>
      $composableBuilder(column: $table.htmlOpen, builder: (column) => column);

  GeneratedColumn<String> get htmlExamples => $composableBuilder(
      column: $table.htmlExamples, builder: (column) => column);

  GeneratedColumn<String> get article =>
      $composableBuilder(column: $table.article, builder: (column) => column);

  GeneratedColumn<String> get KindOfWort => $composableBuilder(
      column: $table.KindOfWort, builder: (column) => column);

  GeneratedColumn<String> get wordOfBase => $composableBuilder(
      column: $table.wordOfBase, builder: (column) => column);

  $$WordsTableAnnotationComposer get baseWord {
    final $$WordsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.baseWord,
        referencedTable: $db.words,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WordsTableAnnotationComposer(
              $db: $db,
              $table: $db.words,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$LeipzigDataFromIntranetTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LeipzigDataFromIntranetTable,
    LeipzigDataFromIntranetData,
    $$LeipzigDataFromIntranetTableFilterComposer,
    $$LeipzigDataFromIntranetTableOrderingComposer,
    $$LeipzigDataFromIntranetTableAnnotationComposer,
    $$LeipzigDataFromIntranetTableCreateCompanionBuilder,
    $$LeipzigDataFromIntranetTableUpdateCompanionBuilder,
    (LeipzigDataFromIntranetData, $$LeipzigDataFromIntranetTableReferences),
    LeipzigDataFromIntranetData,
    PrefetchHooks Function({bool baseWord})> {
  $$LeipzigDataFromIntranetTableTableManager(
      _$AppDatabase db, $LeipzigDataFromIntranetTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LeipzigDataFromIntranetTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$LeipzigDataFromIntranetTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LeipzigDataFromIntranetTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> uuid = const Value.absent(),
            Value<int> baseWord = const Value.absent(),
            Value<String> url = const Value.absent(),
            Value<String> html = const Value.absent(),
            Value<String?> htmlOpen = const Value.absent(),
            Value<String?> htmlExamples = const Value.absent(),
            Value<String> article = const Value.absent(),
            Value<String> KindOfWort = const Value.absent(),
            Value<String> wordOfBase = const Value.absent(),
          }) =>
              LeipzigDataFromIntranetCompanion(
            id: id,
            uuid: uuid,
            baseWord: baseWord,
            url: url,
            html: html,
            htmlOpen: htmlOpen,
            htmlExamples: htmlExamples,
            article: article,
            KindOfWort: KindOfWort,
            wordOfBase: wordOfBase,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> uuid = const Value.absent(),
            required int baseWord,
            required String url,
            required String html,
            Value<String?> htmlOpen = const Value.absent(),
            Value<String?> htmlExamples = const Value.absent(),
            required String article,
            required String KindOfWort,
            required String wordOfBase,
          }) =>
              LeipzigDataFromIntranetCompanion.insert(
            id: id,
            uuid: uuid,
            baseWord: baseWord,
            url: url,
            html: html,
            htmlOpen: htmlOpen,
            htmlExamples: htmlExamples,
            article: article,
            KindOfWort: KindOfWort,
            wordOfBase: wordOfBase,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$LeipzigDataFromIntranetTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({baseWord = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (baseWord) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.baseWord,
                    referencedTable: $$LeipzigDataFromIntranetTableReferences
                        ._baseWordTable(db),
                    referencedColumn: $$LeipzigDataFromIntranetTableReferences
                        ._baseWordTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$LeipzigDataFromIntranetTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $LeipzigDataFromIntranetTable,
        LeipzigDataFromIntranetData,
        $$LeipzigDataFromIntranetTableFilterComposer,
        $$LeipzigDataFromIntranetTableOrderingComposer,
        $$LeipzigDataFromIntranetTableAnnotationComposer,
        $$LeipzigDataFromIntranetTableCreateCompanionBuilder,
        $$LeipzigDataFromIntranetTableUpdateCompanionBuilder,
        (LeipzigDataFromIntranetData, $$LeipzigDataFromIntranetTableReferences),
        LeipzigDataFromIntranetData,
        PrefetchHooks Function({bool baseWord})>;
typedef $$MeansTableCreateCompanionBuilder = MeansCompanion Function({
  Value<int> id,
  Value<String> uuid,
  required int baseWord,
  required String name,
  Value<int> meansOrder,
});
typedef $$MeansTableUpdateCompanionBuilder = MeansCompanion Function({
  Value<int> id,
  Value<String> uuid,
  Value<int> baseWord,
  Value<String> name,
  Value<int> meansOrder,
});

final class $$MeansTableReferences
    extends BaseReferences<_$AppDatabase, $MeansTable, Mean> {
  $$MeansTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $WordsTable _baseWordTable(_$AppDatabase db) => db.words
      .createAlias($_aliasNameGenerator(db.means.baseWord, db.words.id));

  $$WordsTableProcessedTableManager get baseWord {
    final $_column = $_itemColumn<int>('base_word')!;

    final manager = $$WordsTableTableManager($_db, $_db.words)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_baseWordTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$MeansTableFilterComposer extends Composer<_$AppDatabase, $MeansTable> {
  $$MeansTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get meansOrder => $composableBuilder(
      column: $table.meansOrder, builder: (column) => ColumnFilters(column));

  $$WordsTableFilterComposer get baseWord {
    final $$WordsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.baseWord,
        referencedTable: $db.words,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WordsTableFilterComposer(
              $db: $db,
              $table: $db.words,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MeansTableOrderingComposer
    extends Composer<_$AppDatabase, $MeansTable> {
  $$MeansTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get meansOrder => $composableBuilder(
      column: $table.meansOrder, builder: (column) => ColumnOrderings(column));

  $$WordsTableOrderingComposer get baseWord {
    final $$WordsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.baseWord,
        referencedTable: $db.words,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WordsTableOrderingComposer(
              $db: $db,
              $table: $db.words,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MeansTableAnnotationComposer
    extends Composer<_$AppDatabase, $MeansTable> {
  $$MeansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get meansOrder => $composableBuilder(
      column: $table.meansOrder, builder: (column) => column);

  $$WordsTableAnnotationComposer get baseWord {
    final $$WordsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.baseWord,
        referencedTable: $db.words,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WordsTableAnnotationComposer(
              $db: $db,
              $table: $db.words,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MeansTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MeansTable,
    Mean,
    $$MeansTableFilterComposer,
    $$MeansTableOrderingComposer,
    $$MeansTableAnnotationComposer,
    $$MeansTableCreateCompanionBuilder,
    $$MeansTableUpdateCompanionBuilder,
    (Mean, $$MeansTableReferences),
    Mean,
    PrefetchHooks Function({bool baseWord})> {
  $$MeansTableTableManager(_$AppDatabase db, $MeansTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MeansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MeansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MeansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> uuid = const Value.absent(),
            Value<int> baseWord = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> meansOrder = const Value.absent(),
          }) =>
              MeansCompanion(
            id: id,
            uuid: uuid,
            baseWord: baseWord,
            name: name,
            meansOrder: meansOrder,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> uuid = const Value.absent(),
            required int baseWord,
            required String name,
            Value<int> meansOrder = const Value.absent(),
          }) =>
              MeansCompanion.insert(
            id: id,
            uuid: uuid,
            baseWord: baseWord,
            name: name,
            meansOrder: meansOrder,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$MeansTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({baseWord = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (baseWord) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.baseWord,
                    referencedTable: $$MeansTableReferences._baseWordTable(db),
                    referencedColumn:
                        $$MeansTableReferences._baseWordTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$MeansTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MeansTable,
    Mean,
    $$MeansTableFilterComposer,
    $$MeansTableOrderingComposer,
    $$MeansTableAnnotationComposer,
    $$MeansTableCreateCompanionBuilder,
    $$MeansTableUpdateCompanionBuilder,
    (Mean, $$MeansTableReferences),
    Mean,
    PrefetchHooks Function({bool baseWord})>;
typedef $$SessionsTableCreateCompanionBuilder = SessionsCompanion Function({
  Value<int> id,
  Value<String> uuid,
  required int baseWord,
  required String typesession,
});
typedef $$SessionsTableUpdateCompanionBuilder = SessionsCompanion Function({
  Value<int> id,
  Value<String> uuid,
  Value<int> baseWord,
  Value<String> typesession,
});

final class $$SessionsTableReferences
    extends BaseReferences<_$AppDatabase, $SessionsTable, Session> {
  $$SessionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $WordsTable _baseWordTable(_$AppDatabase db) => db.words
      .createAlias($_aliasNameGenerator(db.sessions.baseWord, db.words.id));

  $$WordsTableProcessedTableManager get baseWord {
    final $_column = $_itemColumn<int>('base_word')!;

    final manager = $$WordsTableTableManager($_db, $_db.words)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_baseWordTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$SessionsTableFilterComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get typesession => $composableBuilder(
      column: $table.typesession, builder: (column) => ColumnFilters(column));

  $$WordsTableFilterComposer get baseWord {
    final $$WordsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.baseWord,
        referencedTable: $db.words,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WordsTableFilterComposer(
              $db: $db,
              $table: $db.words,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get typesession => $composableBuilder(
      column: $table.typesession, builder: (column) => ColumnOrderings(column));

  $$WordsTableOrderingComposer get baseWord {
    final $$WordsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.baseWord,
        referencedTable: $db.words,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WordsTableOrderingComposer(
              $db: $db,
              $table: $db.words,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get typesession => $composableBuilder(
      column: $table.typesession, builder: (column) => column);

  $$WordsTableAnnotationComposer get baseWord {
    final $$WordsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.baseWord,
        referencedTable: $db.words,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WordsTableAnnotationComposer(
              $db: $db,
              $table: $db.words,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SessionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SessionsTable,
    Session,
    $$SessionsTableFilterComposer,
    $$SessionsTableOrderingComposer,
    $$SessionsTableAnnotationComposer,
    $$SessionsTableCreateCompanionBuilder,
    $$SessionsTableUpdateCompanionBuilder,
    (Session, $$SessionsTableReferences),
    Session,
    PrefetchHooks Function({bool baseWord})> {
  $$SessionsTableTableManager(_$AppDatabase db, $SessionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> uuid = const Value.absent(),
            Value<int> baseWord = const Value.absent(),
            Value<String> typesession = const Value.absent(),
          }) =>
              SessionsCompanion(
            id: id,
            uuid: uuid,
            baseWord: baseWord,
            typesession: typesession,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> uuid = const Value.absent(),
            required int baseWord,
            required String typesession,
          }) =>
              SessionsCompanion.insert(
            id: id,
            uuid: uuid,
            baseWord: baseWord,
            typesession: typesession,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$SessionsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({baseWord = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (baseWord) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.baseWord,
                    referencedTable:
                        $$SessionsTableReferences._baseWordTable(db),
                    referencedColumn:
                        $$SessionsTableReferences._baseWordTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$SessionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SessionsTable,
    Session,
    $$SessionsTableFilterComposer,
    $$SessionsTableOrderingComposer,
    $$SessionsTableAnnotationComposer,
    $$SessionsTableCreateCompanionBuilder,
    $$SessionsTableUpdateCompanionBuilder,
    (Session, $$SessionsTableReferences),
    Session,
    PrefetchHooks Function({bool baseWord})>;
typedef $$ExamplesTableCreateCompanionBuilder = ExamplesCompanion Function({
  Value<int> id,
  Value<String> uuid,
  required int baseWord,
  required String name,
  Value<String> goaltext,
  Value<int> exampleOrder,
});
typedef $$ExamplesTableUpdateCompanionBuilder = ExamplesCompanion Function({
  Value<int> id,
  Value<String> uuid,
  Value<int> baseWord,
  Value<String> name,
  Value<String> goaltext,
  Value<int> exampleOrder,
});

final class $$ExamplesTableReferences
    extends BaseReferences<_$AppDatabase, $ExamplesTable, Example> {
  $$ExamplesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $WordsTable _baseWordTable(_$AppDatabase db) => db.words
      .createAlias($_aliasNameGenerator(db.examples.baseWord, db.words.id));

  $$WordsTableProcessedTableManager get baseWord {
    final $_column = $_itemColumn<int>('base_word')!;

    final manager = $$WordsTableTableManager($_db, $_db.words)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_baseWordTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ExamplesTableFilterComposer
    extends Composer<_$AppDatabase, $ExamplesTable> {
  $$ExamplesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get goaltext => $composableBuilder(
      column: $table.goaltext, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get exampleOrder => $composableBuilder(
      column: $table.exampleOrder, builder: (column) => ColumnFilters(column));

  $$WordsTableFilterComposer get baseWord {
    final $$WordsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.baseWord,
        referencedTable: $db.words,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WordsTableFilterComposer(
              $db: $db,
              $table: $db.words,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ExamplesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExamplesTable> {
  $$ExamplesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get goaltext => $composableBuilder(
      column: $table.goaltext, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get exampleOrder => $composableBuilder(
      column: $table.exampleOrder,
      builder: (column) => ColumnOrderings(column));

  $$WordsTableOrderingComposer get baseWord {
    final $$WordsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.baseWord,
        referencedTable: $db.words,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WordsTableOrderingComposer(
              $db: $db,
              $table: $db.words,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ExamplesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExamplesTable> {
  $$ExamplesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get goaltext =>
      $composableBuilder(column: $table.goaltext, builder: (column) => column);

  GeneratedColumn<int> get exampleOrder => $composableBuilder(
      column: $table.exampleOrder, builder: (column) => column);

  $$WordsTableAnnotationComposer get baseWord {
    final $$WordsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.baseWord,
        referencedTable: $db.words,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WordsTableAnnotationComposer(
              $db: $db,
              $table: $db.words,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ExamplesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ExamplesTable,
    Example,
    $$ExamplesTableFilterComposer,
    $$ExamplesTableOrderingComposer,
    $$ExamplesTableAnnotationComposer,
    $$ExamplesTableCreateCompanionBuilder,
    $$ExamplesTableUpdateCompanionBuilder,
    (Example, $$ExamplesTableReferences),
    Example,
    PrefetchHooks Function({bool baseWord})> {
  $$ExamplesTableTableManager(_$AppDatabase db, $ExamplesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExamplesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExamplesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExamplesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> uuid = const Value.absent(),
            Value<int> baseWord = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> goaltext = const Value.absent(),
            Value<int> exampleOrder = const Value.absent(),
          }) =>
              ExamplesCompanion(
            id: id,
            uuid: uuid,
            baseWord: baseWord,
            name: name,
            goaltext: goaltext,
            exampleOrder: exampleOrder,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> uuid = const Value.absent(),
            required int baseWord,
            required String name,
            Value<String> goaltext = const Value.absent(),
            Value<int> exampleOrder = const Value.absent(),
          }) =>
              ExamplesCompanion.insert(
            id: id,
            uuid: uuid,
            baseWord: baseWord,
            name: name,
            goaltext: goaltext,
            exampleOrder: exampleOrder,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$ExamplesTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({baseWord = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (baseWord) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.baseWord,
                    referencedTable:
                        $$ExamplesTableReferences._baseWordTable(db),
                    referencedColumn:
                        $$ExamplesTableReferences._baseWordTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ExamplesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ExamplesTable,
    Example,
    $$ExamplesTableFilterComposer,
    $$ExamplesTableOrderingComposer,
    $$ExamplesTableAnnotationComposer,
    $$ExamplesTableCreateCompanionBuilder,
    $$ExamplesTableUpdateCompanionBuilder,
    (Example, $$ExamplesTableReferences),
    Example,
    PrefetchHooks Function({bool baseWord})>;
typedef $$QuizGroupTableCreateCompanionBuilder = QuizGroupCompanion Function({
  Value<int> id,
  Value<String> uuid,
  required String name,
});
typedef $$QuizGroupTableUpdateCompanionBuilder = QuizGroupCompanion Function({
  Value<int> id,
  Value<String> uuid,
  Value<String> name,
});

final class $$QuizGroupTableReferences
    extends BaseReferences<_$AppDatabase, $QuizGroupTable, QuizGroupData> {
  $$QuizGroupTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$QuestionTable, List<QuestionData>>
      _questionRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.question,
          aliasName:
              $_aliasNameGenerator(db.quizGroup.id, db.question.refQuizGroup));

  $$QuestionTableProcessedTableManager get questionRefs {
    final manager = $$QuestionTableTableManager($_db, $_db.question)
        .filter((f) => f.refQuizGroup.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_questionRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$QuizGroupTableFilterComposer
    extends Composer<_$AppDatabase, $QuizGroupTable> {
  $$QuizGroupTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  Expression<bool> questionRefs(
      Expression<bool> Function($$QuestionTableFilterComposer f) f) {
    final $$QuestionTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.question,
        getReferencedColumn: (t) => t.refQuizGroup,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$QuestionTableFilterComposer(
              $db: $db,
              $table: $db.question,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$QuizGroupTableOrderingComposer
    extends Composer<_$AppDatabase, $QuizGroupTable> {
  $$QuizGroupTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));
}

class $$QuizGroupTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuizGroupTable> {
  $$QuizGroupTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  Expression<T> questionRefs<T extends Object>(
      Expression<T> Function($$QuestionTableAnnotationComposer a) f) {
    final $$QuestionTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.question,
        getReferencedColumn: (t) => t.refQuizGroup,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$QuestionTableAnnotationComposer(
              $db: $db,
              $table: $db.question,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$QuizGroupTableTableManager extends RootTableManager<
    _$AppDatabase,
    $QuizGroupTable,
    QuizGroupData,
    $$QuizGroupTableFilterComposer,
    $$QuizGroupTableOrderingComposer,
    $$QuizGroupTableAnnotationComposer,
    $$QuizGroupTableCreateCompanionBuilder,
    $$QuizGroupTableUpdateCompanionBuilder,
    (QuizGroupData, $$QuizGroupTableReferences),
    QuizGroupData,
    PrefetchHooks Function({bool questionRefs})> {
  $$QuizGroupTableTableManager(_$AppDatabase db, $QuizGroupTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuizGroupTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuizGroupTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuizGroupTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> uuid = const Value.absent(),
            Value<String> name = const Value.absent(),
          }) =>
              QuizGroupCompanion(
            id: id,
            uuid: uuid,
            name: name,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> uuid = const Value.absent(),
            required String name,
          }) =>
              QuizGroupCompanion.insert(
            id: id,
            uuid: uuid,
            name: name,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$QuizGroupTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({questionRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (questionRefs) db.question],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (questionRefs)
                    await $_getPrefetchedData<QuizGroupData, $QuizGroupTable,
                            QuestionData>(
                        currentTable: table,
                        referencedTable:
                            $$QuizGroupTableReferences._questionRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$QuizGroupTableReferences(db, table, p0)
                                .questionRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.refQuizGroup == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$QuizGroupTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $QuizGroupTable,
    QuizGroupData,
    $$QuizGroupTableFilterComposer,
    $$QuizGroupTableOrderingComposer,
    $$QuizGroupTableAnnotationComposer,
    $$QuizGroupTableCreateCompanionBuilder,
    $$QuizGroupTableUpdateCompanionBuilder,
    (QuizGroupData, $$QuizGroupTableReferences),
    QuizGroupData,
    PrefetchHooks Function({bool questionRefs})>;
typedef $$QuestionTableCreateCompanionBuilder = QuestionCompanion Function({
  Value<int> id,
  Value<String> uuid,
  required String name,
  required String answer,
  required String example,
  Value<int> refWord,
  required int refQuizGroup,
  Value<bool?> archive,
});
typedef $$QuestionTableUpdateCompanionBuilder = QuestionCompanion Function({
  Value<int> id,
  Value<String> uuid,
  Value<String> name,
  Value<String> answer,
  Value<String> example,
  Value<int> refWord,
  Value<int> refQuizGroup,
  Value<bool?> archive,
});

final class $$QuestionTableReferences
    extends BaseReferences<_$AppDatabase, $QuestionTable, QuestionData> {
  $$QuestionTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $WordsTable _refWordTable(_$AppDatabase db) => db.words
      .createAlias($_aliasNameGenerator(db.question.refWord, db.words.id));

  $$WordsTableProcessedTableManager get refWord {
    final $_column = $_itemColumn<int>('ref_word')!;

    final manager = $$WordsTableTableManager($_db, $_db.words)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_refWordTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $QuizGroupTable _refQuizGroupTable(_$AppDatabase db) =>
      db.quizGroup.createAlias(
          $_aliasNameGenerator(db.question.refQuizGroup, db.quizGroup.id));

  $$QuizGroupTableProcessedTableManager get refQuizGroup {
    final $_column = $_itemColumn<int>('ref_quiz_group')!;

    final manager = $$QuizGroupTableTableManager($_db, $_db.quizGroup)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_refQuizGroupTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$QuestionTableFilterComposer
    extends Composer<_$AppDatabase, $QuestionTable> {
  $$QuestionTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get answer => $composableBuilder(
      column: $table.answer, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get example => $composableBuilder(
      column: $table.example, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get archive => $composableBuilder(
      column: $table.archive, builder: (column) => ColumnFilters(column));

  $$WordsTableFilterComposer get refWord {
    final $$WordsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.refWord,
        referencedTable: $db.words,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WordsTableFilterComposer(
              $db: $db,
              $table: $db.words,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$QuizGroupTableFilterComposer get refQuizGroup {
    final $$QuizGroupTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.refQuizGroup,
        referencedTable: $db.quizGroup,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$QuizGroupTableFilterComposer(
              $db: $db,
              $table: $db.quizGroup,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$QuestionTableOrderingComposer
    extends Composer<_$AppDatabase, $QuestionTable> {
  $$QuestionTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get answer => $composableBuilder(
      column: $table.answer, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get example => $composableBuilder(
      column: $table.example, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get archive => $composableBuilder(
      column: $table.archive, builder: (column) => ColumnOrderings(column));

  $$WordsTableOrderingComposer get refWord {
    final $$WordsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.refWord,
        referencedTable: $db.words,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WordsTableOrderingComposer(
              $db: $db,
              $table: $db.words,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$QuizGroupTableOrderingComposer get refQuizGroup {
    final $$QuizGroupTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.refQuizGroup,
        referencedTable: $db.quizGroup,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$QuizGroupTableOrderingComposer(
              $db: $db,
              $table: $db.quizGroup,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$QuestionTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuestionTable> {
  $$QuestionTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get answer =>
      $composableBuilder(column: $table.answer, builder: (column) => column);

  GeneratedColumn<String> get example =>
      $composableBuilder(column: $table.example, builder: (column) => column);

  GeneratedColumn<bool> get archive =>
      $composableBuilder(column: $table.archive, builder: (column) => column);

  $$WordsTableAnnotationComposer get refWord {
    final $$WordsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.refWord,
        referencedTable: $db.words,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WordsTableAnnotationComposer(
              $db: $db,
              $table: $db.words,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$QuizGroupTableAnnotationComposer get refQuizGroup {
    final $$QuizGroupTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.refQuizGroup,
        referencedTable: $db.quizGroup,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$QuizGroupTableAnnotationComposer(
              $db: $db,
              $table: $db.quizGroup,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$QuestionTableTableManager extends RootTableManager<
    _$AppDatabase,
    $QuestionTable,
    QuestionData,
    $$QuestionTableFilterComposer,
    $$QuestionTableOrderingComposer,
    $$QuestionTableAnnotationComposer,
    $$QuestionTableCreateCompanionBuilder,
    $$QuestionTableUpdateCompanionBuilder,
    (QuestionData, $$QuestionTableReferences),
    QuestionData,
    PrefetchHooks Function({bool refWord, bool refQuizGroup})> {
  $$QuestionTableTableManager(_$AppDatabase db, $QuestionTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuestionTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuestionTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuestionTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> uuid = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> answer = const Value.absent(),
            Value<String> example = const Value.absent(),
            Value<int> refWord = const Value.absent(),
            Value<int> refQuizGroup = const Value.absent(),
            Value<bool?> archive = const Value.absent(),
          }) =>
              QuestionCompanion(
            id: id,
            uuid: uuid,
            name: name,
            answer: answer,
            example: example,
            refWord: refWord,
            refQuizGroup: refQuizGroup,
            archive: archive,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> uuid = const Value.absent(),
            required String name,
            required String answer,
            required String example,
            Value<int> refWord = const Value.absent(),
            required int refQuizGroup,
            Value<bool?> archive = const Value.absent(),
          }) =>
              QuestionCompanion.insert(
            id: id,
            uuid: uuid,
            name: name,
            answer: answer,
            example: example,
            refWord: refWord,
            refQuizGroup: refQuizGroup,
            archive: archive,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$QuestionTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({refWord = false, refQuizGroup = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (refWord) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.refWord,
                    referencedTable:
                        $$QuestionTableReferences._refWordTable(db),
                    referencedColumn:
                        $$QuestionTableReferences._refWordTable(db).id,
                  ) as T;
                }
                if (refQuizGroup) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.refQuizGroup,
                    referencedTable:
                        $$QuestionTableReferences._refQuizGroupTable(db),
                    referencedColumn:
                        $$QuestionTableReferences._refQuizGroupTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$QuestionTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $QuestionTable,
    QuestionData,
    $$QuestionTableFilterComposer,
    $$QuestionTableOrderingComposer,
    $$QuestionTableAnnotationComposer,
    $$QuestionTableCreateCompanionBuilder,
    $$QuestionTableUpdateCompanionBuilder,
    (QuestionData, $$QuestionTableReferences),
    QuestionData,
    PrefetchHooks Function({bool refWord, bool refQuizGroup})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$LanguagesTableTableManager get languages =>
      $$LanguagesTableTableManager(_db, _db.languages);
  $$KindsOfWordsTableTableManager get kindsOfWords =>
      $$KindsOfWordsTableTableManager(_db, _db.kindsOfWords);
  $$WordsTableTableManager get words =>
      $$WordsTableTableManager(_db, _db.words);
  $$SynonymsTableTableManager get synonyms =>
      $$SynonymsTableTableManager(_db, _db.synonyms);
  $$TranslatedWordsTableTableManager get translatedWords =>
      $$TranslatedWordsTableTableManager(_db, _db.translatedWords);
  $$LeipzigDataFromIntranetTableTableManager get leipzigDataFromIntranet =>
      $$LeipzigDataFromIntranetTableTableManager(
          _db, _db.leipzigDataFromIntranet);
  $$MeansTableTableManager get means =>
      $$MeansTableTableManager(_db, _db.means);
  $$SessionsTableTableManager get sessions =>
      $$SessionsTableTableManager(_db, _db.sessions);
  $$ExamplesTableTableManager get examples =>
      $$ExamplesTableTableManager(_db, _db.examples);
  $$QuizGroupTableTableManager get quizGroup =>
      $$QuizGroupTableTableManager(_db, _db.quizGroup);
  $$QuestionTableTableManager get question =>
      $$QuestionTableTableManager(_db, _db.question);
}
