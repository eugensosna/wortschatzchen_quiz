
import 'package:wortschatzchen_quiz/db/db.dart';
import 'package:wortschatzchen_quiz/providers/app_data_provider.dart';
import 'package:wortschatzchen_quiz/quiz/models/quiz_card.dart';

class Deck {
  int id;
  String deckTitle;
  List<QuizCard> cards = [];

  Deck({required this.id, required this.deckTitle, required this.cards});

  static Deck fromJson(Map<String, dynamic> json) {
    List<QuizCard> cards = [];
    for (var item in json['cards']) {
      cards.add(QuizCard.fromJson(item));
    }
    var d = json['cards'].map((e) => QuizCard.fromJson(e)).toList();
    return Deck(id: json['id'], deckTitle: json['deckTitle'], cards: cards);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'deckTitle': deckTitle,
      'cards': cards
          .map(
            (e) => e.toJson(),
          )
          .toList()
    };
  }

  Future<Deck> save(AppDataProvider provider) async {
    var db = provider.db;
    var quizGroup = await db.getQuizByNameOrId(deckTitle);
    if (quizGroup == null) {
      //quiz_group
      id = await db.into(db.quizGroup).insert(QuizGroupCompanion.insert(name: deckTitle));
      quizGroup = await db.getQuizByNameOrId(
        deckTitle,
        id: id,
      );
    }
    if (quizGroup != null) {
      id = quizGroup.id;
      var toUpdate = quizGroup.copyWith(name: deckTitle);
      await db.update(db.quizGroup).replace(toUpdate);
      for (var element in cards) {
        await element.save(provider, this);
      }
    } else {
      Exception("can't find $id name $deckTitle");
    }
    return this;
  }
}
