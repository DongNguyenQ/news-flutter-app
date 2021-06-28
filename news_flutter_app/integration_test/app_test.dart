import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:news_flutter_app/main.dart';
import 'package:news_flutter_app/view/screens/preferences_screen.dart';
import 'package:news_flutter_app/view/screens/profile_screen.dart';
import 'package:news_flutter_app/view/screens/top_headline_screen.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Passed
  testWidgets(
      'Test when start, top headline page show',
      (WidgetTester tester) async {
        await tester.pumpWidget(MyApp());
        
        expect(find.byType(TopHeadlineScreen), findsOneWidget);
        expect(find.byType(PreferencesScreen), findsNothing);
        expect(find.byType(ProfileScreen), findsNothing);
      },
  );

  testWidgets(
    'Test if user scroll down to reach 10 articles, '
    'a loading indicator will show to inform that app are performing load more',
    (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(MyApp());

        final listFinder = find.byKey(Key('listViewTopHeadlines'));

        sleep(Duration(seconds: 30));
        await tester.ensureVisible(find.byKey(Key('article-1')));
        await tester.scrollUntilVisible(listFinder, 1000.0);
        tester.pumpAndSettle();

        expect(find.byKey(Key('loadMoreLoading')), findsOneWidget);

      });
    },
  );
}