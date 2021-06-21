import 'package:json_annotation/json_annotation.dart';
import 'package:news_flutter_app/model/base_response.dart';
import 'package:news_flutter_app/model/source_entity.dart';

part 'article_entity.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class ArticleEntity extends BaseResponse {
  final SourceEntity source;
  final String author;
  final String title;
  final String description;
  final String url;
  final String urlToImage;
  final DateTime publishedAt;
  final String content;

  ArticleEntity(
      String status,
      int totalResults,
      this.source,
      this.author,
      this.title,
      this.description,
      this.url,
      this.urlToImage,
      this.publishedAt,
      this.content)
      : super(status, totalResults);

  factory ArticleEntity.fromJson(Map<String, dynamic> json) =>
      _$ArticleEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ArticleEntityToJson(this);
}
