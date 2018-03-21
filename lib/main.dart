import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/random_words.dart';
import 'dart:async';

void main() => runApp(new MyApp());

class Keys {
  static GlobalKey<RandomWordsState> key = new GlobalKey<RandomWordsState>();
}

class Routes {
  static Queue<String> routes = new Queue<String>();
  static var _firstTime = true;

  static save() async {
    const platform = const MethodChannel('app.channel.shared.data');
    platform.invokeMethod(
        "saveInput", {"key": "routes", "value": JSON.encode(routes.toList())});
  }

  static restore(BuildContext context) async {
    if (!_firstTime) {
      return;
    }
    const platform = const MethodChannel('app.channel.shared.data');
    String s = await platform.invokeMethod("readInput", {"key": "routes"});
    if (s != null) {
      routes = new Queue<String>();
      routes.addAll(JSON.decode(s));
    }
    _firstTime = false;
    for (String route in routes) {
      Navigator.of(context).pushNamed(route);
    }
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Startup Name Generator'),
      routes: <String, WidgetBuilder>{
        '/saved': (BuildContext context) =>
        new SavedPage(title: 'Saved Suggestions'),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    Routes.restore(context);
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: new RandomWords(Keys.key, "list"),
    );
  }

  void _pushSaved() async {
    Routes.routes.addLast('/saved');
    await Routes.save();
    Navigator.of(context).pushNamed('/saved');
  }
}

class SavedPage extends StatefulWidget {
  SavedPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SavedPageState createState() => new _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {

  @override
  Widget build(BuildContext context) {
    if (!Keys.key.currentState.model.isInitialized()) {
      return new Container();
    }
    final tiles = Keys.key.currentState.model.saved.map(
          (pair) {
        return new ListTile(
          title: new Text(
            pair,
            style: Keys.key.currentState.biggerFont,
          ),
        );
      },
    );
    final divided = ListTile
        .divideTiles(
      context: context,
      tiles: tiles,
    )
        .toList();
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Saved Suggestions'),
      ),
      body: new WillPopScope(
        onWillPop: _onWillPop,
        child: new ListView(children: divided),),
    );
  }

  Future<bool> _onWillPop() async {
    Routes.routes.removeLast();
    await Routes.save();
    return true;
  }
}
