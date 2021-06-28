import 'package:news_flutter_app/model/article_entity.dart';
import 'package:news_flutter_app/model/response/fetch_list_article_response.dart';
import 'package:news_flutter_app/repository/news_service.dart';

abstract class NewsRepository {

  final NewsService _service;

  NewsRepository(this._service);

  Future<List<ArticleEntity>?> fetchPreferencesArticles({String? keyword, int? page, int? pageSize});
  Future<List<ArticleEntity>?> fetchTopHeadlinesArticles({int? page, int? pageSize});
}

class NewsRepositoryImpl extends NewsRepository {

  NewsRepositoryImpl(NewsService service) : super(service);

  @override
  Future<List<ArticleEntity>?> fetchPreferencesArticles(
          {String? keyword, int? page, int? pageSize}) async {
    final response = await _service.fetchArticles(
            keyword: keyword, pageSize: pageSize, page: page);
    if (response.status == "ok") {
      return response.articles;
    }
    return null;
  }

  @override
  Future<List<ArticleEntity>?> fetchTopHeadlinesArticles(
          {int? page, int? pageSize}) async {
    final response = await _service.fetchTopHeadlines(page: page, pageSize: pageSize);
    if (response.status == "ok") {
      return response.articles;
    }
    return null;
  }

}