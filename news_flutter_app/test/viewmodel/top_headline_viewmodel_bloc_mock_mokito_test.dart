import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:news_flutter_app/model/article_entity.dart';
import 'package:news_flutter_app/model/response/fetch_list_article_response.dart';
import 'package:news_flutter_app/model/source_entity.dart';
import 'package:news_flutter_app/repository/news_repository.dart';
import 'package:news_flutter_app/repository/news_service.dart';
import 'package:news_flutter_app/viewmodel/top_headline_viewmodel_bloc.dart';

import 'top_headline_viewmodel_bloc_mock_mokito_test.mocks.dart';

@GenerateMocks([NewsService])
void main() {
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

  final service = new MockNewsService();

  group('Test Bloc by Mockito', () {
    test('Test bloc mockito', () async {

      when(service.fetchTopHeadlines(page: 1, pageSize: 20))
          .thenAnswer((_) async => expectedResponse);
      
      expect(await service.fetchTopHeadlines(page: 1, pageSize: 20), isA<FetchListArticleResponse>());
    });
    
    test('BLOC OLD WAY', () async {
      when(service.fetchTopHeadlines(page: 1, pageSize: 10))
          .thenAnswer((_) async => expectedResponse);

      final bloc = TopHeadlinesBloc(service, new NewsRepositoryImpl(service));

      bloc.add(FetchTopHeadlinesArticle());

      await expectLater(
        bloc,
        emitsInOrder([
          LoadingTopHeadlinesState(),
          FoundTopHeadlinesListState(articles: expectedResponse.articles)
        ])
      );
    });
  });

  // group('Test Bloc by Mockito vs bloc test', () {
  //   blocTest('Test Bloc mockito vs bloc test',
  //       build: () async {
  //         when(service.fetchTopHeadlines(page: 1, pageSize: 10)).thenAnswer(
  //               (_) => Future.value(expectedResponse),
  //         );
  //         return TopHeadlinesBloc(service, new NewsRepositoryImpl(service));
  //       },
  //       act: (bloc) => (bloc as TopHeadlinesBloc).add(FetchTopHeadlinesArticle()),
  //       expect: () => <TopHeadlinesState>[
  //         LoadingTopHeadlinesState(),
  //
  //       ],
  //   );
  //
  // });
}