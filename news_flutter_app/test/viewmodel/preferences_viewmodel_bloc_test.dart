import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Preferences View Model Bloc Test', () {

    blocTest('Emits [LoadingTopHeadlinesState(), when initial fetch Top Headlines Articles]',
        build: build,
    );
  });
}
