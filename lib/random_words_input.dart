import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_app/model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
part 'random_words_input.g.dart';

@JsonSerializable()
class RandomWordsInput extends Object with _$RandomWordsInputSerializerMixin implements Restorable {
  double scrollPosition = -1.0;

  RandomWordsInput();

  factory RandomWordsInput.fromJson(Map<String, dynamic> json) => _$RandomWordsInputFromJson(json);

  save(String key) async {
    String json = JSON.encode(this);
    const platform = const MethodChannel('app.channel.shared.data');
    platform.invokeMethod("saveInput", {"key": key, "value": json});
  }

  Future<RandomWordsInput> restore(String key) async {
    const platform = const MethodChannel('app.channel.shared.data');
    String s = await platform.invokeMethod("readInput", {"key" : key});

    if (s != null) {
      var restoredModel = new RandomWordsInput.fromJson(JSON.decode(s));
      scrollPosition = restoredModel.scrollPosition;
    } else {
      _empty();
    }
    return this;
  }

  _empty() {
    scrollPosition = 0.0;
  }

  bool isInitialized() {
    return scrollPosition >= 0;
  }
}