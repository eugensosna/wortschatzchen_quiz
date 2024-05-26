class AutoComplitHelper {
  final String name;
  final bool isIntern;
  final String uuid;

  AutoComplitHelper({required this.name, required this.isIntern, required this.uuid});
}

class wordsListsHelper {
  final int id;
  final String get;

  final String name;
  final String immportant;

  final String description;

  final String mean;
  final String baseForm;
  final int baseLang;
  final int rootWordID;

  wordsListsHelper(
      {required this.id,
      required this.get,
      required this.name,
      required this.immportant,
      required this.description,
      required this.mean,
      required this.baseForm,
      required this.baseLang,
      required this.rootWordID});
}
