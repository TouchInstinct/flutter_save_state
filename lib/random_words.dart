import 'package:flutter/material.dart';
import 'package:flutter_app/random_words_input.dart';
import 'package:flutter_app/random_words_model.dart';
import 'package:english_words/english_words.dart';

class RandomWords extends StatefulWidget {
  final String stateKey;

  RandomWords(Key key, this.stateKey) :super(key: key);

  @override
  createState() => new RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  RandomWordsModel model = new RandomWordsModel();
  RandomWordsInput input = new RandomWordsInput();

  final biggerFont = const TextStyle(fontSize: 18.0);

  final ScrollController scrollController = new ScrollController();

  RandomWordsState() {
    _init();
  }

  _init() async {
    RandomWordsModel newModel = await model.restore(widget.stateKey);
    RandomWordsInput newInput = await input.restore(widget.stateKey);
    setState(() {
      model = newModel;
      input = newInput;
      scrollController.jumpTo(input.scrollPosition);
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
                model.save(widget.stateKey);
              }

              return _buildRow(model.suggestions[index]);
            }
        ),);
  }

  _onNotification(Notification n) {
    input.scrollPosition = scrollController.position.pixels;
    input.save(widget.stateKey);
  }

  Widget _buildRow(String word) {
    final alreadySaved = model.saved.contains(word);
    return new ListTile(
      title: new Text(
        word,
        style: biggerFont,
      ),
      trailing: new Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            model.saved.remove(word);
          } else {
            model.saved.add(word);
          }
        });
        model.save(widget.stateKey);
      },
    );
  }
}