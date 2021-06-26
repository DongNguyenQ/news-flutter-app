// import 'package:bloc/bloc.dart';
// import 'package:news_flutter_app/core/bloc.dart';
// import 'package:news_flutter_app/model/article_entity.dart';
// import 'package:news_flutter_app/repository/news_service.dart';
//
// enum PreferencesStateStatus { haveData, notFound, error, loading, init }
//
// class PreferencesState extends BlocState {
//   final PreferencesStateStatus state;
//   PreferencesState(this.state);
// }
//
// class NotFoundPreferencesState extends PreferencesState {
//   NotFoundPreferencesState() : super(PreferencesStateStatus.notFound);
// }
//
// class FoundPreferencesListState extends PreferencesState {
//   final List<ArticleEntity>? articles;
//   final bool? hasReachedMax;
//   final int? page;
//   final int? pageSize;
//
//   FoundPreferencesListState copyWith({
//     List<ArticleEntity>? articles, bool? hasReachedMax,
//     int? page, int? pageSize}) {
//     return FoundPreferencesListState(
//         articles: articles ?? this.articles,
//         hasReachedMax: hasReachedMax ?? this.hasReachedMax,
//         page: page ?? this.page,
//         pageSize: pageSize ?? this.pageSize
//     );
//   }
//
//   FoundPreferencesListState({
//     this.articles, this.hasReachedMax, this.page = 1, this.pageSize = 20})
//       : super(PreferencesStateStatus.haveData);
//   @override
//   List<Object?> get props => [articles, hasReachedMax, page, pageSize];
// }
//
// class LoadingPreferenceState extends PreferencesState {
//   LoadingPreferenceState() : super(PreferencesStateStatus.loading);
// }
//
// class InitialPreferenceState extends PreferencesState {
//   InitialPreferenceState() : super(PreferencesStateStatus.init);
// }
//
// class ErrorPreferenceState extends PreferencesState {
//   final String error;
//   ErrorPreferenceState(this.error) : super(PreferencesStateStatus.error);
// }
//
// class PreferencesBloc extends Bloc<Event, PreferencesState> {
//   final NewsService _service;
//   PreferencesBloc(this._service) : super(InitialPreferenceState());
//
//   @override
//   Stream<PreferencesState> mapEventToState(Event event) async* {
//     if (event is FetchPreferencesArticle) {
//       yield* _mapFetchListArticlesToState(keyword: event.keyword);
//     } else if (event is FetchLoadMoreArticle) {
//       yield* _mapLoadMoreListArticlesToState();
//     }
//   }
//
//   Stream<PreferencesState> _mapLoadMoreListArticlesToState({String? keyword}) async* {
//     try {
//       if (state is FoundPreferencesListState) {
//         var currentPage = state.props;
//         print('PROPS : $currentPage');
//         // final response = await _service.fetchArticles(
//         //     keyword: keyword, page: state.page + 1, pageSize: 10);
//       }
//     } catch (e) {
//
//     }
//   }
//
//   Stream<PreferencesState> _mapFetchListArticlesToState({String? keyword}) async* {
//     yield LoadingPreferenceState();
//     try {
//       final response = await _service.fetchArticles(keyword: keyword, page: 1, pageSize: 10);
//       if (response != null && response.status == "ok") {
//         if (response.articles != null && response.articles!.length > 0) {
//           yield FoundPreferencesListState(
//               articles: response.articles,
//               hasReachedMax: false,
//           );
//         } else {
//           yield NotFoundPreferencesState();
//         }
//       } else{
//         yield ErrorPreferenceState('Some thing wrong happened');
//       }
//     } catch (e) {
//       yield ErrorPreferenceState(e.toString());
//     }
//   }
// }
//
// class FetchPreferencesArticle extends Event {
//   final String? keyword;
//   FetchPreferencesArticle({this.keyword});
// }
//
// class FetchLoadMoreArticle extends Event {
// }