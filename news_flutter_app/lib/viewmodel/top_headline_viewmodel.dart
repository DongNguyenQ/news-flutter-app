import 'package:bloc/bloc.dart';
import 'package:news_flutter_app/core/bloc.dart';
import 'package:news_flutter_app/core/network/failure.dart';
import 'package:news_flutter_app/model/article_entity.dart';
import 'package:news_flutter_app/repository/news_repository.dart';
import 'package:news_flutter_app/repository/news_service.dart';
import 'package:rxdart/rxdart.dart';


class TopHeadlinesState extends BlocState {
  final StateStatus state;
  TopHeadlinesState(this.state);
}

class NotFoundTopHeadlinesState extends TopHeadlinesState {
  NotFoundTopHeadlinesState() : super(StateStatus.notFound);
}

class FoundTopHeadlinesListState extends TopHeadlinesState {
  final List<ArticleEntity>? articles;
  final bool? hasReachedMax;
  final int? pageSize;
  final String? errorLoadMore;
  FoundTopHeadlinesListState({
    this.articles,
    this.hasReachedMax = false,
    this.pageSize = 10,
    this.errorLoadMore}) : super(StateStatus.haveData);

  FoundTopHeadlinesListState copyWith({
    List<ArticleEntity>? articles,
    bool? hasReachedMax,
    int? pageSize,
    String? errorLoadMore
  }) {
    return FoundTopHeadlinesListState(
      articles: articles ?? this.articles,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      pageSize: pageSize ?? this.pageSize,
      errorLoadMore: errorLoadMore ?? this.errorLoadMore
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [articles, hasReachedMax, pageSize, errorLoadMore];
}

class LoadingTopHeadlinesState extends TopHeadlinesState {
  LoadingTopHeadlinesState() : super(StateStatus.loading);
}

class InitialHeadlineState extends TopHeadlinesState {
  InitialHeadlineState() : super(StateStatus.init);
}

class ErrorTopHeadlinesState extends TopHeadlinesState {
  final String error;
  ErrorTopHeadlinesState(this.error) : super(StateStatus.error);

  @override
  List<Object?> get props => [
    error
  ];
}

class TopHeadlinesBloc extends Bloc<Event, TopHeadlinesState> {
  final NewsRepository _repository;
  TopHeadlinesBloc(this._repository) : super(InitialHeadlineState());

  void fetchInitial() {
    this.add(FetchTopHeadlinesArticle());
  }

  void loadMore({bool? isRefresh}) {
    this.add(FetchLoadMoreArticle(isRefresh: isRefresh));
  }

  @override
  Stream<Transition<Event, TopHeadlinesState>> transformEvents
      (Stream<Event> events,
      TransitionFunction<Event, TopHeadlinesState> transitionFn) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<TopHeadlinesState> mapEventToState(Event event) async* {
    if (event is FetchTopHeadlinesArticle) {
      yield* _mapFetchTopHeadlinesToState();
    } else if (event is FetchLoadMoreArticle) {
      yield* _mapFetchLoadMoreToState(state, isRefresh: event.isRefresh);
    }
  }

  Stream<TopHeadlinesState> _mapFetchTopHeadlinesToState() async* {
    yield LoadingTopHeadlinesState();
    final response = await _repository.fetchTopHeadlinesArticles(page: 1, pageSize: 10);
    yield response.fold(
          (failure) => ErrorTopHeadlinesState((failure as UnCategorizeFailure).message),
          (result) {
            if (result != null && result.length > 0) {
              return FoundTopHeadlinesListState(articles: result, hasReachedMax: false, errorLoadMore: null);
            }
            return NotFoundTopHeadlinesState();
          });
  }

  Stream<TopHeadlinesState> _mapFetchLoadMoreToState(
      TopHeadlinesState state, {bool? isRefresh}) async* {
    if (state is FoundTopHeadlinesListState) {
      List<ArticleEntity> currentArticles = state.articles!;
      final response = await _repository.fetchTopHeadlinesArticles(
        page: isRefresh!= null && isRefresh
            ? 1
            : (currentArticles.length / state.pageSize!).ceil(),
        pageSize: state.pageSize,
      );
      yield response.fold(
          (failure) => state.copyWith(errorLoadMore: (failure as UnCategorizeFailure).message),
          (result) {
            if (result != null && result.length > 0) {
              return state.copyWith(
                  articles: List.of(currentArticles)..addAll(result),
                  hasReachedMax: false,
                  errorLoadMore: null
              );
            }
            return state.copyWith(
                  hasReachedMax: true,
                  errorLoadMore: null);
          });
    }
  }

  // Stream<TopHeadlinesState> _mapFetchLoadMoreToState(
  //         TopHeadlinesState state, {bool? isRefresh}) async* {
  //   if (state is FoundTopHeadlinesListState) {
  //     try {
  //       List<ArticleEntity> currentArticles = state.articles!;
  //       final response = await _service.fetchTopHeadlines(
  //         page: isRefresh!= null && isRefresh
  //             ? 1
  //             : (currentArticles.length / state.pageSize!).ceil(),
  //         pageSize: state.pageSize,
  //       );
  //       if (response != null && response.status == "ok") {
  //         if (response.articles != null && response.articles!.length > 0) {
  //           yield state.copyWith(
  //               articles: List.of(currentArticles)..addAll(response.articles!),
  //               hasReachedMax: false,
  //               errorLoadMore: null
  //           );
  //         } else {
  //           yield state.copyWith(
  //               hasReachedMax: true,
  //               errorLoadMore: null
  //           );
  //         }
  //       } else{
  //         yield state.copyWith(
  //             errorLoadMore: response.status
  //         );
  //       }
  //     } catch (e) {
  //       yield state.copyWith(
  //           errorLoadMore: e.toString()
  //       );
  //     }
  //   }
  // }
}

class FetchTopHeadlinesArticle extends Event {
  FetchTopHeadlinesArticle();
}

class FetchLoadMoreArticle extends Event {
  final bool? isRefresh;
  FetchLoadMoreArticle({this.isRefresh});
}