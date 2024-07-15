import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:talker/talker.dart';
import 'package:uuid/uuid.dart';
import 'package:wortschatzchen_quiz/db/db.dart';
import 'package:wortschatzchen_quiz/db/db_helper.dart';
import 'package:wortschatzchen_quiz/models/leipzig_word.dart';
import 'package:wortschatzchen_quiz/providers/app_data_provider.dart';

class WidgetAutoComplit extends StatefulWidget {
  final ItemScrollController scrollController;
  List<Word> listWords;
  Talker talker = Talker();
  final Function navigateToDetail;
  final FocusNode listViewFocusNode;
  final TextEditingController autocompleteController;

  WidgetAutoComplit(
      {super.key,
      required this.scrollController,
      required this.listWords,
      required this.navigateToDetail,
      required this.listViewFocusNode,
      required this.autocompleteController}) {
    // TODO: implement WidgetAutoComplit
    return;
  }

  @override
  State<WidgetAutoComplit> createState() => _WidgetAutoComplitState();
}

class _WidgetAutoComplitState extends State<WidgetAutoComplit> {
  Map<String, dynamic> searchCache = {};
  late DbHelper db;
  String currentSearch = "";
  bool stateAutocomplit = false;
  String unviewUnicode = "	";

  TextEditingController autocompleteController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.talker = Provider.of<AppDataProvider>(context, listen: false).talker;
    db = Provider.of<AppDataProvider>(context, listen: false).db;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return autoCompliteWidget();
  }

  Container autoCompliteWidget() {
    return Container(
      padding: const EdgeInsets.only(left: 8.2),
      // decoration: BoxDecoration(
      //     border: Border.all(color: Colors.redAccent)),
      child: Autocomplete<AutocompleteDataHelper>(
        optionsBuilder: (textEditingValue) async {
          autocompleteController.text = textEditingValue.text;
          final textToSearch = textEditingValue.text.trim();
          List<AutocompleteDataHelper> autoComplitDataLoc = [];
          widget.autocompleteController.text = textEditingValue.text;

          if (textToSearch.isNotEmpty) {
            for (var (index, element) in widget.listWords.indexed) {
              if (element.name.toLowerCase().startsWith(textToSearch.toLowerCase())) {
                var indexToScroll = index - 2 > 0 ? index - 2 : index;
                widget.scrollController
                    .scrollTo(index: indexToScroll, duration: const Duration(milliseconds: 50));
                break;
              }
            }
          }

          if (textToSearch.isEmpty || textToSearch.length <= 1) {
            searchCache.clear();
            return autoComplitDataLoc;
          }

          // if (textToSearch.isNotEmpty && textToSearch.length <= 4) {
          fillAutocompleteDelayed(textToSearch);

          var autoComplitDataLocal = getAutoCompliteFromCache(textToSearch);

          // } else {
          // autoComplitData = await getAutoCompliteForKindeOfWord(textToSearch);

          //}

          return autoComplitDataLocal;
        },
        onSelected: (AutocompleteDataHelper item) async {
          // widget.talker.debug("onSelected ${item.name}");

          var currentName = item.name;
          item.name = "";
          clearAutoComplite();
          if (item.isIntern) {
            Word? wordItem = await db.getWordByName(currentName);

            if (wordItem != null) {
              for (var (index, element) in widget.listWords.indexed) {
                if (element.name == item.name) {
                  widget.scrollController
                      .scrollTo(index: index, duration: const Duration(milliseconds: 100));
                  break;
                }
              }
              Future.delayed(const Duration(milliseconds: 500), () {
                widget.navigateToDetail(wordItem, "View");
              });
            }
            // navigateToDetail(wordItem, "View ${wordItem.name}");
          } else {
            widget.navigateToDetail(
                Word(
                    id: -99,
                    uuid: "uuid",
                    name: currentName,
                    important: "",
                    description: "",
                    mean: "",
                    baseForm: "",
                    baseLang: 0,
                    rootWordID: 0),
                "Add ${item.name}");
          }
          widget.listViewFocusNode.requestFocus();
        },
        fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
          if (stateAutocomplit) {
            textEditingController.text = "";

            stateAutocomplit = false;
            widget.listViewFocusNode.requestFocus();
          }

          if (textEditingController.text.contains(unviewUnicode)) {
            widget.talker.verbose("""
fieldViewBuilder contains + ${textEditingController.text}""");
            textEditingController.text = "";
          }

          return TextFormField(
              focusNode: focusNode,
              controller: textEditingController,
              onFieldSubmitted: (value) {
                onFieldSubmitted();
              },
              decoration: InputDecoration(
                suffixIcon: Padding(
                  padding: const EdgeInsetsDirectional.only(end: 12.0),
                  child: IconButton(
                    onPressed: () {
                      widget.talker.verbose("on refresh");
                      clearAutoComplite();
                    },
                    icon: const Icon(Icons.refresh),
                  ),
                  // hoverColor: Colors.black38,
                ),
              ));
        },
      ),
    );
  }

  void fillAutocompleteDelayed(String textToSearch) {
    if (searchCache.containsKey(textToSearch)) {
      // var autoComplitData = searchCache[textToSearch];
      return;
    }
    if (currentSearch == textToSearch) {
    } else {
      if (textToSearch.isEmpty) {
        // autoComplitData.clear();
      } else {
        currentSearch = textToSearch;

        Future.delayed(const Duration(microseconds: 1), () async {
          var autoComplitData = await getAutoCompliteForKindOfWord(currentSearch);
        });
      }
    }
  }

  List<AutocompleteDataHelper> getAutoCompliteFromCache(String textToSearch,
      {bool recursion = false}) {
    List<AutocompleteDataHelper> autoComplitDataLocal = [];

    if (searchCache.containsKey(textToSearch)) {
      autoComplitDataLocal = searchCache[textToSearch];
    }

    if (autoComplitDataLocal.isEmpty && textToSearch.isNotEmpty) {
      var newSearch = textToSearch.substring(0, textToSearch.length - 1);
      autoComplitDataLocal = getAutoCompliteFromCache(newSearch, recursion: true);
    }
    var toReturn = autoComplitDataLocal.toList();
    if (!recursion) {
      toReturn.firstWhere((element) => element.name == textToSearch, orElse: () {
        var newElement =
            AutocompleteDataHelper(name: textToSearch, isIntern: false, uuid: const Uuid().v4());
        toReturn.insert(0, newElement);
        return newElement;
      });

      // toReturn.sort((a, b) => a.name.length.compareTo(b.name.length));
      toReturn.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    }
    return toReturn;
  }

  Future<List<AutocompleteDataHelper>> getAutoCompliteForKindOfWord(String textToSearch) async {
    widget.talker.verbose("start getAutoCompliteForKindOfWord $textToSearch current $textToSearch");

    List<AutocompleteDataHelper> autoComplitDataLocal = [];
    if (searchCache.containsKey(textToSearch)) {
      autoComplitDataLocal = searchCache[textToSearch];

      var toReturn = autoComplitDataLocal.toList();
      toReturn.firstWhere((element) => element.name == textToSearch, orElse: () {
        var newElement =
            AutocompleteDataHelper(name: textToSearch, isIntern: false, uuid: const Uuid().v4());
        toReturn.insert(0, newElement);
        return newElement;
      });
      return toReturn;
    }
    var toSearch = textToSearch;

    if (toSearch.startsWith("+ ")) {
      toSearch = toSearch.replaceFirst("+ ", "");
    }

    var leipzig = LeipzigWord(toSearch, db, widget.talker);
    List<AutocompleteDataHelper> autoComplitDataLoc = [];

    autoComplitDataLoc = [];

    // var autoComplitDataExt = await leipzig.getAutocomplete(toSearch);
    var autoComplitDataVerb = await leipzig.getAutocompleteVerbForm(toSearch);

    // autoComplitDataLoc.addAll(autoComplitDataExt);
    autoComplitDataLoc.addAll(autoComplitDataVerb);

    // var element =
    //     autoComplitDataLocal.firstWhere((element) => element.name == toSearch);
    // searchCache[toSearch] = autoComplitDataLocal.toList();

    widget.talker.verbose(
        "fillAutocomplitDelayed  save $textToSearch in cache ${autoComplitDataLoc.length}");
    var toReturn = autoComplitDataLoc.toList();

    final ids = toReturn.map((toElement) => toElement.name).toSet();
    toReturn.retainWhere(
      (element) {
        if (ids.contains(element.name)) {
          ids.remove(element.name);
          return true;
        } else {
          return false;
        }
      },
    );

    var autoComplitDataDB = await leipzig.getAutocompleteLocal(toSearch);
    toReturn.addAll(autoComplitDataDB);
    toReturn = sortAutocomplit(toReturn, toSearch);
    //update cache
    toReturn.firstWhere((element) => element.name == textToSearch, orElse: () {
      var newElement =
          AutocompleteDataHelper(name: toSearch, isIntern: false, uuid: const Uuid().v4());
      toReturn.insert(0, newElement);
      return newElement;
    });

    toReturn.map((element) {
      searchCache[element.name] = toReturn;
      return element;
    }).toList();

    return toReturn;
  }

  List<AutocompleteDataHelper> sortAutocomplit(
      List<AutocompleteDataHelper> autoComplite, String textToSearch) {
    autoComplite = autoComplite.toList();
    autoComplite.sort(
      (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
    );

    autoComplite.sort((a, b) {
      if (a.name.startsWith(textToSearch) && !b.name.startsWith(textToSearch)) {
        return -1;
      } else {
        if (!a.name.startsWith(textToSearch) && b.name.startsWith(textToSearch)) {
          return 1;
        } else {
          return a.name.compareTo(b.name);
        }
      }
    });

    return autoComplite;
  }

  void clearAutoComplite() {
    stateAutocomplit = true;
    searchCache.clear();
    searchCache = {};
    // debugPrint(item.name);
    autocompleteController.clear();

    setState(() {
      stateAutocomplit = true;
    });
  }
}
