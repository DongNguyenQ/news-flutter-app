// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArticleEntity _$ArticleEntityFromJson(Map<String, dynamic> json) {
  return ArticleEntity(
    json['source'] == null
        ? null
        : SourceEntity.fromJson(json['source'] as Map<String, dynamic>),
    json['author'] as String?,
    json['title'] as String?,
    json['description'] as String?,
    json['url'] as String?,
    json['urlToImage'] as String?,
    json['publishedAt'],
    json['content'] as String?,
  );
}

Map<String, dynamic> _$ArticleEntityToJson(ArticleEntity instance) =>
    <String, dynamic>{
      'source': instance.source?.toJson(),
      'author': instance.author,
      'title': instance.title,
      'description': instance.description,
      'url': instance.url,
      'urlToImage': instance.urlToImage,
      'publishedAt': instance.publishedAt,
      'content': instance.content,
    };
