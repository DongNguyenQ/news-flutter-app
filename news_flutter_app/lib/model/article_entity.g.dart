// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArticleEntity _$ArticleEntityFromJson(Map<String, dynamic> json) {
  return ArticleEntity(
    json['status'] as String,
    json['total_results'] as int,
    SourceEntity.fromJson(json['source'] as Map<String, dynamic>),
    json['author'] as String,
    json['title'] as String,
    json['description'] as String,
    json['url'] as String,
    json['url_to_image'] as String,
    DateTime.parse(json['published_at'] as String),
    json['content'] as String,
  );
}

Map<String, dynamic> _$ArticleEntityToJson(ArticleEntity instance) =>
    <String, dynamic>{
      'status': instance.status,
      'total_results': instance.totalResults,
      'source': instance.source.toJson(),
      'author': instance.author,
      'title': instance.title,
      'description': instance.description,
      'url': instance.url,
      'url_to_image': instance.urlToImage,
      'published_at': instance.publishedAt.toIso8601String(),
      'content': instance.content,
    };
