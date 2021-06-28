// import 'package:bloc_test/bloc_test.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:news_flutter_app/model/article_entity.dart';
// import 'package:news_flutter_app/model/source_entity.dart';
// import 'package:news_flutter_app/repository/news_service.dart';
// import 'package:news_flutter_app/viewmodel/preferences_viewmodel_bloc_loadmore.dart';
// import 'package:news_flutter_app/viewmodel/top_headline_viewmodel_bloc.dart';
//
// class MockNewsService extends Mock implements NewsService {}
//
// void main() {
//   late NewsService service;
//   setUp(() {
//     service = new NewsService();
//   });
//
//   group('Preferences View Model Bloc Test', () {
//
//     final expectedListArticles = [
//       ArticleEntity(SourceEntity('123', 'NBC'), 'Dong Nguyen', 'How bitcoin work',
//           'Bitcoint work base on Blockchain', 'bbc.vn', 'bbc.vn', '23/09/2123',
//           'Bitcoint work base on Blockchain'),
//       ArticleEntity(SourceEntity('123456', 'NBC123456'), 'Dong Nguyen 123456',
//           'How bitcoin work 123456', 'Bitcoint work base on Blockchain 123456',
//           'bbc.vn 123456', 'bbc.vn 123456', '23/09/2123 123456',
//           'Bitcoint work base on Blockchain 123456'),
//     ];
//
//     blocTest('Fetch Preferences successfully - '
//         'Emits [LoadingTopHeadlinesState(), FoundTopHeadlinesListState()]',
//         build: () {
//           when(mockNewsRepository.fetchPreferencesArticles()).thenAnswer((_) async => expectedListArticles);
//           return PreferencesArticlesBloc(new NewsService(), mockNewsRepository);
//         },
//         act: (bloc) => (bloc as PreferencesArticlesBloc).add(FetchInitialArticle('abc')),
//         expect: () => [
//           LoadingTopHeadlinesState(),
//           FoundTopHeadlinesListState(
//               articles: expectedListArticles,
//               pageSize: 20,
//               errorLoadMore: null,
//               hasReachedMax: false),
//         ]
//     );
//   });
// }
