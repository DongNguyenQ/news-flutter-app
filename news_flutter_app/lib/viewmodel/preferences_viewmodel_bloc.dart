import 'package:bloc/bloc.dart';
import 'package:news_flutter_app/core/bloc.dart';
import 'package:news_flutter_app/model/article_entity.dart';
import 'package:news_flutter_app/repository/news_service.dart';

enum PreferencesStateStatus { haveData, notFound, error, loading, init }

class PreferencesState extends BlocState {
  final PreferencesStateStatus state;
  PreferencesState(this.state);
}

class NotFoundPreferencesState extends PreferencesState {
  NotFoundPreferencesState() : super(PreferencesStateStatus.notFound);
}

class FoundPreferencesListState extends PreferencesState {
  final List<ArticleEntity>? articles;
  FoundPreferencesListState(this.articles) : super(PreferencesStateStatus.haveData);
}

class LoadingPreferenceState extends PreferencesState {
  LoadingPreferenceState() : super(PreferencesStateStatus.loading);
}

class InitialPreferenceState extends PreferencesState {
  InitialPreferenceState() : super(PreferencesStateStatus.init);
}

class ErrorPreferenceState extends PreferencesState {
  final String error;
  ErrorPreferenceState(this.error) : super(PreferencesStateStatus.error);
}

class PreferencesBloc extends Bloc<Event, PreferencesState> {
  final NewsService _service;
  PreferencesBloc(this._service) : super(InitialPreferenceState());

  @override
  Stream<PreferencesState> mapEventToState(Event event) async* {
    if (event is FetchPreferencesArticle) {
      yield* _mapFetchListArticlesToState(keyword: event.keyword);
    }
  }

  Stream<PreferencesState> _mapFetchListArticlesToState({String? keyword}) async* {
    yield LoadingPreferenceState();
    try {
      if (state is FoundPreferencesListState) {

      }
      final response = await _service.fetchArticles(keyword: keyword, page: 1, pageSize: 10);
      print('RESPONSE : $response');
      if (response != null && response.status == "ok") {
        if (response.articles != null && response.articles!.length > 0) {
          yield FoundPreferencesListState(response.articles);
        } else {
          yield NotFoundPreferencesState();
        }
      } else{
        yield ErrorPreferenceState('Some thing wrong happened');
      }
    } catch (e) {
      yield ErrorPreferenceState(e.toString());
    }
  }
}

class FetchPreferencesArticle extends Event {
  final String? keyword;
  FetchPreferencesArticle({this.keyword});
}

class FetchLoadMoreArticle extends Event {
}