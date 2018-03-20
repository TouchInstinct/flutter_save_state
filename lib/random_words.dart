import 'package:flutter/material.dart';
import 'package:flutter_app/random_words_model.dart';
import 'package:english_words/english_words.dart';

class RandomWords extends StatefulWidget {
  final String modelKey;

  RandomWords(this.modelKey);

  @override
  createState() => new RandomWordsState(modelKey);
}

class RandomWordsState extends State<RandomWords> {
  String modelKey;
  RandomWordsModel model = new RandomWordsModel();

  final _biggerFont = const TextStyle(fontSize: 18.0);

  final ScrollController scrollController = new ScrollController();

  RandomWordsState(String stateKey) {
    this.modelKey = stateKey;
    _init();
  }

  _init() async {
    RandomWordsModel newModel = await model.restore(modelKey);
    setState(() {
      model = newModel;
      scrollController.jumpTo(model.scrollPosition);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildSuggestions();
  }

  Widget _buildSuggestions() {
    return
      new NotificationListener(
        onNotification: _onNotification,
        child: new ListView.builder(
            padding: const EdgeInsets.all(16.0),

            controller: scrollController,

            itemBuilder: (context, i) {
              if (!model.isInitialized())
                return null;

              if (i.isOdd) return new Divider();

              final index = i ~/ 2;
              // If you've reached the end of the available word pairings...
              if (index >= model.suggestions.length) {
                // ...then generate 10 more and add them to the suggestions list.
                var newSuggestions = generateWordPairs().take(10);
                for (WordPair pair in newSuggestions) {
                  model.suggestions.add(pair.asPascalCase);
                }
                model.save(modelKey);
              }

              return _buildRow(model.suggestions[index]);
            }
        ),);
  }

  _onNotification(Notification n) {
    model.scrollPosition = scrollController.position.pixels;
    model.save(modelKey);
  }

  Widget _buildRow(String word) {
    return new ListTile(
      title: new Text(
        word,
        style: _biggerFont,
      ),
    );
  }
}