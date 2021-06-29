
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

import 'top_headline_viewmodel_bloc_test.dart';

class MockTopBloc extends MockBloc<Event, TopHeadlinesState>
    implements TopHeadlinesBloc {}
class FakeTopHeadlinesEvent extends Fake implements Event {}
class FakeTopHeadlinesState extends Fake implements TopHeadlinesState {}

void main() {

  setUpAll(() {
    registerFallbackValue<FetchTopHeadlinesArticle>(FetchTopHeadlinesArticle());
    registerFallbackValue<TopHeadlinesState>(FakeTopHeadlinesState());
    // registerFallbackValue<Event>(FakeTopHeadlinesEvent());
  });

  group('CounterBloc', () {
    final service = NewsService();
    final repo = NewsRepositoryImpl(service);
    blocTest<MockTopBloc, TopHeadlinesState>(
      'emits [] when nothing is added',
      build: () => MockTopBloc(),
      act: (bloc) => bloc.add(FetchTopHeadlinesArticle()),
      expect: () => [
        LoadingTopHeadlinesState()
      ],
    );

    // blocTest<CounterBloc, int>(
    //   'emits [1] when CounterEvent.increment is added',
    //   build: () => CounterBloc(),
    //   act: (bloc) => bloc.add(CounterEvent.increment),
    //   expect: () => const <int>[1],
    // );
  });

  // group('Top headline viewmodel bloc test', () {
  //
  //   test("Let's mock the CounterBloc's stream!", () {
  //     final bloc = MockTopBloc();
  //     whenListen(bloc, Stream.fromIterable([LoadingTopHeadlinesState]));
  //     expectLater(bloc.stream, emitsInOrder([
  //       LoadingTopHeadlinesState
  //     ]));
  //   });
  //
  //   // blocTest('Mock Bloc test 1',
  //   //     build: () => TopHeadlinesBloc(service, repository),
  //   //     act: (bloc) => (bloc as TopHeadlinesBloc)..add(FetchTopHeadlinesArticle()),
  //   //     expect: () => [
  //   //       isA<LoadingTopHeadlinesState>(),
  //   //       // FoundTopHeadlinesListState(articles: expectedResponse.articles)
  //   //     ]
  //   // );
  // });
}