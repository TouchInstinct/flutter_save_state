// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'random_words_model.dart';

// **************************************************************************
// Generator: JsonSerializableGenerator
// **************************************************************************

RandomWordsModel _$RandomWordsModelFromJson(Map<String, dynamic> json) =>
    new RandomWordsModel()
      ..suggestions = json['suggestions']
      ..scrollPosition = (json['scrollPosition'] as num)?.toDouble();

abstract class _$RandomWordsModelSerializerMixin {
  dynamic get suggestions;
  double get scrollPosition;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'suggestions': suggestions,
        'scrollPosition': scrollPosition
      };
}
