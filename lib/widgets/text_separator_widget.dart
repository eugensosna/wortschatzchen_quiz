import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:wortschatzchen_quiz/db/db.dart';
import 'package:wortschatzchen_quiz/models/WordMvc.dart';
import 'package:wortschatzchen_quiz/models/leipzig_word.dart';
import 'package:wortschatzchen_quiz/providers/app_data_provider.dart';

class TextSeparatorWidget extends StatefulWidget {
  const TextSeparatorWidget({Key? key}) : super(key: key);

  @override
  State<TextSeparatorWidget> createState() => _TextSeparatorWidgetState();
}

class _TextSeparatorWidgetState extends State<TextSeparatorWidget> {
  final TextEditingController _textController = TextEditingController();
  List<dynamic> _uniqueWords = [];

  Future<List<dynamic>> _separateText() async {
    String text = _textController.text;
    if (text.isEmpty) {
      setState(() {
        _uniqueWords = [];
      });
      return [];
    }

    Set<String> uniqWords = text.split(RegExp(r'\s+')).where((item) => item.isNotEmpty).toSet();

    List<String> wordsSet = [];

    int counter = 0;
    for (var itemPosition in uniqWords) {
      await Future.delayed(Duration(seconds: 1));
      await addWordIfNeed(itemPosition);
      wordsSet.add(itemPosition);
      counter++;
      if (counter % 3 == 0) {
        setState(() {
          _uniqueWords = wordsSet;
        });
      }
    }

    setState(() {
      _uniqueWords = wordsSet.toList()..sort();
    });
    return wordsSet.toList()..sort();
  }

  Future<Word> addWordIfNeed(String name) async {
    Word? result;
    var provider = Provider.of<AppDataProvider>(context, listen: false);
    var db = provider.db;
    var talker = provider.talker;
    result = await db.getWordByName(name);
    if (result != null) {
      return result;
    } else {
      // Word  result = Word( name: name, id: null, uuid: '', important: '', description: '', mean: '', baseForm: '', baseLang: null, rootWordID: null);
      var newId = await db.into(db.words).insert(WordsCompanion.insert(
          name: name,
          important: '',
          description: '',
          mean: '',
          baseForm: '',
          baseLang: 0,
          rootWordID: 0));
      var newWord = await db.getWordById(newId);
      if (newWord != null) {
        Word editWord = newWord;

        var leipzigWord = LeipzigWord(name, db, talker);
        leipzigWord.talker.warning("start _addUpdateWord- getFromInternet ${name}");
        try {
          var tempWord = await leipzigWord.getParseAllData(leipzigWord, editWord, provider);
          tempWord.translateNeededWords();
          editWord = (await db.getWordById(newId))!;
          if (editWord.description.isEmpty) {
            var description = await leipzigWord.translator.translate(editWord.name);
            var updatetWord = editWord.copyWith(description: description);
            await db.updateWord(updatetWord);
            result = editWord;
            // db.update(db.words)
          }
        } on Exception catch (e) {
          result = Word(
              id: 0,
              name: name,
              important: "",
              description: '',
              mean: '',
              baseForm: '',
              baseLang: 0,
              rootWordID: 0,
              uuid: '');
          talker.error("get data from Internet ${editWord.name}", e);
        }
      }
      // return result!;
    }

    return result!;
  }

  void _clearText() {
    setState(() {
      _textController.clear();
      _uniqueWords = [];
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Text Separator'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // First widget - Text input section
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Enter your text:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        maxLines: null,
                        expands: true,
                        // decoration: const InputDecoration(
                        //   hintText: 'Type your multiline text here...',
                        //   border: OutlineInputBorder(),
                        //   contentPadding: EdgeInsets.all(12),
                        // ),
                        textAlignVertical: TextAlignVertical.top,
                        keyboardType: TextInputType.multiline,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _separateText,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text(
                              'Separate',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: _clearText,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          ),
                          child: const Text('Clear'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Second widget - Unique words list
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Unique Words:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (_uniqueWords.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${_uniqueWords.length} words',
                              style: TextStyle(
                                color: Colors.blue.shade800,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: _uniqueWords.isEmpty
                          ? const Center(
                              child: Text(
                                'No words to display.\nEnter text above and press "Separate".',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: _uniqueWords.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  elevation: 1,
                                  margin: const EdgeInsets.symmetric(vertical: 2),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.blue.shade100,
                                      child: Text(
                                        '${index + 1}',
                                        style: TextStyle(
                                          color: Colors.blue.shade800,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      _uniqueWords[index],
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
