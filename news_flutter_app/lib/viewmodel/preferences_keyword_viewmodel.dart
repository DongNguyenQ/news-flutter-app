
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_flutter_app/core/bloc.dart';
import 'package:news_flutter_app/model/keyword_entity.dart';

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
  PreferencesKeywordBloc() : super(InitialPreferenceKeywordState());

  @override
  Stream<PreferencesKeywordState> mapEventToState(Event event) async* {
    if (event is FetchPreferencesKeywords) {
      yield* _mapFetchListKeywordsToState();
    }
  }

  Stream<PreferencesKeywordState> _mapFetchListKeywordsToState() async* {
    yield LoadingPreferenceKeywordState();
    try {
      List<KeyWordEntity>? keywords = getKeywords();
      if (keywords != null && keywords.length > 0) {
        yield FoundPreferencesKeywordListState(keywords);
      } else {
        yield NotFoundPreferencesKeywordState();
      }
    } catch (e) {
      yield ErrorPreferenceKeywordState(e.toString());
    }
  }

  List<KeyWordEntity> getKeywords() {
    return [
      new KeyWordEntity('bitcoin', 'bitcoin'),
      new KeyWordEntity('apple', 'apple'),
      new KeyWordEntity('earthquake', 'earthquake'),
      new KeyWordEntity('animal', 'animal'),
    ];
  }
}

class FetchPreferencesKeywords extends Event {}