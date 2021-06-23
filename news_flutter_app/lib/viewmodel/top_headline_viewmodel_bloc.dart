import 'package:bloc/bloc.dart';
import 'package:news_flutter_app/core/bloc.dart';
import 'package:news_flutter_app/model/article_entity.dart';
import 'package:news_flutter_app/repository/news_service.dart';


class TopHeadlinesState extends BlocState {
  final PreferencesStateStatus state;
  TopHeadlinesState(this.state);
}

class NotFoundTopHeadlinesState extends TopHeadlinesState {
  NotFoundTopHeadlinesState() : super(PreferencesStateStatus.notFound);
}

class FoundTopHeadlinesListState extends TopHeadlinesState {
  final List<ArticleEntity>? articles;
  FoundTopHeadlinesListState(this.articles) : super(PreferencesStateStatus.haveData);
}

class LoadingTopHeadlinesState extends TopHeadlinesState {
  LoadingTopHeadlinesState() : super(PreferencesStateStatus.loading);
}

class InitialPreferenceState extends TopHeadlinesState {
  InitialPreferenceState() : super(PreferencesStateStatus.init);
}

class ErrorTopHeadlinesState extends TopHeadlinesState {
  final String error;
  ErrorTopHeadlinesState(this.error) : super(PreferencesStateStatus.error);
}

class TopHeadlinesBloc extends Bloc<Event, TopHeadlinesState> {
  final NewsService _service;
  TopHeadlinesBloc(this._service) : super(InitialPreferenceState());

  @override
  Stream<TopHeadlinesState> mapEventToState(Event event) async* {
    if (event is FetchTopHeadlinesArticle) {
      yield* _mapFetchTopHeadlinesToState();
    }
  }

  Stream<TopHeadlinesState> _mapFetchTopHeadlinesToState() async* {
    yield LoadingTopHeadlinesState();
    try {
      final response = await _service.fetchTopHeadlines(page: 1, pageSize: 10);
      if (response != null && response.status == "ok") {
        if (response.articles != null && response.articles!.length > 0) {
          yield FoundTopHeadlinesListState(response.articles);
        } else {
          yield NotFoundTopHeadlinesState();
        }
      } else{
        yield ErrorTopHeadlinesState('Some thing wrong happened');
      }
    } catch (e) {
      yield ErrorTopHeadlinesState(e.toString());
    }
  }
}

class FetchTopHeadlinesArticle extends Event {
  FetchTopHeadlinesArticle();
}