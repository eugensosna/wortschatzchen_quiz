import 'dart:convert';

// Define classes to represent the data structure
class OpenThesaurusResponse {
  final MetaData metaData;
  final List<Synset> synsets;

  OpenThesaurusResponse({required this.metaData, required this.synsets});

  factory OpenThesaurusResponse.fromJson(Map<String, dynamic> json) {
    return OpenThesaurusResponse(
      metaData: MetaData.fromJson(json['metaData']),
      synsets: (json['synsets'] as List).map((synset) => Synset.fromJson(synset)).toList(),
    );
  }
}

class MetaData {
  final String apiVersion;
  final String warning;
  final String copyright;
  final String license;
  final String source;
  final String date;

  MetaData({
    required this.apiVersion,
    required this.warning,
    required this.copyright,
    required this.license,
    required this.source,
    required this.date,
  });

  factory MetaData.fromJson(Map<String, dynamic> json) {
    return MetaData(
      apiVersion: json['apiVersion'],
      warning: json['warning'],
      copyright: json['copyright'],
      license: json['license'],
      source: json['source'],
      date: json['date'],
    );
  }
}

class Synset {
  final int id;
  final List<String> categories;
  final List<Term> terms;

  Synset({required this.id, required this.categories, required this.terms});

  factory Synset.fromJson(Map<String, dynamic> json) {
    return Synset(
      id: json['id'],
      categories: List<String>.from(json['categories']),
      terms: (json['terms'] as List).map((term) => Term.fromJson(term)).toList(),
    );
  }
}

class Term {
  final String term;
  final String? level;

  Term({required this.term, this.level});

  factory Term.fromJson(Map<String, dynamic> json) {
    return Term(
      term: json['term'],
      level: json['level'],
    );
  }
}

void main() {
  // Your JSON string
  String jsonString = '''
  {"metaData":{"apiVersion":"0.2","warning":"ACHTUNG: Bitte vor ernsthafter Nutzung feedback@openthesaurus.de kontaktieren, um bei API-Änderungen informiert zu werden","copyright":"Copyright (C) 2023 Daniel Naber (www.danielnaber.de)","license":"Creative Commons Attribution-ShareAlike 4.0 or GNU LESSER GENERAL PUBLIC LICENSE Version 2.1","source":"https://www.openthesaurus.de","date":"Wed Jul 17 10:13:49 UTC 2024"},"synsets":[{"id":292,"categories":[],"terms":[{"term":"Erprobung"},{"term":"Probe"},{"term":"Prüfung"},{"term":"Test"},{"term":"Versuch"}]},{"id":4398,"categories":[],"terms":[{"term":"Leistungsnachweis"},{"term":"Prüfung"},{"term":"Test"}]},{"id":5752,"categories":[],"terms":[{"term":"Klassenarbeit"},{"term":"Klausur"},{"term":"Leistungsüberprüfung"},{"term":"Lernerfolgskontrolle"},{"term":"Prüfung"},{"term":"Schularbeit"},{"term":"Schulaufgabe"},{"term":"Test"},{"term":"Arbeit","level":"umgangssprachlich"},{"term":"Probe","level":"umgangssprachlich"}]},{"id":9138,"categories":[],"terms":[{"term":"Experiment"},{"term":"(die) Probe aufs Exempel"},{"term":"Probelauf"},{"term":"Studie"},{"term":"Test"},{"term":"Testballon"},{"term":"Testlauf"},{"term":"Trockenlauf"},{"term":"Trockentest"},{"term":"Versuch"},{"term":"Versuchsballon"}]},{"id":6241,"categories":[],"terms":[{"term":"Bewährungsprobe"},{"term":"Feuerprobe"},{"term":"Feuertaufe"},{"term":"harte Prüfung"},{"term":"Lackmustest"},{"term":"Nagelprobe"},{"term":"Test"}]}]}
  ''';

  // Parse the JSON
  Map<String, dynamic> jsonMap = jsonDecode(jsonString);
  OpenThesaurusResponse response = OpenThesaurusResponse.fromJson(jsonMap);

  // Now you can access the parsed data
  //print('API Version: ${response.metaData.apiVersion}');
  //print('Number of synsets: ${response.synsets.length}');

  // Example: Print all terms from the first synset
  if (response.synsets.isNotEmpty) {
    print('Terms in first synset:');
    for (var term in response.synsets[0].terms) {
      print('- ${term.term}${term.level != null ? ' (${term.level})' : ''}');
    }
  }
}
