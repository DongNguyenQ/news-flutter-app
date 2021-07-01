import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:news_flutter_app/core/network/failure.dart';
import 'package:news_flutter_app/model/article_entity.dart';
import 'package:news_flutter_app/model/response/fetch_list_article_response.dart';
import 'package:news_flutter_app/model/source_entity.dart';
import 'package:news_flutter_app/repository/news_repository.dart';
import 'package:news_flutter_app/repository/news_service.dart';
import 'package:news_flutter_app/viewmodel/top_headline_viewmodel.dart';

import 'top_headline_viewmodel_bloc_mock_mokito_test.mocks.dart';

final listArticles = [
  ArticleEntity(SourceEntity('123', 'NBC'), 'Dong Nguyen', 'How bitcoin work',
      'Bitcoint work base on Blockchain', 'bbc.vn', 'bbc.vn', '23/09/2123',
      'Bitcoint work base on Blockchain'),
  ArticleEntity(SourceEntity('123456', 'NBC123456'), 'Dong Nguyen 123456',
      'How bitcoin work 123456', 'Bitcoint work base on Blockchain 123456',
      'bbc.vn 123456', 'bbc.vn 123456', '23/09/2123 123456',
      'Bitcoint work base on Blockchain 123456'),
];

@GenerateMocks([],
    customMocks: [
      MockSpec<NewsRepository>(as: #MockNewsRepository, returnNullOnMissingStub: true),
      MockSpec<NewsService>(as: #MockNewsService, returnNullOnMissingStub: true)
    ]
)
void main() {
  final expectedResponse = FetchListArticleResponse(
      "ok",
      192,
      listArticles
  );

  final repository = new MockNewsRepository();
  final service = new MockNewsService();

  group('Test Bloc by Mockito', () {

    test('Test bloc mockito - repository', () async {

      when(repository.fetchTopHeadlinesArticles(page: 1, pageSize: 20))
          .thenAnswer((_) async => Right(listArticles));

      expect(await repository.fetchTopHeadlinesArticles(page: 1, pageSize: 20),
          isA<Right<Failure, List<ArticleEntity>?>>());
    });

    test('BLOC OLD WAY', () async {
      when(repository.fetchTopHeadlinesArticles(page: 1, pageSize: 10))
          .thenAnswer((_) async => Right(listArticles));

      final bloc = TopHeadlinesBloc(repository);

      bloc.add(FetchTopHeadlinesArticle());

      await expectLater(
          bloc.stream,
          emitsInOrder([
            LoadingTopHeadlinesState(),
            FoundTopHeadlinesListState(articles: expectedResponse.articles)
          ])
      );
    });
  });

  group('[Mockito] [Bloc Test] Test logic initial fetch articles', () {
    blocTest('[Initial Articles] emits [LoadingTopHeadlinesState, FoundTopHeadlinesListState] when repository return new data',
        build: () => TopHeadlinesBloc(repository),
        act: (bloc) => (bloc as TopHeadlinesBloc).add(FetchTopHeadlinesArticle()),
        // NEED This wait to run, or else will throw error
        wait: const Duration(milliseconds: 500),
        expect: () => [
          LoadingTopHeadlinesState(),
          FoundTopHeadlinesListState(articles: expectedResponse.articles)
        ],
    );

    blocTest(
      '[Initial Articles] emits [LoadingTopHeadlinesState, NotFoundTopHeadlinesState] when repository return empty data',
      build: () {
        when(repository.fetchTopHeadlinesArticles(page: 1, pageSize: 10))
            .thenAnswer((_) async => Right([]));
        return TopHeadlinesBloc(repository);
      },
      act: (bloc) => (bloc as TopHeadlinesBloc).add(FetchTopHeadlinesArticle()),
      // NEED This wait to run, or else will throw error
      wait: const Duration(milliseconds: 500),
      expect: () => [
        LoadingTopHeadlinesState(),
        NotFoundTopHeadlinesState()
      ],
    );

    blocTest(
      '[Initial Articles] emits [LoadingTopHeadlinesState, ErrorTopHeadlinesState] when repository return error',
      build: () {
        when(repository.fetchTopHeadlinesArticles(page: 1, pageSize: 10))
            .thenAnswer((_) async => Left(UnCategorizeFailure('Not Ok - Something wrong happened')));
        return TopHeadlinesBloc(repository);
      },
      act: (bloc) => (bloc as TopHeadlinesBloc).add(FetchTopHeadlinesArticle()),
      // NEED This wait to run, or else will throw error
      wait: const Duration(milliseconds: 500),
      expect: () => [
        LoadingTopHeadlinesState(),
        ErrorTopHeadlinesState('Not Ok - Something wrong happened')
      ],
    );

    blocTest(
      '[Initial Articles] emits [LoadingTopHeadlinesState, ErrorTopHeadlinesState] when repository return error',
      build: () {
        when(repository.fetchTopHeadlinesArticles(page: 1, pageSize: 10))
            .thenAnswer((_) async => Left(UnCategorizeFailure('Not Ok - Something wrong happened')));
        return TopHeadlinesBloc(repository);
      },
      act: (bloc) => (bloc as TopHeadlinesBloc).add(FetchTopHeadlinesArticle()),
      // NEED This wait to run, or else will throw error
      wait: const Duration(milliseconds: 500),
      expect: () => [
        LoadingTopHeadlinesState(),
        ErrorTopHeadlinesState('Not Ok - Something wrong happened')
      ],
    );

    // START - Test initial state of bloc
    // Can't use blocTest to test initial state
    // Ref : https://bloclibrary.dev/#/migration?id=%e2%9d%97bloc-does-not-emit-last-state-on-subscription
    //       Search : 'The initial state of a bloc or cubit can be tested with the following:'
    // Ref : https://github.com/felangel/bloc/issues/1518
    // Not passed
    blocTest<TopHeadlinesBloc, TopHeadlinesState>(
      '[Initial Articles] emits [InitialHeadlineState] when create bloc',
      build: () => TopHeadlinesBloc(repository),
      expect: () => <TopHeadlinesState>[
        InitialHeadlineState(),
      ],
    );

    // Passed
    test('Not bloc test - Test initial state', () {
      final bloc = TopHeadlinesBloc(repository);
      expect(TopHeadlinesBloc(repository).state, InitialHeadlineState());
    });
    // END - Test initial state of bloc

    blocTest(
      '[Initial Articles] emits [LoadingTopHeadlinesState, ErrorTopHeadlinesState] when '
          'service throw error to non-mock repository',
      build: () {
        when(service.fetchTopHeadlines(page: 1, pageSize: 10))
            .thenAnswer((_) async => throw Exception(
            "Unable to perform request! 404 : Error from service"));
        return TopHeadlinesBloc(new NewsRepositoryImpl(service));
      },
      act: (bloc) => (bloc as TopHeadlinesBloc).add(FetchTopHeadlinesArticle()),
      // NEED This wait to run, or else will throw error
      wait: const Duration(milliseconds: 500),
      expect: () => [
        LoadingTopHeadlinesState(),
        ErrorTopHeadlinesState('Exception: Unable to perform request! 404 : Error from service')
      ],
    );
  });
  
  group(['[Mockito] [Bloc Test] Test logic load more fetch articles'], () {

    // Not passed
    blocTest<TopHeadlinesBloc, TopHeadlinesState>(
      '[LoadMore Articles] emits [FoundTopHeadlinesListState]',
      build: () {
        when(repository.fetchTopHeadlinesArticles(page: 2, pageSize: 10))
          .thenAnswer((_) async => Right(listArticles));
        return TopHeadlinesBloc(repository);
      },
      seed: () => FoundTopHeadlinesListState(articles: listArticles),
      // Error Infer : https://github.com/felangel/bloc/issues/2052
      act: (bloc) => bloc.add(FetchLoadMoreArticle()),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        FoundTopHeadlinesListState(articles: listArticles)
      ]
    );

    // test('BLOC OLD WAY', () async {
    //   when(repository.fetchTopHeadlinesArticles(page: 1, pageSize: 10))
    //       .thenAnswer((_) async => Right(listArticles));
    //
    //   final bloc = TopHeadlinesBloc(repository);
    //
    //   bloc.add(FetchTopHeadlinesArticle());
    //   bloc.add(FetchLoadMoreArticle());
    //
    //   await expectLater(
    //       bloc.stream,
    //       emitsInOrder([
    //         LoadingTopHeadlinesState(),
    //         FoundTopHeadlinesListState(articles: expectedResponse.articles),
    //       ])
    //   );
    // });
  });
}