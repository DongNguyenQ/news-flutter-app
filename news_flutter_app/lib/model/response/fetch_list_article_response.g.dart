// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetch_list_article_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FetchListArticleResponse _$FetchListArticleResponseFromJson(
    Map<String, dynamic> json) {
  return FetchListArticleResponse(
    json['status'] as String?,
    json['totalResults'] as int?,
    (json['articles'] as List<dynamic>?)
        ?.map((e) => ArticleEntity.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$FetchListArticleResponseToJson(
        FetchListArticleResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'totalResults': instance.totalResults,
      'articles': instance.articles?.map((e) => e.toJson()).toList(),
    };
