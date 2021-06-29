import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:news_flutter_app/core/bloc.dart';
import 'package:news_flutter_app/core/network/failure.dart';
import 'package:news_flutter_app/model/article_entity.dart';
import 'package:news_flutter_app/repository/news_repository.dart';
import 'package:news_flutter_app/repository/news_service.dart';
import 'package:rxdart/rxdart.dart';

// EVENT

abstract class PreferencesArticlesEvent extends Event {}

class FetchInitialArticle extends PreferencesArticlesEvent {
  final String keyword;
  FetchInitialArticle(this.keyword);

  @override
  List<Object?> get props => [keyword];
}

class FetchMoreArticle extends PreferencesArticlesEvent {}

// STATE

enum PreferencesStatus {initial, success, failure, loading}

class PreferencesArticlesState extends BlocState {
  final PreferencesStatus status;
  final List<ArticleEntity> articles;
  final bool hasReachedMax;
  final int pageSize;
  final String currentSelectedKeyword;
  final String? errorMessage;

  PreferencesArticlesState({
    this.status = PreferencesStatus.initial,
    this.articles = const <ArticleEntity>[],
    this.hasReachedMax = false,
    this.pageSize = 20,
    this.currentSelectedKeyword = '',
    this.errorMessage
  });

  PreferencesArticlesState copyWith({
    PreferencesStatus? status,
    List<ArticleEntity>? articles,
    bool? hasReachedMax,
    int? pageSize,
    String? currentSelectedKeyword,
    String? errorMessage
  }) {
    return PreferencesArticlesState(
      status: status ?? this.status,
      articles: articles ?? this.articles,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      pageSize: pageSize ?? this.pageSize,
      currentSelectedKeyword: currentSelectedKeyword ?? this.currentSelectedKeyword,
      errorMessage: errorMessage ?? this.errorMessage
    );
  }

  @override
  String toString() {
    return '''PreferencesState { 
          status: $status, 
          hasReachedMax: $hasReachedMax, 
          articles: ${articles.length},
          currentSelectedKeyword: $currentSelectedKeyword,
          errorMessage: $errorMessage
       ''';
  }

  @override
  List<Object?> get props => [
    status,
    articles,
    hasReachedMax,
    pageSize,
    currentSelectedKeyword,
    errorMessage
  ];
}

// BLOC
class PreferencesArticlesBloc extends Bloc<PreferencesArticlesEvent, PreferencesArticlesState> {
  final NewsRepository _repository;
  PreferencesArticlesBloc(this._repository) : super(PreferencesArticlesState());

  @override
  Stream<Transition<PreferencesArticlesEvent, PreferencesArticlesState>> transformEvents
      (Stream<PreferencesArticlesEvent> events,
      TransitionFunction<PreferencesArticlesEvent,
      PreferencesArticlesState> transitionFn) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 2000)),
      transitionFn,
    );
  }

  @override
  Stream<PreferencesArticlesState> mapEventToState(PreferencesArticlesEvent event) async* {
    if(event is FetchInitialArticle) {
      yield state.copyWith(errorMessage: null, status: PreferencesStatus.loading);
      yield await _mapArtilesInitialFetchedToState(state, event.keyword);
    } else if (event is FetchMoreArticle) {
      yield await _mapArtilesLoadmoreToState(state);
    }
  }

  Future<PreferencesArticlesState> _mapArtilesInitialFetchedToState(
      PreferencesArticlesState state, String keyword) async {
    if (state.hasReachedMax) return state;
    final result = await _repository.fetchPreferencesArticles(
        keyword: keyword, page: 1, pageSize: state.pageSize);
    return result.fold(
            (failure) => state.copyWith(
                status: PreferencesStatus.failure,
                errorMessage: (failure as UnCategorizeFailure).message),
            (result) => state.copyWith(
                status: PreferencesStatus.success,
                articles: result, hasReachedMax: false,
                currentSelectedKeyword: keyword));
  }

  Future<PreferencesArticlesState> _mapArtilesLoadmoreToState(PreferencesArticlesState state) async {
    if (state.hasReachedMax) return state;
    final result = await _repository.fetchPreferencesArticles(
                keyword: state.currentSelectedKeyword,
                page: (state.articles.length / state.pageSize).ceil() + 1,
                pageSize: state.pageSize);
    return result.fold(
            (failure) => state.copyWith(
                status: PreferencesStatus.failure,
                errorMessage: (failure as UnCategorizeFailure).message),
            (result) {
              if (result!.isEmpty)
                return state.copyWith(hasReachedMax: true);
              return state.copyWith(
                status: PreferencesStatus.success,
                articles: List.of(state.articles)..addAll(result),
                hasReachedMax: false
              );
            });
  }

}