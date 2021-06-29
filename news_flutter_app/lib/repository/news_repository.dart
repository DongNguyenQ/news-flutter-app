import 'package:dartz/dartz.dart';
import 'package:news_flutter_app/core/network/failure.dart';
import 'package:news_flutter_app/model/article_entity.dart';
import 'package:news_flutter_app/model/keyword_entity.dart';
import 'package:news_flutter_app/repository/news_service.dart';

abstract class NewsRepository {

  Future<Either<Failure, List<ArticleEntity>?>> fetchPreferencesArticles({String? keyword, int? page, int? pageSize});
  Future<Either<Failure, List<ArticleEntity>?>> fetchTopHeadlinesArticles({int? page, int? pageSize});
  Future<Either<Failure, List<KeyWordEntity>?>> fetchPreferencesKeywords();
}

class NewsRepositoryImpl extends NewsRepository {

  final NewsService _service;

  NewsRepositoryImpl(this._service);

  @override
  Future<Either<Failure, List<ArticleEntity>?>> fetchPreferencesArticles(
          {String? keyword, int? page, int? pageSize}) async {
    try {
      final response = await _service.fetchArticles(
          keyword: keyword, pageSize: pageSize, page: page);
      if (response.status == "ok") {
        return Right(response.articles);
      }
      return Left(UnCategorizeFailure('${response.status} - Something wrong happened'));
    } catch (e) {
      return Left(UnCategorizeFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ArticleEntity>?>> fetchTopHeadlinesArticles(
          {int? page, int? pageSize}) async {
    try {
      final response = await _service.fetchTopHeadlines(page: page, pageSize: pageSize);
      if (response.status == "ok") {
        return Right(response.articles);
      }
      return Left(UnCategorizeFailure('${response.status} - Something wrong happened'));
    } catch (e) {
      return Left(UnCategorizeFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<KeyWordEntity>?>> fetchPreferencesKeywords() {
    // TODO: implement fetchPreferencesKeywords
    throw UnimplementedError();
  }

}