// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'random_words_model.dart';

// **************************************************************************
// Generator: JsonSerializableGenerator
// **************************************************************************

RandomWordsModel _$RandomWordsModelFromJson(Map<String, dynamic> json) =>
    new RandomWordsModel()
      ..suggestions =
          (json['suggestions'] as List)?.map((e) => e as String)?.toList()
      ..saved = (json['saved'] as List)?.map((e) => e as String)?.toList();

abstract class _$RandomWordsModelSerializerMixin {
  List<String> get suggestions;
  List<String> get saved;
  Map<String, dynamic> toJson() =>
      <String, dynamic>{'suggestions': suggestions, 'saved': saved};
}
