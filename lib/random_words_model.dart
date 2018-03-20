import 'dart:async';

import 'package:flutter_app/model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
part 'random_words_model.g.dart';

@JsonSerializable()
class RandomWordsModel extends Object with _$RandomWordsModelSerializerMixin implements Model {
  var suggestions;
  double scrollPosition = 0.0;

  RandomWordsModel();

  factory RandomWordsModel.fromJson(Map<String, dynamic> json) => _$RandomWordsModelFromJson(json);

  save(String key) async {
    String json = JSON.encode(this);
    const platform = const MethodChannel('app.channel.shared.data');
    platform.invokeMethod("saveModel", {"key": key, "value": json});
  }

  Future<RandomWordsModel> restore(String key) async {
    const platform = const MethodChannel('app.channel.shared.data');
    String s = await platform.invokeMethod("readModel", {"key": key});

    if (s != null) {
      var restoredModel = new RandomWordsModel.fromJson(JSON.decode(s));
      suggestions = restoredModel.suggestions;
      scrollPosition = restoredModel.scrollPosition;
    } else {
      suggestions = <String>[];
    }
    return this;
  }

  bool isInitialized() {
    return suggestions != null;
  }
}