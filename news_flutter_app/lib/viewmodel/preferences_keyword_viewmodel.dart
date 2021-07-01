
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_flutter_app/core/bloc.dart';
import 'package:news_flutter_app/model/keyword_entity.dart';
import 'package:news_flutter_app/repository/news_repository.dart';

enum PreferencesKeywordStateStatus { haveData, notFound, error, loading, init }

class PreferencesKeywordState extends BlocState {
  final PreferencesKeywordStateStatus state;
  PreferencesKeywordState(this.state);
}

class NotFoundPreferencesKeywordState extends PreferencesKeywordState {
  NotFoundPreferencesKeywordState() : super(PreferencesKeywordStateStatus.notFound);
}

class FoundPreferencesKeywordListState extends PreferencesKeywordState {
  final List<KeyWordEntity>? keywords;

  List<KeyWordEntity>? get getKeywords => keywords;

  List<String>? get getKeywordsLabel => keywords != null && keywords!.length > 0 ?
        keywords!.map((key) => key.title).toList() : [];

  List<String>? get getKeywordsValue => keywords != null && keywords!.length > 0 ?
        keywords!.map((key) => key.value).toList() : [];

  FoundPreferencesKeywordListState(this.keywords) : super(PreferencesKeywordStateStatus.haveData);
}

class LoadingPreferenceKeywordState extends PreferencesKeywordState {
  LoadingPreferenceKeywordState() : super(PreferencesKeywordStateStatus.loading);
}

class InitialPreferenceKeywordState extends PreferencesKeywordState {
  InitialPreferenceKeywordState() : super(PreferencesKeywordStateStatus.init);
}

class ErrorPreferenceKeywordState extends PreferencesKeywordState {
  final String error;
  ErrorPreferenceKeywordState(this.error) : super(PreferencesKeywordStateStatus.error);
}

class PreferencesKeywordBloc extends Bloc<Event, PreferencesKeywordState> {
  final NewsRepository _repository;
  PreferencesKeywordBloc(this._repository) : super(InitialPreferenceKeywordState());

  @override
  Stream<PreferencesKeywordState> mapEventToState(Event event) async* {
    if (event is FetchPreferencesKeywords) {
      yield* _mapFetchListKeywordsToState();
    }
  }

  Stream<PreferencesKeywordState> _mapFetchListKeywordsToState() async* {
    yield LoadingPreferenceKeywordState();
    final keywords = await _repository.fetchPreferencesKeywords();
    yield keywords.fold(
            (failure) => ErrorPreferenceKeywordState('Something wrong'),
            (result) => FoundPreferencesKeywordListState(result));
  }

}

class FetchPreferencesKeywords extends Event {}