
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_flutter_app/model/article_entity.dart';
import 'package:news_flutter_app/model/source_entity.dart';
import 'package:news_flutter_app/viewmodel/preferences_viewmodel.dart';


class MockPreferBloc extends
   MockBloc<PreferencesArticlesEvent, PreferencesArticlesState> implements PreferencesArticlesBloc {}


void main() {

 setUpAll(() {
  registerFallbackValue<PreferencesArticlesEvent>(FetchInitialArticle('bitcoin'));
  registerFallbackValue<PreferencesArticlesState>(PreferencesArticlesState());
 });

 final bloc = MockPreferBloc();

 final listArticles = [
    ArticleEntity(SourceEntity('123', 'NBC'), 'Dong Nguyen', 'How bitcoin work',
        'Bitcoint work base on Blockchain', 'bbc.vn', 'bbc.vn', '23/09/2123',
        'Bitcoint work base on Blockchain'),
    ArticleEntity(SourceEntity('123456', 'NBC123456'), 'Dong Nguyen 123456',
        'How bitcoin work 123456', 'Bitcoint work base on Blockchain 123456',
        'bbc.vn 123456', 'bbc.vn 123456', '23/09/2123 123456',
        'Bitcoint work base on Blockchain 123456'),
  ];
 final initState = PreferencesArticlesState(
   hasReachedMax: false,
   articles: listArticles,
   status: PreferencesStatus.initial,
   errorMessage: null,
   currentSelectedKeyword: 'bitcoin',
   pageSize: 20
 );

 group('CounterBloc', () {
  blocTest<MockPreferBloc, PreferencesArticlesState>(
   'emits [] when nothing is added',
   build: () => MockPreferBloc(),
   act: (bloc) => bloc.add(FetchInitialArticle('bitcoin')),
   expect: () => <PreferencesArticlesState>[],
  );

 });
}