import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mockito/mockito.dart';
import 'package:news_flutter_app/main.dart';
import 'package:news_flutter_app/view/screens/preferences_screen.dart';
import 'package:news_flutter_app/view/screens/profile_screen.dart';
import 'package:news_flutter_app/view/screens/top_headline_screen.dart';
import 'package:news_flutter_app/view/widgets/authentication_view.dart';
import 'package:news_flutter_app/viewmodel/profile_viewmodel.dart';
import 'package:provider/provider.dart';

// Tutorial : https://flutter.dev/docs/cookbook/testing/integration/scrolling
// Integrating Test : https://burhanrashid52.com/2021/03/26/migrating-to-integration-tests-in-flutter/


class MockViewModel extends Mock implements ProfileViewModel {}

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
      'Profile Screen - Tap on create new account button, show popup signup', 
      (WidgetTester tester) async {
        final vm = ProfileViewModel();
        vm.createNewAccount('bluezf1', '123123');
        vm.login('bluezf1', '123123');
        await tester.pumpWidget(
            ChangeNotifierProvider(
                create: (context) => vm,
                child: MaterialApp(
                  home: Scaffold(
                    body: ProfileScreen(),
                  )))
          );


        final createNewAccountTextFinder = find.byKey(Key('login-create-new-account-text'));
        // await tester.tap(createNewAccountTextFinder);

        expect(createNewAccountTextFinder, findsOneWidget);
      });

  testWidgets(
    'Test if user scroll down to reach 10 articles, '
    'a loading indicator will show to inform that app are performing load more',
    (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TopHeadlineScreen(),
            ),
          )
        );
        print('A');
        final listFinder = find.byKey(Key('listViewTopHeadlines'));
        print('B');
        sleep(Duration(seconds: 3));
        print('B-1');
        await tester.ensureVisible(find.byKey(Key('article-1')));
        print('B-2');
        await tester.scrollUntilVisible(listFinder, 1000.0);
        print('B-3');
        tester.pumpAndSettle();
        print('C');
        expect(find.byKey(Key('loadMoreLoading')), findsOneWidget);

      });
    },
  );
}