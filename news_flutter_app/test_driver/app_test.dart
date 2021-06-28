import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Top HeadLine Screen - Test intergration', () {
    final loadMoreLoadingFinder = find.byValueKey('loadMoreLoading');
    final loadMoreFailedTextFinder = find.byValueKey('loadMoreFailed');

    late FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      driver.close();
    });

    test('Start page - did not show', () async {
      expect(await driver.getText(loadMoreFailedTextFinder), null);
    });

    test('Test if page have load more indicator when scroll down at the end', () async {
      final listViewTopHeadlinesFinder = find.byValueKey('listViewTopHeadlines');
      final loadingMoreIndicatorFinder = find.byValueKey('loadMoreLoading');
      await driver.scrollUntilVisible(
        // Scroll through the list
        listViewTopHeadlinesFinder,
        // Until finding this item
        loadingMoreIndicatorFinder,
        // To scroll down the list, provide a negative value to dyScroll.
        // Ensure that this value is a small enough increment to
        // scroll the item into view without potentially scrolling past it.
        //
        // To scroll through horizontal lists, provide a dxScroll
        // property instead.
        dyScroll: -1000.0,
      );
      // await driver.waitFor(finder)
      // expect(loadingMoreIndicatorFinder);
      // expect(driver.en, matcher)
    });

  });
}