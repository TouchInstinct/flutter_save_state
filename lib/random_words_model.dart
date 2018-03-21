import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_app/model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
part 'random_words_model.g.dart';

@JsonSerializable()
class RandomWordsModel extends Object with _$RandomWordsModelSerializerMixin implements Restorable {
  var suggestions;
  var saved;

  RandomWordsModel();

  factory RandomWordsModel.fromJson(Map<String, dynamic> json) => _$RandomWordsModelFromJson(json);

  save(String key) async {
    String json = JSON.encode(this);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json);
    print(suggestions);
  }

  Future<RandomWordsModel> restore(String key) async {
    const platform = const MethodChannel('app.channel.shared.data');
    bool wasRestarted = await platform.invokeMethod("wasRestarted");

    if (!wasRestarted) {
      _empty();
      return this;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String s = prefs.getString(key);

    if (s != null) {
      var restoredModel = new RandomWordsModel.fromJson(JSON.decode(s));
      suggestions = restoredModel.suggestions;
      saved = restoredModel.saved;
    } else {
      _empty();
    }
    return this;
  }

  _empty() {
    suggestions = <String>[];
    saved = <String>[];
  }

  bool isInitialized() {
    return suggestions != null;
  }
}