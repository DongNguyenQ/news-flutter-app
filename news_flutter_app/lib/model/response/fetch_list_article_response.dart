import 'package:json_annotation/json_annotation.dart';
import 'package:news_flutter_app/model/article_entity.dart';

part 'fetch_list_article_response.g.dart';

@JsonSerializable(explicitToJson: true)
class FetchListArticleResponse {
  final String? status;
  final int? totalResults;
  final List<ArticleEntity>? articles;
  FetchListArticleResponse(this.status, this.totalResults, this.articles);

  factory FetchListArticleResponse.fromJson(Map<String, dynamic> json) =>
      _$FetchListArticleResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FetchListArticleResponseToJson(this);
}
