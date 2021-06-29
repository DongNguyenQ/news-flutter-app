
import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_flutter_app/core/bloc.dart';
import 'package:news_flutter_app/model/article_entity.dart';
import 'package:news_flutter_app/model/response/fetch_list_article_response.dart';
import 'package:news_flutter_app/model/source_entity.dart';
import 'package:news_flutter_app/repository/news_repository.dart';
import 'package:news_flutter_app/repository/news_service.dart';
import 'package:news_flutter_app/viewmodel/top_headline_viewmodel.dart';

class MockNewsService extends Mock implements NewsService {}
class MockNewsRepository extends Mock implements NewsRepository {}
class MockTopHeadlinesBloc extends MockBloc<Event, TopHeadlinesState> implements TopHeadlinesBloc {}
// class MockTopBloc extends MockBloc<Event, TopHeadlinesState> implements TopHeadlinesBloc {}
// class FakeTopHeadlinesEvent extends Fake implements Event {}
// class FakeTopHeadlinesState extends Fake implements TopHeadlinesState {}

void main() {

  late MockNewsRepository repository;
  late TopHeadlinesBloc bloc;
  late MockNewsService service;
  setUp(() {
    service = new MockNewsService();
    repository = new MockNewsRepository();
    bloc = new TopHeadlinesBloc(service, repository);
  });

  group('Top headline viewmodel bloc test', () {

    final expectedResponse = FetchListArticleResponse(
      "ok",
      192,
        [
          ArticleEntity(SourceEntity('123', 'NBC'), 'Dong Nguyen', 'How bitcoin work',
              'Bitcoint work base on Blockchain', 'bbc.vn', 'bbc.vn', '23/09/2123',
              'Bitcoint work base on Blockchain'),
          ArticleEntity(SourceEntity('123456', 'NBC123456'), 'Dong Nguyen 123456',
              'How bitcoin work 123456', 'Bitcoint work base on Blockchain 123456',
              'bbc.vn 123456', 'bbc.vn 123456', '23/09/2123 123456',
              'Bitcoint work base on Blockchain 123456'),
        ]
    );

    blocTest('Bloc test 1',
        build: () {
          when(() => service.fetchTopHeadlines(page: 1, pageSize: 10)).thenAnswer(
                  (_) async => expectedResponse);
          return bloc;
        },
        act: (bloc) => (bloc as TopHeadlinesBloc).add(FetchTopHeadlinesArticle()),
        expect: () => [
          // LoadingTopHeadlinesState(),
          // FoundTopHeadlinesListState(articles: expectedResponse.articles)
        ]
    );

    // blocTest('Mock Bloc test 1',
    //     build: () {
    //       when(() => service.fetchTopHeadlines(page: 1, pageSize: 10)).thenAnswer(
    //               (_) async => expectedResponse);
    //       return MockTopBloc();
    //     },
    //     act: (bloc) => (bloc as MockTopBloc).add(FetchTopHeadlinesArticle()),
    //     expect: () => [
    //       // LoadingTopHeadlinesState(),
    //       // FoundTopHeadlinesListState(articles: expectedResponse.articles)
    //     ]
    // );
  });
}