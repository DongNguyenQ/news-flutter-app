import 'package:json_annotation/json_annotation.dart';
import 'package:news_flutter_app/model/source_entity.dart';

part 'article_entity.g.dart';

@JsonSerializable(explicitToJson: true)
class ArticleEntity {
  final SourceEntity? source;
  final String? author;
  final String? title;
  final String? description;
  final String? url;
  final String? urlToImage;
  final dynamic publishedAt;
  final String? content;

  ArticleEntity(this.source, this.author, this.title, this.description,
      this.url, this.urlToImage, this.publishedAt, this.content);

  factory ArticleEntity.fromJson(Map<String, dynamic> json) =>
      _$ArticleEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ArticleEntityToJson(this);
}
