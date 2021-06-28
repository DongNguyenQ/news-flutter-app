import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_flutter_app/view/screens/profile_screen.dart';
import 'package:news_flutter_app/view/widgets/authentication_view.dart';

void main() {
  final loginFunc = (String username, String password) => print('Login');
  group('USER PROFILE - test input ', () {
    testWidgets('Test username input', (WidgetTester tester) async {
      await tester.pumpWidget(LoginView(login: loginFunc));
      // await tester.enterText(find.byKey(Key('signup-username')), '123');
      expect(find.text('You have not signed in yet'), findsOneWidget);
    });
  });
}